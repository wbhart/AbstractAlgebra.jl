module Generic

import Base: Array, abs, asin, asinh, atan, atanh, base, bin, checkbounds,
             conj, convert, cmp, contains, cos, cosh, dec, deepcopy,
             deepcopy_internal, denominator, deserialize, det, div, divrem,
             exp, eye, gcd, gcdx, getindex, hash, hcat, hex, intersect, inv,
             invmod, isapprox, isequal, isfinite, isless, isqrt, isreal, iszero, lcm,
             ldexp, length, log, lufact, lufact!, mod, ndigits, nextpow2, norm,
             nullspace, numerator, oct, one, parent, parse, precision,
             prevpow2, rand, rank, Rational, rem, reverse, serialize,
             setindex!, show, similar, sign, sin, sinh, size, string,
             tan, tanh, trace, trailing_zeros, transpose, transpose!, truncate,
             typed_hvcat, typed_hcat, var, vcat, xor, zero, zeros, +, -, *, ==, ^,
             &, |, <<, >>, ~, <=, >=, <, >, //, /, !=

if VERSION >= v"0.7.0-DEV.1144"
import Base: isone
end

import Base: floor, ceil, hypot, log, log1p, exp, expm1, sin, cos, sinpi,
             cospi, tan, cot, sinh, cosh, tanh, coth, atan, asin, acos, atanh,
             asinh, acosh, gamma, lgamma, sinpi, cospi, atan2

import AbstractAlgebra: Integers, Rationals, Ring, RingElem, RingElement, Field,
             FieldElement, Map, promote_rule

using AbstractAlgebra

include("generic/GenericTypes.jl")

include("generic/PermGroups.jl")

include("generic/YoungTabs.jl")

include("generic/Residue.jl")

include("generic/ResidueField.jl")

include("generic/Poly.jl")

include("generic/MPoly.jl")

include("generic/SparsePoly.jl")

include("generic/RelSeries.jl")

include("generic/AbsSeries.jl")

include("generic/LaurentSeries.jl")

include("generic/PuiseuxSeries.jl")

include("generic/Matrix.jl")

include("generic/Fraction.jl")

include("generic/AsField.jl")

include("generic/Map.jl")

include("generic/MapWithInverse.jl")

include("generic/MapCache.jl")

end # generic
