export FractionField

base_ring(a::FracField{T}) where T <: RingElem = a.base_ring::parent_type(T)

base_ring(a::FracElem) = base_ring(parent(a))

parent(a::FracElem) = a.parent

function check_parent(a::FracElem, b::FracElem, throw::Bool = true)
   fl = parent(a) != parent(b)
   fl && throw && error("Incompatible rings in fraction field operation")
   return !fl
end

function //(x::T, y::T) where {T <: RingElem}
   R = parent(x)
   iszero(y) && throw(DivideError())
   g = gcd(x, y)
   z = Generic.Frac{T}(divexact(x, g), divexact(y, g))
   try
      z.parent = Generic.FracDict[R]
   catch
      z.parent = Generic.FractionField(R)
   end
   return z
end

function *(a::FracElem{T}, b::FracElem{T}) where {T <: RingElem}
   check_parent(a, b)
   n1 = numerator(a, false)
   d2 = denominator(b, false)
   n2 = numerator(b, false)
   d1 = denominator(a, false)
   if d1 == d2
      n = n1*n2
      d = d1*d2
   elseif isone(d1)
      gd = gcd(n1, d2)
      if isone(gd)
         n = n1*n2
         d = deepcopy(d2)
      else
         n = divexact(n1, gd)*n2
         d = divexact(d2, gd)
      end
   elseif isone(d2)
      gd = gcd(n2, d1)
      if isone(gd)
         n = n2*n1
         d = deepcopy(d1)
      else
         n = divexact(n2, gd)*n1
         d = divexact(d1, gd)
      end
   else
      g1 = gcd(n1, d2)
      g2 = gcd(n2, d1)
      if !isone(g1)
         n1 = divexact(n1, g1)
         d2 = divexact(d2, g1)
      end
      if !isone(g2)
         n2 = divexact(n2, g2)
         d1 = divexact(d1, g2)
      end
      n = n1*n2
      d = d1*d2
   end
   return parent(a)(n, d)
end

function FractionField(R::Ring; cached=true)
   return Generic.FractionField(R; cached=cached)
end
