library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        WIDTH  : positive := 4
    );
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        cnt_o : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity counter;

architecture RTL of counter is
    signal cnt : unsigned(WIDTH-1 downto 0);
begin
    do_counter : process (clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process do_counter;

    cnt_o <= std_logic_vector(cnt);
end architecture RTL;
