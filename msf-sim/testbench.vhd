-----------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
--  Copyright (C) 2004 Jiri Gaisler, Gaisler Research
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2013, Aeroflex Gaisler
--  Copyright (C) 2014,2015 Martin Wilson
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
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library grlib;
use grlib.amba.all;

--library gaisler;
--use gaisler.libdcom.all;
--use gaisler.sim.all;
--use work.debug.all;
--library techmap;
--use techmap.gencomp.all;

--library trimetix;
--use trimetix.tmxmisc.all;

--use work.config.all;                    -- configuration

use work.tmx.all;

entity testbench is
  generic (
    clkperiod : integer := 20           -- system clock period
    );
end;

architecture behav of testbench is

  signal clk     : std_logic := '0';
  signal clk_rst : std_logic := '1';
  constant ct    : integer   := clkperiod/2;

  signal dsurst : std_logic := '0';

  signal gnd : std_logic := '0';
  signal vcc : std_logic := '1';

  signal apbi : apb_slv_in_type    := apb_slv_in_none;       --
  signal apbo : apb_slv_out_vector := (others => apb_none);  --

  signal time_sig : std_logic := '1';

begin

-- clock and reset

  clk <= not clk after ct * 1 ns;       --50 MHz clk 


----------------------------------------------------------------------
---                           MSF Decoder                          ---
----------------------------------------------------------------------

  msf1 : entity work.tmxmsf
    generic map(pindex => 12, paddr => 12, pirq => 0, divisor => 5)
    port map(rstn      => dsurst, clk => clk, apbi => apbi, apbo => apbo(12), tsignal => time_sig);

  process
  begin

    dsurst <= '0';                      --reset low
    wait for 500 ns;
    dsurst <= '1';                      --reset high
    wait;

  end process;


  tsig : process
  begin
    wait until dsurst = '1';
    wait for 5000 ns;
    time_sig <= not time_sig; wait for 1184 ns;
    time_sig <= not time_sig; wait for 8715 ns;
    time_sig <= not time_sig; wait for 1207 ns;
    time_sig <= not time_sig; wait for 8887 ns;
    time_sig <= not time_sig; wait for 971 ns;
    time_sig <= not time_sig; wait for 8943 ns;
    time_sig <= not time_sig; wait for 1142 ns;
    time_sig <= not time_sig; wait for 875 ns;
    time_sig <= not time_sig; wait for 1110 ns;
    time_sig <= not time_sig; wait for 6995 ns;
    time_sig <= not time_sig; wait for 886 ns;
    time_sig <= not time_sig; wait for 1119 ns;
    time_sig <= not time_sig; wait for 1260 ns;
    time_sig <= not time_sig; wait for 6601 ns;
    time_sig <= not time_sig; wait for 1179 ns;
    time_sig <= not time_sig; wait for 835 ns;
    time_sig <= not time_sig; wait for 1117 ns;
    time_sig <= not time_sig; wait for 7000 ns;
    time_sig <= not time_sig; wait for 915 ns;
    time_sig <= not time_sig; wait for 8942 ns;
    time_sig <= not time_sig; wait for 1189 ns;
    time_sig <= not time_sig; wait for 8950 ns;
    time_sig <= not time_sig; wait for 1079 ns;
    time_sig <= not time_sig; wait for 8803 ns;
    time_sig <= not time_sig; wait for 1185 ns;
    time_sig <= not time_sig; wait for 8966 ns;
    time_sig <= not time_sig; wait for 951 ns;
    time_sig <= not time_sig; wait for 8919 ns;
    time_sig <= not time_sig; wait for 1166 ns;
    time_sig <= not time_sig; wait for 8916 ns;
    time_sig <= not time_sig; wait for 915 ns;
    time_sig <= not time_sig; wait for 8967 ns;
    time_sig <= not time_sig; wait for 1194 ns;
    time_sig <= not time_sig; wait for 8935 ns;
    time_sig <= not time_sig; wait for 1898 ns;
    time_sig <= not time_sig; wait for 7979 ns;
    time_sig <= not time_sig; wait for 1248 ns;
    time_sig <= not time_sig; wait for 8909 ns;
    time_sig <= not time_sig; wait for 1963 ns;
    time_sig <= not time_sig; wait for 7926 ns;
    time_sig <= not time_sig; wait for 2162 ns;
    time_sig <= not time_sig; wait for 7996 ns;
    time_sig <= not time_sig; wait for 935 ns;
    time_sig <= not time_sig; wait for 8907 ns;
    time_sig <= not time_sig; wait for 2149 ns;
    time_sig <= not time_sig; wait for 7992 ns;
    time_sig <= not time_sig; wait for 905 ns;
    time_sig <= not time_sig; wait for 8920 ns;
    time_sig <= not time_sig; wait for 1188 ns;
    time_sig <= not time_sig; wait for 8896 ns;
    time_sig <= not time_sig; wait for 990 ns;
    time_sig <= not time_sig; wait for 8938 ns;
    time_sig <= not time_sig; wait for 1209 ns;
    time_sig <= not time_sig; wait for 8868 ns;
    time_sig <= not time_sig; wait for 1033 ns;
    time_sig <= not time_sig; wait for 8920 ns;
    time_sig <= not time_sig; wait for 1233 ns;
    time_sig <= not time_sig; wait for 8820 ns;
    time_sig <= not time_sig; wait for 997 ns;
    time_sig <= not time_sig; wait for 8948 ns;
    time_sig <= not time_sig; wait for 2230 ns;
    time_sig <= not time_sig; wait for 7869 ns;
    time_sig <= not time_sig; wait for 906 ns;
    time_sig <= not time_sig; wait for 8977 ns;
    time_sig <= not time_sig; wait for 2179 ns;
    time_sig <= not time_sig; wait for 7875 ns;
    time_sig <= not time_sig; wait for 995 ns;
    time_sig <= not time_sig; wait for 8959 ns;
    time_sig <= not time_sig; wait for 2200 ns;
    time_sig <= not time_sig; wait for 7827 ns;
    time_sig <= not time_sig; wait for 2027 ns;
    time_sig <= not time_sig; wait for 7992 ns;
    time_sig <= not time_sig; wait for 1182 ns;
    time_sig <= not time_sig; wait for 8856 ns;
    time_sig <= not time_sig; wait for 1999 ns;
    time_sig <= not time_sig; wait for 7993 ns;
    time_sig <= not time_sig; wait for 1116 ns;
    time_sig <= not time_sig; wait for 8846 ns;
    time_sig <= not time_sig; wait for 1045 ns;
    time_sig <= not time_sig; wait for 8961 ns;
    time_sig <= not time_sig; wait for 2166 ns;
    time_sig <= not time_sig; wait for 7803 ns;
    time_sig <= not time_sig; wait for 1082 ns;
    time_sig <= not time_sig; wait for 8968 ns;
    time_sig <= not time_sig; wait for 1210 ns;
    time_sig <= not time_sig; wait for 8769 ns;
    time_sig <= not time_sig; wait for 1077 ns;
    time_sig <= not time_sig; wait for 8960 ns;
    time_sig <= not time_sig; wait for 1263 ns;
    time_sig <= not time_sig; wait for 8682 ns;
    time_sig <= not time_sig; wait for 1121 ns;
    time_sig <= not time_sig; wait for 8961 ns;
    time_sig <= not time_sig; wait for 1080 ns;
    time_sig <= not time_sig; wait for 8789 ns;
    time_sig <= not time_sig; wait for 2092 ns;
    time_sig <= not time_sig; wait for 8027 ns;
    time_sig <= not time_sig; wait for 1204 ns;
    time_sig <= not time_sig; wait for 8692 ns;
    time_sig <= not time_sig; wait for 1137 ns;
    time_sig <= not time_sig; wait for 8970 ns;
    time_sig <= not time_sig; wait for 2179 ns;
    time_sig <= not time_sig; wait for 7733 ns;
    time_sig <= not time_sig; wait for 2132 ns;
    time_sig <= not time_sig; wait for 7964 ns;
    time_sig <= not time_sig; wait for 2078 ns;
    time_sig <= not time_sig; wait for 7852 ns;
    time_sig <= not time_sig; wait for 3072 ns;
    time_sig <= not time_sig; wait for 7000 ns;
    time_sig <= not time_sig; wait for 2042 ns;
    time_sig <= not time_sig; wait for 7841 ns;
    time_sig <= not time_sig; wait for 3097 ns;
    time_sig <= not time_sig; wait for 7011 ns;
    time_sig <= not time_sig; wait for 1094 ns;
    time_sig <= not time_sig; wait for 8785 ns;
    time_sig <= not time_sig; wait for 5077 ns;
    time_sig <= not time_sig; wait for 5080 ns;
    time_sig <= not time_sig; wait for 1067 ns;
    time_sig <= not time_sig; wait for 8824 ns;
    time_sig <= not time_sig; wait for 1147 ns;
    time_sig <= not time_sig; wait for 8935 ns;
    time_sig <= not time_sig; wait for 960 ns;
    time_sig <= not time_sig; wait for 8929 ns;
    time_sig <= not time_sig; wait for 1177 ns;
    time_sig <= not time_sig; wait for 8958 ns;
    time_sig <= not time_sig; wait for 973 ns;
    time_sig <= not time_sig; wait for 8913 ns;
    time_sig <= not time_sig; wait for 1173 ns;
    time_sig <= not time_sig; wait for 8928 ns;
    time_sig <= not time_sig; wait for 991 ns;
    time_sig <= not time_sig; wait for 8880 ns;
    time_sig <= not time_sig; wait for 1195 ns;
    time_sig <= not time_sig; wait for 8974 ns;
    time_sig <= not time_sig; wait for 947 ns;
    time_sig <= not time_sig; wait for 1013 ns;
    time_sig <= not time_sig; wait for 1016 ns;
    time_sig <= not time_sig; wait for 6884 ns;
    time_sig <= not time_sig; wait for 1188 ns;
    time_sig <= not time_sig; wait for 793 ns;
    time_sig <= not time_sig; wait for 1127 ns;
    time_sig <= not time_sig; wait for 7021 ns;
    time_sig <= not time_sig; wait for 1009 ns;
    time_sig <= not time_sig; wait for 956 ns;
    time_sig <= not time_sig; wait for 1097 ns;
    time_sig <= not time_sig; wait for 6801 ns;
    time_sig <= not time_sig; wait for 1128 ns;
    time_sig <= not time_sig; wait for 8985 ns;
    time_sig <= not time_sig; wait for 944 ns;
    time_sig <= not time_sig; wait for 8962 ns;
    time_sig <= not time_sig; wait for 1165 ns;
    time_sig <= not time_sig; wait for 8901 ns;
    time_sig <= not time_sig; wait for 1001 ns;
    time_sig <= not time_sig; wait for 8941 ns;
    time_sig <= not time_sig; wait for 1230 ns;
    time_sig <= not time_sig; wait for 8892 ns;
    time_sig <= not time_sig; wait for 915 ns;
    time_sig <= not time_sig; wait for 8972 ns;
    time_sig <= not time_sig; wait for 1221 ns;
    time_sig <= not time_sig; wait for 8873 ns;
    time_sig <= not time_sig; wait for 946 ns;
    time_sig <= not time_sig; wait for 8954 ns;
    time_sig <= not time_sig; wait for 2118 ns;
    time_sig <= not time_sig; wait for 8020 ns;
    time_sig <= not time_sig; wait for 897 ns;
    time_sig <= not time_sig; wait for 8960 ns;
    time_sig <= not time_sig; wait for 2145 ns;
    time_sig <= not time_sig; wait for 7973 ns;
    time_sig <= not time_sig; wait for 1929 ns;
    time_sig <= not time_sig; wait for 7966 ns;
    time_sig <= not time_sig; wait for 1265 ns;
    time_sig <= not time_sig; wait for 8828 ns;
    time_sig <= not time_sig; wait for 1997 ns;
    time_sig <= not time_sig; wait for 7963 ns;
    time_sig <= not time_sig; wait for 1155 ns;
    time_sig <= not time_sig; wait for 8841 ns;
    time_sig <= not time_sig; wait for 1043 ns;
    time_sig <= not time_sig; wait for 8916 ns;
    time_sig <= not time_sig; wait for 1198 ns;
    time_sig <= not time_sig; wait for 8843 ns;
    time_sig <= not time_sig; wait for 1013 ns;
    time_sig <= not time_sig; wait for 8955 ns;
    time_sig <= not time_sig; wait for 1207 ns;
    time_sig <= not time_sig; wait for 8776 ns;
    time_sig <= not time_sig; wait for 1053 ns;
    time_sig <= not time_sig; wait for 8974 ns;
    time_sig <= not time_sig; wait for 1293 ns;
    time_sig <= not time_sig; wait for 8775 ns;
    time_sig <= not time_sig; wait for 1968 ns;
    time_sig <= not time_sig; wait for 8013 ns;
    time_sig <= not time_sig; wait for 1235 ns;
    time_sig <= not time_sig; wait for 8827 ns;
    time_sig <= not time_sig; wait for 1943 ns;
    time_sig <= not time_sig; wait for 7958 ns;
    time_sig <= not time_sig; wait for 1182 ns;
    time_sig <= not time_sig; wait for 8877 ns;
    time_sig <= not time_sig; wait for 1971 ns;
    time_sig <= not time_sig; wait for 7964 ns;
    time_sig <= not time_sig; wait for 2164 ns;
    time_sig <= not time_sig; wait for 7844 ns;
    time_sig <= not time_sig; wait for 1039 ns;
    time_sig <= not time_sig; wait for 8977 ns;
    time_sig <= not time_sig; wait for 2152 ns;
    time_sig <= not time_sig; wait for 7786 ns;
    time_sig <= not time_sig; wait for 1129 ns;
    time_sig <= not time_sig; wait for 8951 ns;
    time_sig <= not time_sig; wait for 1194 ns;
    time_sig <= not time_sig; wait for 8812 ns;
    time_sig <= not time_sig; wait for 2007 ns;
    time_sig <= not time_sig; wait for 7981 ns;
    time_sig <= not time_sig; wait for 1163 ns;
    time_sig <= not time_sig; wait for 8802 ns;
    time_sig <= not time_sig; wait for 1068 ns;
    time_sig <= not time_sig; wait for 8967 ns;
    time_sig <= not time_sig; wait for 1170 ns;
    time_sig <= not time_sig; wait for 8778 ns;
    time_sig <= not time_sig; wait for 1074 ns;
    time_sig <= not time_sig; wait for 8976 ns;
    time_sig <= not time_sig; wait for 1290 ns;
    time_sig <= not time_sig; wait for 8656 ns;
    time_sig <= not time_sig; wait for 1126 ns;
    time_sig <= not time_sig; wait for 8958 ns;
    time_sig <= not time_sig; wait for 2180 ns;
    time_sig <= not time_sig; wait for 7738 ns;
    time_sig <= not time_sig; wait for 2115 ns;
    time_sig <= not time_sig; wait for 7963 ns;
    time_sig <= not time_sig; wait for 1110 ns;
    time_sig <= not time_sig; wait for 8802 ns;
    time_sig <= not time_sig; wait for 2073 ns;
    time_sig <= not time_sig; wait for 8002 ns;
    time_sig <= not time_sig; wait for 2167 ns;
    time_sig <= not time_sig; wait for 7774 ns;
    time_sig <= not time_sig; wait for 2088 ns;
    time_sig <= not time_sig; wait for 7995 ns;
    time_sig <= not time_sig; wait for 3081 ns;
    time_sig <= not time_sig; wait for 6819 ns;
    time_sig <= not time_sig; wait for 3088 ns;
    time_sig <= not time_sig; wait for 7023 ns;
    time_sig <= not time_sig; wait for 3072 ns;
    time_sig <= not time_sig; wait for 6854 ns;
    time_sig <= not time_sig; wait for 1126 ns;
    time_sig <= not time_sig; wait for 8928 ns;
    time_sig <= not time_sig; wait for 5082 ns;
    time_sig <= not time_sig; wait for 4834 ns;
    time_sig <= not time_sig; wait for 1129 ns;
    time_sig <= not time_sig; wait for 8967 ns;
    time_sig <= not time_sig; wait for 1025 ns;
    time_sig <= not time_sig; wait for 8872 ns;
    time_sig <= not time_sig; wait for 1175 ns;
    time_sig <= not time_sig; wait for 8974 ns;
    time_sig <= not time_sig; wait for 1285 ns;
    time_sig <= not time_sig; wait for 8582 ns;
    time_sig <= not time_sig; wait for 1169 ns;
    time_sig <= not time_sig; wait for 8982 ns;
    time_sig <= not time_sig; wait for 934 ns;
    time_sig <= not time_sig; wait for 8918 ns;
    time_sig <= not time_sig; wait for 1183 ns;
    time_sig <= not time_sig; wait for 8944 ns;
    time_sig <= not time_sig; wait for 956 ns;
    time_sig <= not time_sig; wait for 8899 ns;
    time_sig <= not time_sig; wait for 1165 ns;
    time_sig <= not time_sig; wait for 896 ns;
    time_sig <= not time_sig; wait for 1105 ns;
    time_sig <= not time_sig; wait for 7000 ns;
    time_sig <= not time_sig; wait for 934 ns;
    time_sig <= not time_sig; wait for 1047 ns;
    time_sig <= not time_sig; wait for 945 ns;
    time_sig <= not time_sig; wait for 6927 ns;
    time_sig <= not time_sig; wait for 1221 ns;
    time_sig <= not time_sig; wait for 812 ns;
    time_sig <= not time_sig; wait for 1102 ns;
    time_sig <= not time_sig; wait for 6993 ns;
    time_sig <= not time_sig; wait for 1072 ns;
    time_sig <= not time_sig; wait for 8828 ns;
    time_sig <= not time_sig; wait for 1161 ns;
    time_sig <= not time_sig; wait for 8950 ns;
    time_sig <= not time_sig; wait for 930 ns;
    time_sig <= not time_sig; wait for 8952 ns;
    time_sig <= not time_sig; wait for 1190 ns;
    time_sig <= not time_sig; wait for 8939 ns;
    time_sig <= not time_sig; wait for 888 ns;
    time_sig <= not time_sig; wait for 8986 ns;
    time_sig <= not time_sig; wait for 1192 ns;
    time_sig <= not time_sig; wait for 8936 ns;
    time_sig <= not time_sig; wait for 923 ns;
    time_sig <= not time_sig; wait for 8938 ns;
    time_sig <= not time_sig; wait for 1197 ns;
    time_sig <= not time_sig; wait for 8922 ns;
    time_sig <= not time_sig; wait for 1932 ns;
    time_sig <= not time_sig; wait for 7976 ns;
    time_sig <= not time_sig; wait for 1236 ns;
    time_sig <= not time_sig; wait for 8832 ns;
    time_sig <= not time_sig; wait for 1988 ns;
    time_sig <= not time_sig; wait for 7949 ns;
    time_sig <= not time_sig; wait for 2159 ns;
    time_sig <= not time_sig; wait for 7928 ns;
    time_sig <= not time_sig; wait for 950 ns;
    time_sig <= not time_sig; wait for 8962 ns;
    time_sig <= not time_sig; wait for 2213 ns;
    time_sig <= not time_sig; wait for 7842 ns;
    time_sig <= not time_sig; wait for 985 ns;
    time_sig <= not time_sig; wait for 8961 ns;
    time_sig <= not time_sig; wait for 1232 ns;
    time_sig <= not time_sig; wait for 8815 ns;
    time_sig <= not time_sig; wait for 1016 ns;
    time_sig <= not time_sig; wait for 8955 ns;
    time_sig <= not time_sig; wait for 1253 ns;
    time_sig <= not time_sig; wait for 8834 ns;
    time_sig <= not time_sig; wait for 990 ns;
    time_sig <= not time_sig; wait for 8936 ns;
    time_sig <= not time_sig; wait for 1196 ns;
    time_sig <= not time_sig; wait for 8848 ns;
    time_sig <= not time_sig; wait for 989 ns;
    time_sig <= not time_sig; wait for 8983 ns;
    time_sig <= not time_sig; wait for 2116 ns;
    time_sig <= not time_sig; wait for 7869 ns;
    time_sig <= not time_sig; wait for 1004 ns;
    time_sig <= not time_sig; wait for 8988 ns;
    time_sig <= not time_sig; wait for 2217 ns;
    time_sig <= not time_sig; wait for 7805 ns;
    time_sig <= not time_sig; wait for 1034 ns;
    time_sig <= not time_sig; wait for 8944 ns;
    time_sig <= not time_sig; wait for 2169 ns;
    time_sig <= not time_sig; wait for 7852 ns;
    time_sig <= not time_sig; wait for 2029 ns;
    time_sig <= not time_sig; wait for 7983 ns;
    time_sig <= not time_sig; wait for 1159 ns;
    time_sig <= not time_sig; wait for 8849 ns;
    time_sig <= not time_sig; wait for 2040 ns;
    time_sig <= not time_sig; wait for 7957 ns;
    time_sig <= not time_sig; wait for 1090 ns;
    time_sig <= not time_sig; wait for 8835 ns;
    time_sig <= not time_sig; wait for 1108 ns;
    time_sig <= not time_sig; wait for 8953 ns;
    time_sig <= not time_sig; wait for 2205 ns;
    time_sig <= not time_sig; wait for 7763 ns;
    time_sig <= not time_sig; wait for 1097 ns;
    time_sig <= not time_sig; wait for 8953 ns;
    time_sig <= not time_sig; wait for 1293 ns;
    time_sig <= not time_sig; wait for 8667 ns;
    time_sig <= not time_sig; wait for 1100 ns;
    time_sig <= not time_sig; wait for 8936 ns;
    time_sig <= not time_sig; wait for 1223 ns;
    time_sig <= not time_sig; wait for 8745 ns;
    time_sig <= not time_sig; wait for 1098 ns;
    time_sig <= not time_sig; wait for 8989 ns;
    time_sig <= not time_sig; wait for 2105 ns;
    time_sig <= not time_sig; wait for 7769 ns;
    time_sig <= not time_sig; wait for 1103 ns;
    time_sig <= not time_sig; wait for 8986 ns;
    time_sig <= not time_sig; wait for 1224 ns;
    time_sig <= not time_sig; wait for 8679 ns;
    time_sig <= not time_sig; wait for 1177 ns;
    time_sig <= not time_sig; wait for 8935 ns;
    time_sig <= not time_sig; wait for 2145 ns;
    time_sig <= not time_sig; wait for 7779 ns;
    time_sig <= not time_sig; wait for 2088 ns;
    time_sig <= not time_sig; wait for 7985 ns;
    time_sig <= not time_sig; wait for 2201 ns;
    time_sig <= not time_sig; wait for 7725 ns;
    time_sig <= not time_sig; wait for 3087 ns;
    time_sig <= not time_sig; wait for 6985 ns;
    time_sig <= not time_sig; wait for 2063 ns;
    time_sig <= not time_sig; wait for 7834 ns;
    time_sig <= not time_sig; wait for 3109 ns;
    time_sig <= not time_sig; wait for 7023 ns;
    time_sig <= not time_sig; wait for 1055 ns;
    time_sig <= not time_sig; wait for 8815 ns;
    time_sig <= not time_sig; wait for 5074 ns;
    time_sig <= not time_sig; wait for 5077 ns;
    time_sig <= not time_sig; wait for 1010 ns;
    time_sig <= not time_sig; wait for 8872 ns;
    time_sig <= not time_sig; wait for 1147 ns;
    time_sig <= not time_sig; wait for 8973 ns;
    time_sig <= not time_sig; wait for 991 ns;
    time_sig <= not time_sig; wait for 8891 ns;
    time_sig <= not time_sig; wait for 1123 ns;
    time_sig <= not time_sig; wait for 8970 ns;
    time_sig <= not time_sig; wait for 1016 ns;
    time_sig <= not time_sig; wait for 8862 ns;
    time_sig <= not time_sig; wait for 1201 ns;
    time_sig <= not time_sig; wait for 8935 ns;
    time_sig <= not time_sig; wait for 997 ns;
    time_sig <= not time_sig; wait for 8899 ns;
    time_sig <= not time_sig; wait for 1193 ns;
    time_sig <= not time_sig; wait for 8942 ns;
    time_sig <= not time_sig; wait for 949 ns;
    time_sig <= not time_sig; wait for 1009 ns;
    time_sig <= not time_sig; wait for 996 ns;
    time_sig <= '1'; wait;

  end process;
end;

