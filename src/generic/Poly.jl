parent_type(::Type{Poly{T}}) where T <: RingElement = PolyRing{T}

elem_type(::Type{PolyRing{T}}) where T <: RingElement = Poly{T}

dense_poly_type(::Type{T}) where T <: RingElement = Poly{T}

function setcoeff!(c::Poly{T}, n::Int, a::T) where T <: RingElement
   if !iszero(a) || n + 1 <= length(c)
      fit!(c, n + 1)
      c.coeffs[n + 1] = a
      c.length = max(length(c), n + 1)
      # don't normalise
   end
   return c
end

function normalise(a::Poly, n::Int)
   while n > 0 && iszero(a.coeffs[n])
      n -= 1
   end
   return n
end

coeff(a::Poly, n::Int) = n >= length(a) ? base_ring(a)(0) : a.coeffs[n + 1]

function deepcopy_internal(a::Poly{T}, dict::IdDict) where T <: RingElement
   coeffs = Array{T}(undef, length(a))
   for i = 1:length(a)
      coeffs[i] = deepcopy(a.coeffs[i])
   end
   return parent(a)(coeffs)
end

function set_length!(c::Poly{T}, n::Int) where T <: RingElement
   if n < c.length
      for i = n + 1:c.length
         c.coeffs[i] = zero!(c.coeffs[i])
      end
   end
   c.length = n
   return c
end

function fit!(c::Poly{T}, n::Int) where T <: RingElement
   if length(c.coeffs) < n
      resize!(c.coeffs, n)
      for i = length(c) + 1:n
         c.coeffs[i] = zero(base_ring(c))
      end
   end
   return nothing
end

function zero!(c::Poly{T}) where T <: RingElement
   c = set_length!(c, 0)
   return c
end

promote_rule(::Type{Poly{T}}, ::Type{Poly{T}}) where T <: RingElement = Poly{T}

function promote_rule(::Type{Poly{T}}, ::Type{U}) where {T <: RingElement, U <: RingElement}
   promote_rule(T, U) == T ? Poly{T} : Union{}
end

function (a::PolyRing{T})(b::RingElement) where T <: RingElement
   return a(base_ring(a)(b))
end

function (a::PolyRing{T})() where T <: RingElement
   z = Poly{T}()
   z.parent = a
   return z
end

function (a::PolyRing{T})(b::Union{Integer, Rational, AbstractFloat}) where T <: RingElement
   z = Poly{T}(base_ring(a)(b))
   z.parent = a
   return z
end

function (a::PolyRing{T})(b::Vector{S}) where {S <: RingElement, T <: RingElement}
   R = base_ring(a)
   len = length(b)
   entries = Array{T}(undef, len)
   for i = 1:length(b)
      entries[i] = R(b[i])
   end
   z = Poly{T}(entries)
   z.parent = a
   return z
end

function PolynomialRing(R::AbstractAlgebra.Ring, s::Symbol; cached::Bool = true)
   T = elem_type(R)
   parent_obj = PolyRing{T}(R, s, cached)

   return parent_obj, parent_obj([R(0), R(1)])
end
