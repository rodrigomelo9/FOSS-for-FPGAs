library IEEE;
use IEEE.std_logic_1164.all;

entity top is
    port (
        clk_i  :  in std_logic;
        led1_o : out std_logic;
        led2_o : out std_logic;
        led3_o : out std_logic;
        led4_o : out std_logic
    );
end entity top;

architecture RTL of top is
    signal cnt : std_logic_vector(11 downto 0);
begin

    counter_i : entity work.counter
    generic map(WIDTH => 12)
    port map(clk_i => clk_i, rst_i => '0', cnt_o => cnt);

    led1_o <= cnt(8);
    led2_o <= cnt(9);
    led3_o <= cnt(10);
    led4_o <= cnt(11);

end architecture RTL;
