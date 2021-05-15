library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        cnt_o : out std_logic_vector(3 downto 0)
    );
end entity counter;

architecture RTL of counter is
    constant MODULE : positive := 12;
    signal cnt      : unsigned(3 downto 0);
begin
    do_counter : process (clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                cnt <= (others => '0');
            else
                if cnt < MODULE-1 then
                    cnt <= cnt + 1;
                else
                    cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process do_counter;

    cnt_o <= std_logic_vector(cnt);
end architecture RTL;
