
library ieee;
use ieee.std_logic_1164.all;

library grlib;
use grlib.amba.all;

package tmx is

  component tmxmsf is
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
  end component tmxmsf;

end;
