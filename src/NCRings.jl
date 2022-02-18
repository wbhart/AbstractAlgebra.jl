###############################################################################
#
#   NCRings.jl : Generic not necessarily commutative rings
#
###############################################################################

include("Rings.jl")

###############################################################################
#
#   Promotion system
#
###############################################################################

promote_rule(::Type{T}, ::Type{T}) where T <: NCRingElem = T

###############################################################################
#
#   Generic catchall functions
#
###############################################################################

+(x::NCRingElem, y::NCRingElem) = +(promote(x, y)...)

+(x::NCRingElem, y::NCRingElement) = x + parent(x)(y)

+(x::NCRingElement, y::NCRingElem) = parent(y)(x) + y

-(x::NCRingElem, y::NCRingElem) = -(promote(x, y)...)

-(x::NCRingElem, y::NCRingElement) = x - parent(x)(y)

-(x::NCRingElement, y::NCRingElem) = parent(y)(x) - y

*(x::NCRingElem, y::NCRingElem) = *(promote(x, y)...)

*(x::NCRingElem, y::NCRingElement) = x*parent(x)(y)

*(x::NCRingElement, y::NCRingElem) = parent(y)(x)*y

function divexact_left(x::NCRingElem, y::NCRingElem; check::Bool = true)
   return divexact_left(promote(x, y)...)
end

function divexact_right(x::NCRingElem, y::NCRingElem; check::Bool = true)
   return divexact_right(promote(x, y)...)
end

function divexact_left(
   x::NCRingElem,
   y::Union{Integer, Rational, AbstractFloat};
   check::Bool = true)

   return divexact_left(x, parent(x)(y); check = check)
end

function divexact_right(
   x::NCRingElem,
   y::Union{Integer, Rational, AbstractFloat};
   check::Bool = true)

   return divexact_right(x, parent(x)(y); check = check)
end

function ==(x::S, y::T) where {S <: NCRingElem, T <: NCRingElem}
   if S == promote_rule(S, T)
      ==(x, parent(x)(y))
   else
      ==(parent(y)(x), y)
   end
end

Base.literal_pow(::typeof(^), x::NCRingElem, ::Val{p}) where {p} = x^p

function check_parent(a::NCRingElement, b::NCRingElement, throw::Bool=true)
   c = parent(a) !== parent(b)
   c && throw && error("Incompatible polynomial rings in polynomial operation")
   return !c
end

function zero!(z::NCRingElem)
   return zero(parent(z))
end

function add!(z::T, x::T, y::T) where T <: NCRingElem
   return x + y
end

function addeq!(z::T, y::T) where T <: NCRingElem
   return z + y
end

function mul!(z::T, x::T, y::T) where T <: NCRingElem
   return x*y
end

function addmul!(z::T, x::T, y::T, c::T) where T <: NCRingElem
   c = mul!(c, x, y)
   z = addeq!(z, c)
   return z
end

###############################################################################
#
#   Basic manipulation
#
###############################################################################

@doc Markdown.doc"""
    isunit(a::T) where {T <: NCRingElem}

Return true if $a$ is invertible, else return false.

# Examples
```jldoctest; setup = :(using AbstractAlgebra)
julia> S, x = PolynomialRing(QQ, "x")
(Univariate Polynomial Ring in x over Rationals, x)

julia> isunit(x), isunit(S(1)), isunit(S(4))
(false, true, true)

julia> isunit(ZZ(-1)), isunit(ZZ(4))
(true, false)
```
"""
function isunit end

###############################################################################
#
#   Characteristic
#
###############################################################################

# -1 means the characteristic is not known by default
characteristic(R::NCRing) = -1

###############################################################################
#
#   One and zero
#
###############################################################################

one(x::NCRingElem) = one(parent(x))

zero(x::NCRingElem) = zero(parent(x))

###############################################################################
#
#   Delayed reduction
#
###############################################################################

# Fall back to ordinary multiplication
function mul_red!(a::T, b::T, c::T, flag::Bool) where T <: NCRingElement
   return mul!(a, b, c)
end

# Define addmul_delayed_reduction! for all ring elem types
function addmul_delayed_reduction!(a::T, b::T, c::T, d::T) where T <: NCRingElement
   d = mul_red!(d, b, c, false)
   return addeq!(a, d)
end

# Fall back to nop
function reduce!(a::NCRingElement)
   return a
end

###############################################################################
#
#   Baby-steps giant-steps powering
#
###############################################################################

@doc Markdown.doc"""
    powers(a::Union{NCRingElement, MatElem}, d::Int)

Return an array $M$ of "powers" of `a` where $M[i + 1] = a^i$ for $i = 0..d$
"""
function powers(a::T, d::Int) where {T <: Union{NCRingElement, MatElem}}
   d < 0 && throw(DomainError(d, "the second argument must be nonnegative"))
   a isa MatElem && !issquare(a) && throw(DomainError(a, "matrix must be square"))
   M = Array{T}(undef, d + 1)
   M[1] = one(a)
   if d > 0
      M[2] = a
      for i = 2:d
         M[i + 1] = M[i] * a
      end
   end
   return M
end

###############################################################################
#
#   oftype
#
################################################################################

# This is a useful fallback when applying methods from Base to our matrices,
# see https://github.com/Nemocas/Nemo.jl/pull/637
Base.oftype(x::NCRingElem, y::NCRingElem) = parent(x)(y)

Base.oftype(x::NCRingElem, y::AbstractFloat) = parent(x)(y)

Base.oftype(x::NCRingElem, y::Integer) = parent(x)(y)

Base.oftype(x::NCRingElem, y::Rational) = parent(x)(y)
