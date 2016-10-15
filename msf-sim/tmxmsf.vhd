------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2014, Aeroflex Gaisler
--  Copyright (C) 2016       , Martin Wilson <mrw@trimetix.co.uk>
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-------------------------------------------------------------------------------
-- Entity:      TRIMETIX_MSF
-- File:        TMXMSF.vhd
-- Author:      Martin Wilson
-- Contact:     mrw@trimetix.co.uk
-- Description: MSF Radio Time Decoder
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.amba.all;
use grlib.devices.all;
use grlib.stdlib.all;

--library trimetix;
--use trimetix.tmxmisc.all;

entity tmxmsf is
  generic (
    -- APB generics
    pindex   : integer                    := 0;          -- slave bus index
    paddr    : integer                    := 0;
    pmask    : integer                    := 16#fff#;
    pirq     : integer                    := 0;          -- interrupt index
    sbits    : integer range 12 to 32     := 20;
    divisor  : integer range 0 to 1048575 := 632911;
    fifosize : integer range 0 to 7       := 1;
    clk_freq : positive                   := 50000000);  -- clock frequency in Hz

  port (
    rstn : in std_ulogic;
    clk  : in std_ulogic;

    -- APB signals
    apbi : in  apb_slv_in_type;
    apbo : out apb_slv_out_type;

    -- MSF signal
    tsignal : in std_logic
    );
end entity tmxmsf;

architecture rtl of tmxmsf is
  -----------------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------------

  constant TRIMETIX_MSF_REV : integer := 0;

  constant PCONFIG : apb_config_type := (
    0 => ahb_device_reg(VENDOR_TRIMETIX, TRIMETIX_MSF, 0, TRIMETIX_MSF_REV, pirq),
    1 => apb_iobar(paddr, pmask));

  constant CTRL_addr : std_logic_vector(7 downto 2) := "000000";
  constant STAT_addr : std_logic_vector(7 downto 2) := "000001";
  constant DATE_addr : std_logic_vector(7 downto 2) := "000010";
  constant TIME_addr : std_logic_vector(7 downto 2) := "000011";
  constant MISC_addr : std_logic_vector(7 downto 2) := "000100";

  constant DIAG0_addr : std_logic_vector(7 downto 2) := "000101";
  constant DIAG1_addr : std_logic_vector(7 downto 2) := "000110";
  constant DIAG2_addr : std_logic_vector(7 downto 2) := "000111";
  constant DIAG3_addr : std_logic_vector(7 downto 2) := "001000";

  constant PARITY_OK : std_logic_vector(3 downto 0) := "1111";
  constant MARKER_OK : std_logic_vector(7 downto 0) := "01111110";

  constant sbitszero : std_logic_vector(sbits-1 downto 0) := (others => '0');

  type rxfsmtype is (idle, startbit, data, stopbit);
  type fifo is array (0 to fifosize - 1) of std_logic_vector(7 downto 0);

  constant fifozero : fifo                                       := (others => (others => '0'));
  constant rcntzero : std_logic_vector(log2x(fifosize) downto 0) := (others => '0');


  -----------------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------------
  function xor_bits(slv : unsigned) return std_logic is
    variable l : std_logic := '0';
  begin

    for i in slv'range loop
      l := l xor slv(i);
    end loop;

    return l;

  end function xor_bits;
  -----------------------------------------------------------------------------
  -- Types 
  -----------------------------------------------------------------------------
  -- Register interface
  type ctrl_reg_type is record          -- Control register
    en : std_ulogic;                    -- Enable
  end record;

  type stat_reg_type is record          -- Status register
    ready : std_ulogic;                 -- Ready
    valid : std_ulogic;                 -- Data valid
  end record;

  type date_reg_type is record          -- Date register
    yyf : std_logic_vector(7 downto 0);
    yyv : std_logic_vector(7 downto 0);
    mm  : std_logic_vector(7 downto 0);
    dd  : std_logic_vector(7 downto 0);
  end record;

  type time_reg_type is record          -- Time register
    hh      : std_logic_vector(7 downto 0);
    mm      : std_logic_vector(7 downto 0);
    ss      : std_logic_vector(7 downto 0);
    bstpend : std_ulogic;
    bstact  : std_ulogic;
  end record;

  type misc_reg_type is record          -- Misc register
    dut1 : integer range -800 to 800;
    dow  : std_logic_vector(3 downto 0);
  end record;

  type msf_reg_type is record           -- MSF Registers
    minute     : boolean;
    second     : boolean;
    valid_bits : integer range 0 to 63;
    ctrl_r     : ctrl_reg_type;
    stat_r     : stat_reg_type;
    date_r     : date_reg_type;
    time_r     : time_reg_type;
    misc_r     : misc_reg_type;
    abits      : std_logic_vector(0 to 63);
    bbits      : std_logic_vector(0 to 63);
    parity     : std_logic_vector(3 downto 0);
    marker     : std_logic_vector(7 downto 0);
    rxstate    : rxfsmtype;
    rxclk      : std_logic_vector(2 downto 0);  -- rx clock divider
    rxdb       : std_logic_vector(1 downto 0);  -- rx delay
    rxtick     : std_ulogic;            -- rx clock (internal)
    tick       : std_ulogic;            -- rx clock (internal)
    scaler     : std_logic_vector(sbits-1 downto 0);
    brate      : std_logic_vector(sbits-1 downto 0);
    rxf        : std_logic_vector(4 downto 0);  --  rx data filtering buffer
    rsempty    : std_ulogic;  -- receiver shift register empty (internal)
    rhold      : fifo;
    rshift     : std_logic_vector(7 downto 0);
    rwaddr     : std_logic_vector(log2x(fifosize) - 1 downto 0);
    rcnt       : std_logic_vector(log2x(fifosize) downto 0);
    break      : std_ulogic;            -- break detected
    ovf        : std_ulogic;            -- receiver overflow
    parerr     : std_ulogic;            -- parity error
    frame      : std_ulogic;            -- framing error
    dpar       : std_ulogic;            -- rx data parity (internal)

  end record;

  -- Register interface
  signal r, rin : msf_reg_type;

