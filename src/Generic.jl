module Generic

import LinearAlgebra: det, issymmetric, norm,
                      nullspace, rank, transpose!, hessenberg

import LinearAlgebra: istriu, lu, lu!, tr

using Markdown, Random, InteractiveUtils

using Random: SamplerTrivial, GLOBAL_RNG
using RandomExtensions: RandomExtensions, make, Make, Make2, Make3, Make4

import Base: Array, abs, asin, asinh, atan, atanh, axes, bin, checkbounds, cmp, conj,
             convert, copy, cos, cosh, dec, deepcopy, deepcopy_internal,
             exponent, gcd, gcdx, getindex, hash, hcat, hex, intersect,
             invmod, isapprox, isempty, isequal, isfinite, isless, isone, isqrt,
             isreal, iszero, lcm, ldexp, length, Matrix, mod, ndigits, oct, one,
             parent, parse, powermod,
             precision, rand, Rational, rem, reverse, setindex!,
             show, similar, sign, sin, sinh, size, string, tan, tanh,
             trailing_zeros, transpose, truncate, typed_hvcat, typed_hcat,
             vcat, xor, zero, zeros, +, -, *, ==, ^, &, |, <<, >>, ~, <=, >=,
             <, >, //, /, !=

import Base: floor, ceil, hypot, log1p, expm1, sin, cos, sinpi, cospi,
             tan, cot, sinh, cosh, tanh, coth, atan, asin, acos, atanh, asinh,
             acosh, sinpi, cospi

# The type and helper function for the dictionaries for hashing
import ..AbstractAlgebra: CacheDictType, get_cached!

import ..AbstractAlgebra: CycleDec, Field, FieldElement, Integers, Map,
                          NCRing, NCRingElem, Perm, Rationals, Ring, RingElem,
                          RingElement, GFElem

import ..AbstractAlgebra: add!, addeq!, addmul!, base_ring, canonical_unit,
                          can_solve_with_solution_lu,
                          can_solve_with_solution_fflu, change_base_ring,
                          characteristic, check_parent, codomain, coeff,
                          coefficients, compose, constant_coefficient,
                          content, data, deflate, deflation, degree,
                          degrees_range, denominator, derivative, div,
                          divexact, divides, divrem, domain, elem_type,
                          evaluate, exp, exponent_vectors, expressify, factor,
                          gen, gens, get_field, identity_matrix, inflate,
                          integral, inv, isconstant, isdomain_type,
                          isexact_type, isgen, ismonomial, isreduced_form,
                          issquare, isunit, leading_coefficient, log,
                          map_coefficients, max_precision, minpoly, modulus,
                          mul!, mul_classical, mul_karatsuba, mullow,
                          numerator, ncols, nrows, nvars, O, parent_type,
                          pol_length, primpart, promote_rule, pseudodivrem,
                          pseudorem, reduced_form, renormalize!,
                          set_coefficient!, set_field!,
                          set_length!, set_precision!, set_valuation!,
                          shift_left, shift_right, snf, sqrt, symbols,
                          term_degree, terms_degrees, trailing_coefficient,
                          use_karamul, valuation, var, vars, zero!

using ..AbstractAlgebra

include("generic/GenericTypes.jl")

include("generic/Poly.jl")

include("generic/Fraction.jl")

include("generic/RationalFunctionField.jl")

end # generic
