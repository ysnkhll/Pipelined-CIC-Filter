--
-- File            : cic.vhd
-- Author          : Yasin Khalil
-- Date            : 4/11/2019
-- Version         : 1.0
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.common.all;

entity cic is
	generic (
		Bin : natural := 24;
		R : natural := 8;
		N : natural := 3;
		M : natural := 1
	);

	port (
		clk : in std_logic;
		rst_n : in std_logic;
		data_i : in signed(Bin - 1 downto 0);
		clk_o : out std_logic;
		data_o : out signed(Bin - 1 downto 0)
	);
end cic;

architecture rtl of cic is
	-- Output word length (Bmax) = N*log2(R*M) + Bin
	constant Bmax : integer := Bmax_calc(Bin, R, N, M);
	-- Try and make sure the CIC gain is designed to be a power of 2.
	constant Gain : natural := Gain_calc(R, N, M);
	subtype regsize is signed(Bmax - 1 downto 0);
	type CASCADE_ARRAY is array (1 to N) of regsize;
	type STATE_T is (hold, sample);
	
	signal data_i_r1 : signed(Bin - 1 downto 0) := (others => '0');
	signal data_i_r2 : signed(Bin - 1 downto 0) := (others => '0');
	signal sxt1 : regsize := (others => '0');
	
	signal int_in : regsize := (others => '0');
	signal int_data : CASCADE_ARRAY;
	signal int_out : regsize := (others => '0');
	
	-- Decimation counter.
	signal count : integer range 0 to (R - 1) := 0;
	-- Decimator state.
	signal state : STATE_T;
	
	signal comb_in : regsize := (others => '0');
	signal comb_data : CASCADE_ARRAY;
	signal comb_out : regsize := (others => '0');
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			data_i_r1 <= data_i;
			data_i_r2 <= data_i_r1;
		end if;
	end process;
	
	-- -------------------------------------------------------------------------
	--	Sign extension.
	-- -------------------------------------------------------------------------
	SXT_1 : process(data_i_r1)
	begin
		sxt1(Bin - 1 downto 0) <= data_i_r1;
		for k in (Bmax - 1) downto Bin loop
			sxt1(k) <= data_i_r2(data_i_r2'high);
		end loop;
	end process SXT_1;
	
	-- -------------------------------------------------------------------------	
	--	Integrator filters.
	-- -------------------------------------------------------------------------
	INT_CASCADE : for i in 1 to N generate
	begin
		-- Generate the first integrator filter.
		GEN_INT_1 : if i = 1 generate
		begin
			INT_1 : entity integrate generic map(Bin=>Bin, R=>R, N=>N, M=>M) port map (
				clk => clk,
				data_i => sxt1,
				data_o => int_data(i)
			);
		end generate GEN_INT_1;
		-- Generate the i'th integrator filter.
		GEN_INT_I : if ((i > 1) and (i < N)) generate
		begin
			INT_1 : entity integrate generic map(Bin=>Bin, R=>R, N=>N, M=>M) port map (
				clk => clk,
				data_i => int_data(i - 1),
				data_o => int_data(i)
			);
		end generate GEN_INT_I;
		-- Generate the N'th integrator filter.
		GEN_INT_N : if i = 1 generate
		begin
			INT_1 : entity integrate generic map(Bin=>Bin, R=>R, N=>N, M=>M) port map (
				clk => clk,
				data_i => int_data(i - 1),
				data_o => int_out
			);
		end generate GEN_INT_N;
	end generate INT_CASCADE;

	-- -------------------------------------------------------------------------
	--	Decimator Filter.
	-- -------------------------------------------------------------------------
	DEC_1 : process(clk, rst_n)
	begin
		if rst_n = '0' then
			state <= hold;
			count <= 0;
			clk_o <= '0';
		elsif rising_edge(clk) then
			if count = (R - 1) then
				count <= 0;
				state <= sample;
				clk_o <= '1';
			else
				count <= count + 1;
				state <= hold;
				clk_o <= '0';
			end if;
		end if;
	end process DEC_1;
	
	-- -------------------------------------------------------------------------
	--	Comb filters.
	-- -------------------------------------------------------------------------
	COMB_CASCADE : for i in 1 to N generate
	begin
		-- Generate the first comb filter.
		GEN_COMB_1 : if i = 1 generate
		begin
			CMB_1 : entity comb generic map(Bin=>Bin, R=>R, N=>N, M=>M) port map (
				clk => clk,
				data_i => int_out,
				data_o => comb_data(i),
				sample => state
			);
		end generate GEN_COMB_1;
		-- Generate the i'th comb filter.
		GEN_COMB_I : if ((i > 1) and (i < N)) generate
		begin
			CMB_1 : entity comb generic map(Bin=>Bin, R=>R, N=>N, M=>M) port map (
				clk => clk,
				data_i => comb_data(i - 1),
				data_o => comb_data(i),
				sample => state
			);
		end generate GEN_COMB_I;
		-- Generate the N'th comb filter.
		GEN_COMB_N : if i = 1 generate
		begin
			CMB_1 : entity comb generic map(Bin=>Bin, R=>R, N=>N, M=>M) port map (
				clk => clk,
				data_i => comb_data(i - 1),
				data_o => comb_out,
				sample => state
			);
		end generate GEN_COMB_N;
	end generate COMB_CASCADE;
	
	-- -------------------------------------------------------------------------
	--	Remove DC Gain and final bit truncation.
	-- -------------------------------------------------------------------------
	data_o <= shift_right(comb_out, Gain)(Bin - 1 downto 0);
end rtl;
