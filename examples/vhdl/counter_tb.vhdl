library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library std;
use std.textio.all;
library COUNTER_LIB;
use COUNTER_LIB.COUNTER_PKG.all;

entity counter_tb is
end entity counter_tb;

architecture Simul of counter_tb is
    constant PERIOD : time := 20 ns; -- 50 MHz
    signal clk      : std_logic:='1';
    signal rst      : std_logic;
    signal cnt      : std_logic_vector(3 downto 0);
    signal stop     : boolean := FALSE;
begin

    do_clock: process
    begin
        while not stop loop
           wait for PERIOD/2;
           clk <= not clk;
        end loop;
        wait; -- Event Starvation
    end process do_clock;

    rst <= '1', '0' after 3*PERIOD;

    uut : counter
    port map(clk_i => clk, rst_i => rst, cnt_o => cnt);

    testing:  process
        variable L : LINE;
    begin
        -- Print to STDOUT
        write(L,NOW);
        write(L,STRING'(" --> Start of test"));
        writeline(output,L);
        -- Test of the initial value
        wait until rising_edge(clk);
        wait until rst='0';
        assert unsigned(cnt)=0
            report "Error! not 0"
                severity failure;
        -- Test of the intermediate values
        for I in 0 to 11 loop
            wait until rising_edge(clk);
            assert unsigned(cnt)=I
                report "Error! cnt = ("&integer'image(to_integer(unsigned(cnt)))&")"
                    severity failure;
        end loop;
        wait until rising_edge(clk);
        -- Test cicle restart
        assert unsigned(cnt)=0
            report "Error! Mod-12 ("&integer'image(to_integer(unsigned(cnt)))&")"
                severity failure;
        -- Print to STDOUT
        write(L,NOW);
        write(l,string'("-> End of test"));
        writeline(output,L);
        -- Clock stop
        stop <= true;
        wait;
    end process testing;

end architecture Simul;
