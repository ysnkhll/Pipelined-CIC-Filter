# Pipelined-CIC-Filter
A pipelined VHDL implementation of Eugene B. Hogenauer's Cascaded integrator–comb (CIC) decimation Filter.

## Implementation:
This implementation allows one to instantiate a CIC module according to thier design parameters.

---
Mainly,

* B<sub>in</sub> = input sample precision
* R = decimation or interpolation ratio
* M = number of samples per stage (usually 1 but sometimes 2)
* N = number of stages in filter

*B<sub>max</sub>*, the filters bit growth is calculated as,

![equations](https://wikimedia.org/api/rest_v1/media/math/render/svg/fb0381ebbfc3f455d48abe46e76761a054e3d624)

*G*, the filters overall gain, is calculated as,


## Refrences:
* Hogenauer, Eugene B. (April 1981). "An economical class of digital filters for decimation and interpolation". IEEE Transactions on Acoustics, Speech, and Signal Processing. 29 (2): 155–162. [doi:10.1109/TASSP.1981.1163535](https://doi.org/10.1109/TASSP.1981.1163535).
* https://en.wikipedia.org/wiki/Cascaded_integrator-comb_filter

###### [Yasin Khalil](http://www.yasinkhalil.com) :sunglasses: Keybase: [2FC7 638E 1926 F27](https://keybase.io/ysnkhll)
