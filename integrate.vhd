--
-- File            : integrate.vhd
-- Author          : Yasin Khalil
-- Date            : 4/11/2019
-- Version         : 1.0
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity integrate is
	generic (
		Bin : natural := 24;
		R : natural := 8;
		N : natural := 3;
		M : natural := 1
	);
	
	port (
		clk : in std_logic;
		data_i : in signed(Bin - 1 downto 0);
		data_o : out signed(Bin - 1 downto 0)
	);
end integrate;

architecture arch of integrate is
	constant Bmax : integer := Bmax_calc(Bin, R, N, M);
	subtype regsize is signed(Bmax - 1 downto 0);
	
	signal int_r, int_out : regsize := (others => '0');
begin

	INT_1 : process(clk)
	begin
		if (rising_edge(clk)) then
			int_r <= data_i;
			int_out <= int_r + int_out;
		end if;
	end process INT_1;
				
	data_o <= int_out;
end arch;
