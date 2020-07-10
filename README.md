# Pipelined-CIC-Filter
A pipelined VHDL implementation of Eugene B. Hogenauer's Cascaded integrator–comb (CIC) decimation Filter.

## Implementation:
This implementation allows one to instantiate a CIC module according to thier design parameters.
Mainly,

* B<sub>in</sub> = input sample precision
* R = decimation or interpolation ratio
* M = number of samples per stage (usually 1 but sometimes 2)
* N = number of stages in filter

*B<sub>max</sub>* is the filters bit growth and it is calculated as,

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://render.githubusercontent.com/render/math?math=N\log_{2}(RM)">

*G* is the filters overall gain and is calculated as,

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://render.githubusercontent.com/render/math?math=(RM)^{N}">

## References:
* Hogenauer, Eugene B. (April 1981). "An economical class of digital filters for decimation and interpolation". IEEE Transactions on Acoustics, Speech, and Signal Processing. 29 (2): 155–162. [doi:10.1109/TASSP.1981.1163535](https://doi.org/10.1109/TASSP.1981.1163535).
* https://en.wikipedia.org/wiki/Cascaded_integrator-comb_filter

###### [Yasin Khalil](http://www.yasinkhalil.com) :sunglasses: Keybase: [2FC7 638E 1926 F27](https://keybase.io/ysnkhll)
