library IEEE;
use IEEE.std_logic_1164.all;

package COUNTER_PKG is

    component counter is
        generic (
            WIDTH  : positive := 4
        );
        port (
            clk_i : in  std_logic;
            rst_i : in  std_logic;
            cnt_o : out std_logic_vector(3 downto 0)
        );
    end component counter;

end package COUNTER_PKG;
