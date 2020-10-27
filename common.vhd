--
-- File            : data_types.vhd
-- Author          : Yasin Khalil
-- Date            : 3/25/2019
-- Version         : 1.0
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package common is
	constant taps_hb_filter : integer := 32;
	constant data_width : integer := 24;
	constant coeff_width : integer := 24;

	type data_array is array (0 to taps_hb_filter - 1) of signed(data_width - 1 downto 0);
	type coeff_array is array (0 to taps_hb_filter - 1) of std_logic_vector(coeff_width - 1 downto 0);
	type product_array is array (0 to taps_hb_filter - 1) of signed((data_width + coeff_width) - 1 downto 0);

	constant fir_hb_coeffs : coeff_array := (
	x"FFFF92",
	x"FFFCD8",
	x"001566",
	x"FFBA1B",
	x"00A533",
	x"FEC435",
	x"01FD82",
	x"FD43BC",
	x"031E18",
	x"FD668E",
	x"007728",
	x"042E77",
	x"F377A2",
	x"1A9056",
	x"CD3CC1",
	x"611A72",
	x"611A72",
	x"CD3CC1",
	x"1A9056",
	x"F377A2",
	x"042E77",
	x"007728",
	x"FD668E",
	x"031E18",
	x"FD43BC",
	x"01FD82",
	x"FEC435",
	x"00A533",
	x"FFBA1B",
	x"001566",
	x"FFFCD8",
	x"FFFF92"
	);

	function Gain_calc(R : natural; N : natural; M : natural) return natural;
	function Bmax_calc(Bin : natural; R : natural; N : natural; M : natural) return natural;
	function calc_R_M(R : natural; M : natural) return real;
	function sqrt(d : unsigned) return unsigned;
end package;

package body common is

	function Gain_calc(R : natural; N : natural; M : natural) return natural is
		constant a : real := real(R * M);
		constant x : real := real(a ** real(N));
	begin
		return natural(log2(x));
	end function;

	function Bmax_calc(Bin : natural; R : natural; N : natural; M : natural) return natural is
		constant a : real := calc_R_M(R, M);
		constant b : real := log2(a);
		constant c : real := real(real(N) * b);
	begin
		return natural(c) + Bin;
	end function;

	function calc_R_M(R : natural; M : natural) return real is
	begin
		return real(R * M);
	end function;

	function sqrt(d : unsigned) return unsigned is
		variable a : unsigned(31 downto 0) := d; --original input.
		variable q : unsigned(15 downto 0) := (others => '0'); --result.
		variable left, right, r : unsigned(17 downto 0) := (others => '0'); --input to adder/sub.r-remainder.
		variable i : integer := 0;
	begin
		for i in 0 to 15 loop
			right(0) := '1';
			right(1) := r(17);
			right(17 downto 2) := q;
			left(1 downto 0) := a(31 downto 30);
			left(17 downto 2) := r(15 downto 0);
			a(31 downto 2) := a(29 downto 0); --shifting by 2 bit.

			if (r(17) = '1') then
				r := left + right;
			else
				r := left - right;
			end if;

			q(15 downto 1) := q(14 downto 0);
			q(0) := not r(17);
		end loop;

		return q;
	end sqrt;
end package body;