begin

  comb : process (r, rstn, apbi, tsignal)
    variable v       : msf_reg_type;
    variable apbaddr : std_logic_vector(7 downto 2)       := (others => '0');
    variable apbout  : std_logic_vector(31 downto 0)      := (others => '0');
    variable rxclk   : std_logic_vector(2 downto 0)       := (others => '0');
    variable scaler  : std_logic_vector(sbits-1 downto 0) := (others => '0');
    variable rxd     : std_ulogic                         := '0';

    variable rhalffull : std_ulogic;
    variable rfull     : std_ulogic;
    variable tfull     : std_ulogic;
    variable dready    : std_ulogic;

  begin

    v       := r;
    apbaddr := apbi.paddr(7 downto 2);
    apbout  := (others => '0');

    v.rxtick  := '0';
    v.tick    := '0';
    v.rxdb(1) := r.rxdb(0);
    dready    := '0';
    rhalffull := '0';


    -- scaler
    scaler := r.scaler - 1;
    if r.ctrl_r.en = '1' then
      v.scaler := scaler;
      v.tick   := scaler(sbits-1) and not r.scaler(sbits-1);
      if v.tick = '1' then
        v.scaler := r.brate;
      end if;
    end if;

    -- rx clock
    rxclk := r.rxclk + 1;
    if r.tick = '1' then
      v.rxclk  := rxclk;
      v.rxtick := r.rxclk(2) and not rxclk(2);
    end if;

    v.rxf(1 downto 0) := r.rxf(0) & tsignal;  -- meta-stability filter

    if r.tick = '1' then
      v.rxf(4 downto 2) := r.rxf(3 downto 1);
    end if;
    v.rxdb(0) := (r.rxf(4) and r.rxf(3)) or (r.rxf(4) and r.rxf(2)) or
                 (r.rxf(3) and r.rxf(2));

    rxd := r.rxdb(0);


    -- receiver operation

    case r.rxstate is

      when idle =>                      -- wait for start bit
        if ((r.rsempty = '0') and not (rfull = '1')) then
          v.rsempty                       := '1';
          v.rhold(conv_integer(r.rwaddr)) := r.rshift;
          v.rcnt(0)                       := '1';
        end if;
        if (r.ctrl_r.en and r.rxdb(1) and (not rxd)) = '1' then
          v.rxstate := startbit;
          v.rshift  := (others => '1');
          v.rxclk   := "100";
          if v.rsempty = '0' then
            v.ovf := '1';
          end if;
          v.rsempty := '0';
          v.rxtick  := '0';
        end if;
      when startbit =>                  -- check validity of start bit
        if r.rxtick = '1' then
          if rxd = '0' then
            v.rshift  := rxd & r.rshift(7 downto 1);
            v.rxstate := data;
          else
            v.rxstate := idle;
          end if;
        end if;

      when data =>                      -- receive data frame
        if r.rxtick = '1' then
          v.rshift := rxd & r.rshift(7 downto 1);
          if r.rshift(0) = '0' then
            v.rxstate := stopbit;
          end if;
        end if;

      when stopbit =>                   -- receive stop bit
        if r.rxtick = '1' then
          if rxd = '1' then
            v.parerr  := r.parerr or r.dpar;
            v.rsempty := r.dpar;
            if not (rfull = '1') and (r.dpar = '0') then
              v.rsempty                       := '1';
              v.rhold(conv_integer(r.rwaddr)) := r.rshift;
              if fifosize = 1 then
                v.rcnt(0) := '1';
              else
                v.rwaddr := r.rwaddr + 1;
                v.rcnt   := v.rcnt + 1;
              end if;
            end if;
          else
            if r.rshift = "00000000" then
              v.break := '1';
            else
              v.frame := '1';
            end if;
            v.rsempty := '1';
          end if;
          v.rxstate := idle;
        end if;
    end case;

    -- read registers
    if (apbi.psel(pindex) and apbi.penable and (not apbi.pwrite)) = '1' then
      case apbaddr is
        when CTRL_addr =>
          apbout(0) := r.ctrl_r.en;
        when STAT_addr =>
          apbout(1 downto 0) := r.stat_r.valid & r.stat_r.ready;
        when DATE_addr =>
          apbout := r.date_r.yyf & r.date_r.yyv & r.date_r.mm & r.date_r.dd;
        when TIME_addr =>
          apbout(31 downto 8) := r.time_r.hh & r.time_r.mm & r.time_r.ss;
          apbout(1)           := r.time_r.bstpend;
          apbout(0)           := r.time_r.bstact;
        when DIAG0_addr =>
          apbout := r.abits(0 to 31);
        when DIAG1_addr =>
          apbout := r.abits(32 to 63);
        when DIAG2_addr =>
          apbout := r.bbits(0 to 31);
        when DIAG3_addr =>
          apbout := r.bbits(32 to 63);
        when others => null;
      end case;
    end if;

    -- write registers
    if (apbi.psel(pindex) and apbi.penable and apbi.pwrite) = '1' then
      case apbaddr is
        when CTRL_addr =>
          v.ctrl_r.en := apbi.pwdata(0);
        when others => null;
      end case;
    end if;

    -- Handle reset

    if rstn = '0' then
      v.valid_bits     := 1;
      v.minute         := false;
      v.second         := false;
      -- Control Register
      v.ctrl_r.en      := '1';
      -- Status Register
      v.stat_r.ready   := '0';
      v.stat_r.valid   := '0';
      -- Date Register
      v.date_r.yyf     := X"20";
      v.date_r.yyv     := (others => '0');
      v.date_r.mm      := (others => '0');
      v.date_r.dd      := (others => '0');
      -- Time Register
      v.time_r.hh      := (others => '0');
      v.time_r.mm      := (others => '0');
      v.time_r.ss      := (others => '0');
      v.time_r.bstpend := '0';
      v.time_r.bstact  := '0';
      -- Misc Register
      v.misc_r.dut1    := 0;
      v.misc_r.dow     := (others => '0');
      v.abits          := (others => '0');
      v.bbits          := (others => '0');
      v.parity         := (others => '0');
      v.marker         := (others => '0');

      v.rxstate := idle;
      v.rxclk   := (others => '0');
      v.rxdb    := (others => '0');
      v.rxtick  := '0';
      v.tick    := '0';
      v.scaler  := std_logic_vector(to_unsigned(divisor, v.scaler'length));
      v.brate   := std_logic_vector(to_unsigned(divisor, v.scaler'length));
      v.rxf     := (others => '0');
      v.rsempty := '1';
      v.rhold   := fifozero;
      v.rshift  := (others => '0');
      v.rwaddr  := (others => '0');
      v.rcnt    := rcntzero;

      v.break  := '0';
      v.ovf    := '0';
      v.parerr := '0';
      v.frame  := '0';
      v.dpar   := '0';
    end if;

    -- Update registers
    rin <= v;

    -- Update outputs
    apbo.prdata  <= apbout;
    apbo.pirq    <= (others => '0');
    apbo.pconfig <= PCONFIG;
    apbo.pindex  <= pindex;

  end process comb;

  reg : process (clk)
  begin  -- process reg
    if rising_edge(clk) then
      r <= rin;
    end if;
  end process reg;

  -- Boot message  variable scaler : std_logic_vector(sbits-1 downto 0);
  -- pragma translate_off
  bootmsg : report_version
    generic map (
      "tmxmsf" & tost(pindex) & ": AMBA MSF Controller " &
      tost(TRIMETIX_MSF_REV) & ", irq " & tost(pirq));
  -- pragma translate_on

end architecture rtl;





--        v.parity(3) := xor_bits(unsigned (r.abits(17 to 24) & r.bbits(54)));
--        v.parity(2) := xor_bits(unsigned (r.abits(25 to 35) & r.bbits(55)));
--        v.parity(1) := xor_bits(unsigned (r.abits(36 to 38) & r.bbits(56)));
--        v.parity(0) := xor_bits(unsigned (r.abits(39 to 51) & r.bbits(57)));
--        v.marker    := r.abits(52 to 59);
--            if (r.parity = PARITY_OK) and (r.marker = MARKER_OK) then
--
--              -- We got a valid frame, update our registers
--              v.date_r.yyv     := r.abits(17 to 24);
--              v.date_r.mm      := "000" & r.abits(25 to 29);
--              v.date_r.dd      := "00" & r.abits(30 to 35);
--              v.time_r.hh      := "00" & r.abits(39 to 44);
--              v.time_r.mm      := "0" & r.abits(45 to 51);
--              v.time_r.ss      := (others => '0');
--              v.time_r.bstpend := r.bbits(53);
--              v.time_r.bstact  := r.bbits(58);
--              v.misc_r.dow     := "0" & r.abits(36 to 38);
--              v.stat_r.valid   := '1';
--
--          end if;

