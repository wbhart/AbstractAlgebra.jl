module AbstractAlgebra

function divrem(a::T, b::T) where T
  return Base.divrem(a, b)
end

function div(a::T, b::T) where T
  return Base.div(a, b)
end

function inv(a::T) where T
  return Base.inv(a)
end

function numerator(a::T, canonicalise::Bool=true) where T
  return Base.numerator(a, canonicalise)
end

function denominator(a::T, canonicalise::Bool=true) where T
  return Base.denominator(a, canonicalise)
end

import Base: Array, abs, acos, acosh, adjoint, asin, asinh, atan, atanh, axes,
             bin, ceil, checkbounds, conj, convert, cmp, cos, cosh, cospi, cot,
             coth, dec, deepcopy, deepcopy_internal, expm1, exponent, fill,
             floor, gcd, gcdx, getindex, hash, hcat, hex, hypot, intersect,
             invmod, isequal, isfinite, isless, isone, isqrt, isreal,
             iszero, lcm, ldexp, length, log1p, mod, ndigits, oct, one,
             parent, parse, powermod,
             precision, rand, Rational, rem, reverse, setindex!,
             show, sincos, similar, sign, sin, sinh, sinpi, size, string, tan,
             tanh, trailing_zeros, transpose, truncate, typed_hvcat,
             typed_hcat, typed_vcat, vcat, xor, zero, zeros,
             +, -, *, ==, ^, &, |, <<, >>, ~, <=, >=, <, >, //, /, !=

export elem_type, parent_type

export SetElem, GroupElem, AdditiveGroupElem, RingElem, ModuleElem, FieldElem, RingElement,
       FieldElement, Map, AccessorNotSetError

export SetMap, FunctionalMap, IdentityMap

export PolyElem, SeriesElem, AbsSeriesElem, RelSeriesElem, ResElem, FracElem,
       MatElem, MatAlgElem, FinFieldElem, MPolyElem, NumFieldElem, SimpleNumFieldElem

export PolyRing, SeriesRing, ResRing, FracField, MatSpace, MatAlgebra,
       FinField, MPolyRing, NumField, SimpleNumField

export ZZ, QQ, zz, qq, RealField, RDF

function coeff end

function set_length! end

const CacheDictType = Dict

function get_cached!(default::Base.Callable, dict::AbstractDict,
                                             key,
                                             use_cache::Bool)
   return use_cache ? Base.get!(default, dict, key) : default()
end

include("AbstractTypes.jl")

const PolynomialElem{T} = PolyElem{T}

include("julia/JuliaTypes.jl")

include("fundamental_interface.jl")

include("Poly.jl")
include("RationalFunctionField.jl")
include("Fraction.jl")

include("Generic.jl")

import .Generic: abs_series, abs_series_type,
                 base_field, basis,
                 character,
                 check_composable, collength,
                 combine_like_terms!, cycles,
                 defining_polynomial, degrees,
                 dense_matrix_type, dense_poly_type,
                 dim, disable_cache!,
                 downscale,
                 enable_cache!, exp_gcd,
                 exponent, exponent_vector,
                 finish, fit!, gcd, gcdx,
                 has_left_neighbor, has_bottom_neighbor, hash,
                 hooklength, identity_map,
                 image_map, image_fn,
                 inverse_fn, inverse_image_fn,
                 inverse_mat, reverse_rows, reverse_rows!,
                 inv!, invmod,
                 iscompatible, isdegree,
                 ishomogeneous, isisomorphic,
                 isone, isreverse, isrimhook, issubmodule,
                 isunit,
                 laurent_ring, lcm, leading_coefficient, leading_monomial,
                 leading_term, length,
                 leglength, main_variable,
                 main_variable_extract, main_variable_insert,
                 map1, map2, map_from_func,
                 map_with_preimage_from_func, map_with_retraction,
                 map_with_retraction_from_func,
                 map_with_section, map_with_section_from_func, mat,
                 matrix_repr, max_fields, mod,
                 monomial, monomial!, monomials,
                 monomial_iszero, monomial_set!,
                 MPolyBuildCtx, mullow_karatsuba,
                 ngens, norm, normalise,
                 num_coeff, one,
                 order, ordering, parity, partitionseq, Perm, perm,
                 permtype, @perm_str, polcoeff, poly, poly_ring,
                 precision, preimage, preimage_map,
                 prime, push_term!,
                 rand_ordering, reduce!,
                 rels, rel_series, rel_series_type,
                 rescale!, retraction_map, reverse,
                 right_kernel, rowlength, section_map, setcoeff!,
                 set_exponent_vector!, set_limit!,
                 setpermstyle, size,
                 sort_terms!, summands,
                 supermodule, term, terms, total_degree,
                 to_univariate, trailing_coefficient,
                 truncate, upscale, var_index,
                 zero

export abs_series, abs_series_type,
                 addmul_delayed_reduction!, addmul!,
                 base_field, base_ring, basis,
                 canonical_unit, can_solve_left_reduced_triu,
                 change_base_ring, change_coefficient_ring, character,
                 chebyshev_t,
                 chebyshev_u, check_composable, check_parent,
                 collength, combine_like_terms!, cycles,
                 defining_polynomial, degrees,
                 dense_matrix_type, dense_poly_type, det,
                 discriminant,
                 elem_type,
                 exponent, exponent_vector,
                 finish, fit!, gcd, gen,
                 gens, gcdinv, gcdx,
                 has_left_neighbor, has_bottom_neighbor, hash,
                 interpolate,
                 inv!, inverse_image_fn,
                 inverse_mat, invmod,
                 iscompatible, isdegree,
                 isdomain_type, isexact_type, isgen,
                 ishomogeneous,
                 isisomorphic, ismonomial, ismonomial_recursive,
                 isnegative, isone, isreverse,
                 issubmodule, issymmetric,
                 isterm_recursive, isunit, iszero,
                 lcm, leading_coefficient, leading_monomial, leading_term,
                 length,
                 main_variable, main_variable_extract, main_variable_insert,
                 mat, matrix_repr, max_fields, mod,
                 monomial, monomial!, monomials,
                 monomial_iszero, monomial_set!, monomial_to_newton!,
                 MPolyBuildCtx,
                 mul_ks, mul_red!, mullow_karatsuba, mulmod,
                 needs_parentheses, newton_to_monomial!, ngens,
                 normalise, nullspace, num_coeff,
                 one, order, ordering,
                 parent_type, parity, partitionseq, Perm, perm, permtype,
                 @perm_str, polcoeff, polynomial, poly,
                 poly_ring, pow_multinomial,
                 ppio, precision, preimage, prime,
                 push_term!, rank,
                 rand_ordering, reduce!,
                 renormalize!, rel_series, rel_series_type, rels,
                 resultant, resultant_ducos,
                 resultant_euclidean, resultant_subresultant,
                 resultant_sylvester, resx, reverse, rowlength,
                 setcoeff!, set_exponent_vector!,
                 setpermstyle,
                 size, sort_terms!, subst, summands, supermodule,
                 sylvester_matrix, term, terms, to_univariate,
                 total_degree, trailing_coefficient, truncate,
                 var_index, zero,
                 MatrixElem, PolynomialElem

export Generic

include("Rings.jl")

const ZZ = JuliaZZ
const QQ = JuliaQQ

end # module
