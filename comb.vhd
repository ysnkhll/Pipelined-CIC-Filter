--
-- File            : comb.vhd
-- Author          : Yasin Khalil
-- Date            : 4/11/2019
-- Version         : 1.0
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity comb is
	generic (
		Bin : natural := 24;
		R : natural := 8;
		N : natural := 3;
		M : natural := 1
	);
	
	port (
		clk : in std_logic;
		data_i : in signed(Bin - 1 downto 0);
		data_o : out signed(Bin - 1 downto 0);
		sample : in std_logic
	);
end comb;

architecture arch of comb is
	constant Bmax : integer := Bmax_calc(Bin, R, N, M);
	subtype regsize is signed(Bmax - 1 downto 0);
	
	signal comb_r, comb_delay_r, comb_out : regsize := (others => '0');
begin

	CMB_1 : process(clk)
	begin
		if (rising_edge(clk)) then
			if (sample = '1') then
				comb_r <= data_i;
				comb_delay_r <= comb_r;
				comb_out <= comb_r - comb_delay_r;
			end if;	
		end if;
	end process CMB_1;
				
	data_o <= comb_out;
end arch;
