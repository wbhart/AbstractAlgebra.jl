module AbstractAlgebra

using Random: SamplerTrivial, GLOBAL_RNG
using RandomExtensions: RandomExtensions, make, Make, Make2, Make3, Make4

using Markdown

using InteractiveUtils

function exp(a::T) where T
   return Base.exp(a)
end

function log(a::T) where T
   return Base.log(a)
end

function sqrt(a::T; check::Bool=true) where T
  return Base.sqrt(a; check=check)
end

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

# If you want to add methods to functions in Base they should be imported here
# and in Generic.jl.
# They should not be imported/exported anywhere else.

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

using Random: Random, AbstractRNG, SamplerTrivial
using RandomExtensions: RandomExtensions, make, Make2

export elem_type, parent_type

export SetElem, GroupElem, AdditiveGroupElem, NCRingElem, RingElem, ModuleElem, FieldElem, RingElement,
       FieldElement, Map, AccessorNotSetError

export SetMap, FunctionalMap, IdentityMap

export NCPolyElem, PolyElem, SeriesElem, AbsSeriesElem, RelSeriesElem, ResElem, FracElem,
       MatElem, MatAlgElem, FinFieldElem, MPolyElem, NumFieldElem, SimpleNumFieldElem

export PolyRing, SeriesRing, ResRing, FracField, MatSpace, MatAlgebra,
       FinField, MPolyRing, NumField, SimpleNumField

export ZZ, QQ, zz, qq, RealField, RDF

export create_accessors, get_handle, package_handle, zeros,
       Array, sig_exists

export error_dim_negative, ErrorConstrDimMismatch

export crt, factor, factor_squarefree

function expressify
end

function show_via_expressify
end

macro declare_other()
   esc(quote other::Dict{Symbol, Any} end )
end

function set_name!(G, name::String)
   set_special(G, :name => name)
end

function hasspecial(G)
   if !isdefined(G, :other)
      return false, nothing
   else
     return true, G.other
   end
end

function get_special(G, s::Symbol)
   fl, D = hasspecial(G)
   fl && return get(D, s, nothing)
   nothing
end

function set_name!(G)
   s = get_special(G, :name)
   s === nothing || return
   sy = find_name(G)
   sy === nothing && return
   set_name!(G, string(sy))
end

function set_special(G, data::Pair{Symbol, <:Any}...)
  if !isdefined(G, :other)
    D = G.other = Dict{Symbol, Any}()
  else
    D = G.other
  end

  for d in data
    push!(D, d)
  end
end

extra_name(G) = nothing

macro show_name(io, O)
  return :( begin
    local i = $(esc(io))
    local o = $(esc(O))
    s = get_special(o, :name)
    if s === nothing
      sy = find_name(o)
      if sy === nothing
        sy = extra_name(o)
      end
      if sy !== nothing
        s = string(sy)
        set_name!(o, s)
      end
    end
    if get(i, :compact, false) &&
       s !== nothing
      print(i, s)
      return
    end
  end )
end

function find_name(A, M = Main)
  for a = names(M)
    a === :ans && continue
    if isdefined(M, a) && getfield(M, a) === A
        return a
    end
  end
end

macro show_special(io, O)
  return :( begin
    local i = $(esc(io))
    local o = $(esc(O))
    s = get_special(o, :show)
    if s !== nothing
      s(i, o)
      return
    end
  end )
end

macro show_special_elem(io, e)
  return :( begin
    local i = $(esc(io))
    local a = $(esc(e))
    local o = parent(a)
    s = get_special(o, :show_elem)
    if s !== nothing
      s(i, a)
      return
    end
  end )
end

function force_coerce(a, b, throw_error::Type{Val{T}} = Val{true}) where {T}
  if throw_error === Val{true}
    throw(error("coercion not possible"))
  else
    return nothing
  end
end

function force_op(op::Function, throw_error::Type{Val{T}}, a...) where {T}
  if throw_error === Val{true}
    throw(error("no common overstructure for the arguments found"))
  end
  return false
end

function force_op(op::Function, a...)
  return force_op(op, Val{true}, a...)
end

function coeff end

function set_length! end

const CacheDictType = Dict

function get_cached!(default::Base.Callable, dict::AbstractDict,
                                             key,
                                             use_cache::Bool)
   return use_cache ? Base.get!(default, dict, key) : default()
end

include("AbstractTypes.jl")

const PolynomialElem{T} = Union{PolyElem{T}, NCPolyElem{T}}

include("julia/JuliaTypes.jl")

include("fundamental_interface.jl")

include("algorithms/GenericFunctions.jl")

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
                 zero,
       # Moved from Hecke into Misc
                 Loc, Localization, LocElem,
                 roots, sturm_sequence

# Do not export inv, div, divrem, exp, log, sqrt, numerator and denominator as we define our own
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
                 MatrixElem, PolynomialElem,
       # Moved from Hecke into Misc
                 divexact_low, divhigh,
                 ismonic, Loc, Localization, LocElem, mulhigh_n,
                 PolyCoeffs, roots, sturm_sequence

export Generic

include("error.jl")

include("Rings.jl")

include("PrettyPrinting.jl")

include("Deprecations.jl")

function sig_exists(T::Type{Tuple{U, V, W}}, sig_table::Vector{X}) where {U, V, W, X}
   for s in sig_table
      if s === T
         return true
      end
   end
   return false
end

Array(R::Ring, r::Int...) = Array{elem_type(R)}(undef, r)

function zeros(R::Ring, r::Int...)
   T = elem_type(R)
   A = Array{T}(undef, r)
   for i in eachindex(A)
      A[i] = R()
   end
   return A
end

const ZZ = JuliaZZ
const QQ = JuliaQQ

include("algorithms/DensePoly.jl")

needs_parentheses(x) = false

function isnegative end

end # module
