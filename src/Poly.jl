export divexact

base_ring(R::PolyRing{T}) where T <: RingElement = R.base_ring::parent_type(T)

base_ring(a::PolynomialElem) = base_ring(parent(a))

parent(a::PolynomialElem) = a.parent

function check_parent(a::PolynomialElem, b::PolynomialElem, throw::Bool = true)
   c = parent(a) != parent(b)
   c && throw && error("Incompatible polynomial rings in polynomial operation")
   return !c
end

length(a::PolynomialElem) = a.length

function leading_coefficient(a::PolynomialElem)
   return length(a) == 0 ? zero(base_ring(a)) : coeff(a, length(a) - 1)
end

function trailing_coefficient(a::PolynomialElem)
   if iszero(a)
      return zero(base_ring(a))
   else
      for i = 1:length(a)
         c = coeff(a, i - 1)
         if !iszero(c)
            return c
         end
      end
      return coeff(a, length(a) - 1)
   end
end

zero(R::PolyRing) = R(0)

one(R::PolyRing) = R(1)

gen(R::PolyRing) = R([zero(base_ring(R)), one(base_ring(R))])

gens(R::PolyRing) = [gen(R)]

iszero(a::PolynomialElem) = length(a) == 0

canonical_unit(x::PolynomialElem) = canonical_unit(leading_coefficient(x))

function -(a::PolyElem{T}, b::PolyElem{T}) where T <: RingElement
   check_parent(a, b)
   lena = length(a)
   lenb = length(b)
   lenz = max(lena, lenb)
   z = parent(a)()
   fit!(z, lenz)
   i = 1
   while i <= min(lena, lenb)
      z = setcoeff!(z, i - 1, coeff(a, i - 1) - coeff(b, i - 1))
      i += 1
   end
   while i <= lena
      z = setcoeff!(z, i - 1, deepcopy(coeff(a, i - 1)))
      i += 1
   end
   while i <= lenb
      z = setcoeff!(z, i - 1, -coeff(b, i - 1))
      i += 1
   end
   z = set_length!(z, normalise(z, i - 1))
   return z
end

function mul_classical(a::PolyElem{T}, b::PolyElem{T}) where T <: RingElement
   lena = length(a)
   lenb = length(b)
   if lena == 0 || lenb == 0
      return parent(a)()
   end
   R = base_ring(a)
   t = R()
   lenz = lena + lenb - 1
   d = Array{T}(undef, lenz)
   for i = 1:lena
      d[i] = mul_red!(R(), coeff(a, i - 1), coeff(b, 0), false)
   end
   for i = 2:lenb
      d[lena + i - 1] = mul_red!(R(), coeff(a, lena - 1), coeff(b, i - 1), false)
   end
   for i = 1:lena - 1
      for j = 2:lenb
         t = mul_red!(t, coeff(a, i - 1), coeff(b, j - 1), false)
         d[i + j - 1] = addeq!(d[i + j - 1], t)
      end
   end
   for i = 1:lenz
      d[i] = reduce!(d[i])
   end
   z = parent(a)(d)
   z = set_length!(z, normalise(z, lenz))
   return z
end

function *(a::PolyElem{T}, b::PolyElem{T}) where T <: RingElement
   check_parent(a, b)
      return mul_classical(a, b)
end

function *(a::Union{Integer, Rational, AbstractFloat}, b::PolynomialElem)
   len = length(b)
   z = parent(b)()
   fit!(z, len)
   for i = 1:len
      z = setcoeff!(z, i - 1, a*coeff(b, i - 1))
   end
   z = set_length!(z, normalise(z, len))
   return z
end

function ==(x::PolyElem{T}, y::PolyElem{T}) where T <: RingElement
   b = check_parent(x, y, false)
   !b && return false
   if length(x) != length(y)
      return false
   else
      for i = 1:length(x)
         if coeff(x, i - 1) != coeff(y, i - 1)
            return false
         end
      end
   end
   return true
end

function shift_left(f::PolynomialElem, n::Int)
   n < 0 && throw(DomainError(n, "n must be >= 0"))
   if n == 0
      return f
   end
   flen = length(f)
   r = parent(f)()
   fit!(r, flen + n)
   for i = 1:n
      r = setcoeff!(r, i - 1, zero(base_ring(f)))
   end
   for i = 1:flen
      r = setcoeff!(r, i + n - 1, coeff(f, i - 1))
   end
   return r
end

function divexact(f::PolyElem{T}, g::PolyElem{T}; check::Bool=true) where T <: RingElement
   check_parent(f, g)
   iszero(g) && throw(DivideError())
   if iszero(f)
      return zero(parent(f))
   end
   lenq = length(f) - length(g) + 1
   d = Array{T}(undef, lenq)
   for i = 1:lenq
      d[i] = zero(base_ring(f))
   end
   x = gen(parent(f))
   leng = length(g)
   while length(f) >= leng
      lenf = length(f)
      q1 = d[lenf - leng + 1] = divexact(coeff(f, lenf - 1), coeff(g, leng - 1); check=check)
      f = f - shift_left(q1*g, lenf - leng)
      if length(f) == lenf # inexact case
         f = set_length!(f, normalise(f, lenf - 1))
      end
   end
   check && length(f) != 0 && throw(ArgumentError("not an exact division"))
   q = parent(f)(d)
   q = set_length!(q, lenq)
   return q
end

function mod(f::PolyElem{T}, g::PolyElem{T}) where T <: RingElement
   check_parent(f, g)
   if length(g) == 0
      throw(DivideError())
   end
   if length(f) >= length(g)
      f = deepcopy(f)
      b = leading_coefficient(g)
      g = inv(b)*g
      c = base_ring(f)()
      while length(f) >= length(g)
         l = -leading_coefficient(f)
         for i = 1:length(g) - 1
            c = mul!(c, coeff(g, i - 1), l)
            u = coeff(f, i + length(f) - length(g) - 1)
            u = addeq!(u, c)
            f = setcoeff!(f, i + length(f) - length(g) - 1, u)
         end
         f = set_length!(f, normalise(f, length(f) - 1))
      end
   end
   return f
end

function gcd(a::PolyElem{T}, b::PolyElem{T}) where {T <: FieldElement}
   check_parent(a, b)
   if length(a) > length(b)
      (a, b) = (b, a)
   end
   if iszero(b)
      if iszero(a)
         return(a)
      else
         d = leading_coefficient(a)
         return divexact(a, d)
      end
   end
   g = gcd(content(a), content(b))
   a = divexact(a, g)
   b = divexact(b, g)
   while !iszero(a)
      (a, b) = (mod(b, a), a)
   end
   b = g*b
   d = leading_coefficient(b)
   return divexact(b, d)
end

function content(a::PolyElem)
   z = base_ring(a)() # normalise first coefficient
   for i = 1:length(a)
      z = gcd(z, coeff(a, i - 1))
   end
   return z
end

function PolynomialRing(R::Ring, s::Symbol; cached::Bool = true)
   return Generic.PolynomialRing(R, s; cached=cached)
end

