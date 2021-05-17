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
    constant WIDTH : positive := 26; -- 24;
    signal   cnt   : std_logic_vector(WIDTH-1 downto 0);
begin

    counter_i : entity work.counter
    generic map(WIDTH => WIDTH)
    port map(clk_i => clk_i, rst_i => '0', cnt_o => cnt);

    led1_o <= cnt(WIDTH-4);
    led2_o <= cnt(WIDTH-3);
    led3_o <= cnt(WIDTH-2);
    led4_o <= cnt(WIDTH-1);

end architecture RTL;
