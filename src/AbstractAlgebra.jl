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

import Base: //, ==, -, length, *, gcd, iszero, zero, parent, +, one

export elem_type, parent_type

export RingElem, FieldElem, RingElement,
       FieldElement

export PolyElem, FracElem

export PolyRing, FracField

export ZZ, QQ

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

function zero! end

include("Generic.jl")

import .Generic: fit!, setcoeff!, normalise

export Generic

include("Rings.jl")

const ZZ = JuliaZZ
const QQ = JuliaQQ

end # module
