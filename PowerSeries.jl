###########################################################################################
#
#   PowerSeries.jl : Power series over rings
#
###########################################################################################    

export PowerSeries, PowerSeriesRing, O

###########################################################################################
#
#   Data types and memory management
#
###########################################################################################

type PowerSeries{T <: Ring, S} <: Ring
   data :: Union(fmpz_poly, fmpz_mod_poly, fmpq_poly, fq_poly, PolyStruct{T})
   prec :: Union(Nothing, Int)

   PowerSeries(a :: PolyStruct{T}, n :: Union(Nothing, Int)) = new(a, n)   

   PowerSeries(a::fmpz_mod_poly, n :: Union(Nothing, Int)) = new(a, n)
   
   PowerSeries(a :: fmpz_poly, n :: Union(Nothing, Int)) = new(a, n)
   
   PowerSeries(a :: fmpq_poly, n :: Union(Nothing, Int)) = new(a, n)
   
   PowerSeries(a :: fq_poly, n :: Union(Nothing, Int)) = new(a, n)
   
   PowerSeries() = PowerSeries(PowerSeries{T, S}, Array(T, 0), nothing)
   
   PowerSeries(a::Integer) = a == 0 ? PowerSeries(PowerSeries{T, S}, Array(T, 0), nothing) : PowerSeries(PowerSeries{T, S}, [T(a)], nothing)
   PowerSeries(a::T) = PowerSeries(PowerSeries{T, S}, [a], nothing)
   PowerSeries(a::PowerSeries{T, S}) = a
   PowerSeries{R <: Ring}(a::R) = convert(PowerSeries{T, S}, a)
end

function PowerSeries{T, S}(::Type{PowerSeries{T, S}}, a :: Array{T, 1}, n :: Union(Nothing, Int))
   len = length(a)
   d = PolyStruct(a, len)
   z = PowerSeries{T, S}(d, n)
   z.data.length = normalise(z, len)
   return z
end

function O{T, S}(a :: PowerSeries{T, S})
   prec = a.data.length - 1
   prec < 0 && error("Power series must have nonnegative precision")
   return PowerSeries(PowerSeries{T, S}, Array(T, 0), prec)
end

###########################################################################################
#
#   Basic manipulation
#
###########################################################################################    
   
function normalise{T <: Ring, S}(a::PowerSeries{T, S}, len::Int)
   while len > 0 && a.data.coeffs[len] == 0 # cannot use coeff(a, len - 1) here
      len -= 1
   end

   return len
end

coeff{T <: Ring, S}(a::PowerSeries{T, S}, n::Int) = n >= a.data.length ? 0 : a.data.coeffs[n + 1]

isgen{T <: Ring, S}(a::PowerSeries{T, S}) = a.prec == nothing && a.data.length == 2 && a.data.coeffs[1] == 0 && a.data.coeffs[2] == 1

zero{T <: Ring, S}(::Type{PowerSeries{T, S}}) = PowerSeries{T, S}(0)

one{T <: Ring, S}(::Type{PowerSeries{T, S}}) = PowerSeries{T, S}(1)

gen{T <: Ring, S}(::Type{PowerSeries{T, S}}) = PowerSeries(PowerSeries{T, S}, [T(0), T(1)], nothing)

###########################################################################################
#
#   String I/O
#
###########################################################################################

function show{T <: Ring, S}(io::IO, x::PowerSeries{T, S})
   len = x.data.length

   if len == 0
      print(io, zero(T))
   else
      coeff_printed = false
      c = x.data.coeffs[1]
      bracket = needs_parentheses(c)
      if c != 0
         if bracket
            print(io, "(")
         end
         show(io, c)
         if bracket
            print(io, ")")
         end
         coeff_printed = true
      end
      for i = 2:len
         c = x.data.coeffs[i]
         bracket = needs_parentheses(c)
         if c != 0
            if coeff_printed && !is_negative(c)
               print(io, "+")
            end
            if c != 1 && (c != -1 || show_minus_one(typeof(c)))
               if bracket
                  print(io, "(")
               end
               show(io, c)
               if bracket
                  print(io, ")")
               end
               print(io, "*")
            end
            if c == -1 && !show_minus_one(typeof(c))
               print(io, "-")
            end
            print(io, string(S))
            if i != 2
               print(io, "^")
               print(io, i - 1)
            end
            coeff_printed = true
         end
      end
      
   end
   if x.prec != nothing
      print(io, "+O(", string(S), "^", x.prec, ")")
   end
end

function show{T <: Ring, S}(io::IO, ::Type{PowerSeries{T, S}})
   print(io, "Univariate power series ring in ", string(S), " over ")
   show(io, T)
end

needs_parentheses{T <: Ring, S}(x::PowerSeries{T, S}) = x.data.length > 1

is_negative{T <: Ring, S}(x::PowerSeries{T, S}) = x.data.length <= 1 && is_negative(coeff(x, 0))

show_minus_one{T <: Ring, S}(::Type{PowerSeries{T, S}}) = show_minus_one(T)

###########################################################################################
#
#   Unary operations
#
###########################################################################################

function -{T <: Ring, S}(a::PowerSeries{T, S})
   len = a.data.length
   d = Array(T, len)
   for i = 1:len
      d[i] = -a.data.coeffs[i]
   end
   z = PowerSeries(PowerSeries{T, S}, d, a.prec)
   z.data.length = len
   return z
end

###########################################################################################
#
#   Binary operations
#
###########################################################################################

function +{T <: Ring, S}(a::PowerSeries{T, S}, b::PowerSeries{T, S})
   lena = a.data.length
   lenb = b.data.length
   if a.prec == nothing
      prec = b.prec
   elseif b.prec == nothing
      prec = a.prec
   else
      prec = min(a.prec, b.prec)
   end
   if prec != nothing
      lena = min(lena, prec)
      lenb = min(lenb, prec)
   end
   lenz = max(lena, lenb)
   d = Array(T, lenz)
   i = 1

   while i <= min(lena, lenb)
      d[i] = a.data.coeffs[i] + b.data.coeffs[i]
      i += 1
   end

   while i <= lena
      d[i] = a.data.coeffs[i]
      i += 1
   end

   while i <= lenb
      d[i] = b.data.coeffs[i]
      i += 1
   end

   z = PowerSeries(PowerSeries{T, S}, d, prec)

   z.data.length = normalise(z, i - 1)

   return z
end
  
function -{T <: Ring, S}(a::PowerSeries{T, S}, b::PowerSeries{T, S})
   lena = a.data.length
   lenb = b.data.length
   if a.prec == nothing
      prec = b.prec
   elseif b.prec == nothing
      prec = a.prec
   else
      prec = min(a.prec, b.prec)
   end
   if prec != nothing
      lena = min(lena, prec)
      lenb = min(lenb, prec)
   end
   lenz = max(lena, lenb)
   d = Array(T, lenz)
   i = 1

   while i <= min(lena, lenb)
      d[i] = a.data.coeffs[i] - b.data.coeffs[i]
      i += 1
   end

   while i <= lena
      d[i] = a.data.coeffs[i]
      i += 1
   end

   while i <= lenb
      d[i] = -b.data.coeffs[i]
      i += 1
   end

   z = PowerSeries(PowerSeries{T, S}, d, prec)

   z.data.length = normalise(z, i - 1)

   return z
end

function *{T <: Ring, S}(a::PowerSeries{T, S}, b::PowerSeries{T, S})
   lena = a.data.length
   lenb = b.data.length
   if a.prec == nothing
      prec = b.prec
   elseif b.prec == nothing
      prec = a.prec
   else
      prec = min(a.prec, b.prec)
   end
   if prec != nothing
      lena = min(lena, prec)
      lenb = min(lenb, prec)
   end

   if lena == 0 || lenb == 0
      return PowerSeries(PowerSeries{T, S}, [], prec)
   end

   t = T()

   lenz = prec == nothing ? lena + lenb - 1 : min(lena + lenb - 1, prec)

   d = Array(T, lenz)

   for i = 1:min(lena, lenz)
      d[i] = a.data.coeffs[i]*b.data.coeffs[1]
   end

   if lenz > lena
      for j = 2:min(lenb, lenz - lena + 1)
          d[lena + j - 1] = a.data.coeffs[lena]*b.data.coeffs[j]
      end
   end

   z = PowerSeries(PowerSeries{T, S}, d, prec)

   for i = 1:lena - 1
      if lenz > i
         for j = 2:min(lenb, lenz - i + 1)
            mul!(t, a.data.coeffs[i], b.data.coeffs[j])
            addeq!(z.data.coeffs[i + j - 1], t)
         end
      end
   end
        
   z.data.length = normalise(z, lenz)

   return z
end

###########################################################################################
#
#   Unsafe functions
#
###########################################################################################

function fit!{T <: Ring, S}(c::PowerSeries{T, S}, n::Int)
   if c.data.length < n
      t = c.data.coeffs
      c.data.coeffs = Array(T, n)
      for i = 1:c.data.length
         c.data.coeffs[i] = t[i]
      end
      for i = c.data.length + 1:n
         c.data.coeffs[i] = zero(T)
      end
   end
end

function setcoeff!{T <: Ring, S}(c::PowerSeries{T, S}, n::Int, a::T)
   if (a != 0 && (c.prec == nothing || c.prec > n)) || n + 1 <= c.data.length
      fit!(c, n + 1)
      c.data.coeffs[n + 1] = a
      c.data.length = max(c.data.length, n + 1)
      # don't normalise
   end
end

function mul!{T <: Ring, S}(c::PowerSeries{T, S}, a::PowerSeries{T, S}, b::PowerSeries{T, S})
   lena = a.data.length
   lenb = b.data.length

   if a.prec == nothing
      prec = b.prec
   elseif b.prec == nothing
      prec = a.prec
   else
      prec = min(a.prec, b.prec)
   end
   if prec != nothing
      lena = min(lena, prec)
      lenb = min(lenb, prec)
   end

   if lena == 0 || lenb == 0
      c.data.length = 0
   else
      t = T()

      lenc = prec == nothing ? lena + lenb - 1 : min(lena + lenb - 1, prec)
      fit!(c, lenc)

      for i = 1:min(lena, lenc)
         mul!(c.data.coeffs[i], a.data.coeffs[i], b.data.coeffs[1])
      end

      if lenc > lena
         for i = 2:min(lenb, lenc - lena + 1)
            mul!(c.data.coeffs[lena + i - 1], a.data.coeffs[lena], b.data.coeffs[i])
         end
      end

      for i = 1:lena - 1
         if lenc > i
            for j = 2:min(lenb, lenc - i + 1)
               mul!(t, a.data.coeffs[i], b.data.coeffs[j])
               addeq!(c.data.coeffs[i + j - 1], t)
            end
         end
      end
        
      c.data.length = normalise(c, lenc)
   end
   c.prec = prec
end

function addeq!{T <: Ring, S}(c::PowerSeries{T, S}, a::PowerSeries{T, S})
   lenc = c.data.length
   lena = a.data.length
   if a.prec == nothing
      prec = c.prec
   elseif c.prec == nothing
      prec = a.prec
   else
      prec = min(a.prec, c.prec)
   end
   if prec != nothing
      lena = min(lena, prec)
      lenc = min(lenc, prec)
   end
   len = max(lenc, lena)
   fit!(c, len)
   for i = 1:lena
      addeq!(c.data.coeffs[i], a.data.coeffs[i])
   end
   c.data.length = normalise(c, len)
   c.prec = prec
end

###########################################################################################
#
#   Ad hoc binary operators
#
###########################################################################################

function *{T <: Ring, S}(a::Int, b::PowerSeries{T, S})
   len = b.data.length
   d = Array(T, len)
   for i = 1:len
      d[i] = a*coeff(b, i - 1)
   end
   z = PowerSeries(PowerSeries{T, S}, d, b.prec)
   z.data.length = normalise(z, len)
   return z
end

function *{T <: Ring, S}(a::ZZ, b::PowerSeries{T, S})
   len = b.data.length
   d = Array(T, len)
   for i = 1:len
      d[i] = a*coeff(b, i - 1)
   end
   z = PowerSeries(PowerSeries{T, S}, d, b.prec)
   z.data.length = normalise(z, len)
   return z
end

*{T <: Ring, S}(a::Poly{T, S}, b::Int) = b*a

*{T <: Ring, S}(a::Poly{T, S}, b::ZZ) = b*a

###########################################################################################
#
#   Powering
#
###########################################################################################

function ^{T <: Ring, S}(a::PowerSeries{T, S}, b::Int)
   b < 0 && throw(DomainError())
   # special case powers of x for constructing power series efficiently
   if a.prec == nothing && a.data.length == 2 && a.data.coeffs[1] == 0 && a.data.coeffs[2] == 1
      d = Array(T, b + 1)
      d[b + 1] = a.data.coeffs[2]
      for i = 1:b
         d[i] = a.data.coeffs[1]
      end
      z = PowerSeries(PowerSeries{T, S}, d, nothing)
      z.data.length = b + 1
      return z
   elseif a.data.length == 0
      return PowerSeries(PowerSeries{T, S}, [], a.prec)
   elseif a.data.length == 1
      return PowerSeries(PowerSeries{T, S}, [a.data.coeffs[1]^b], a.prec)
   elseif b == 0
      return PowerSeries(PowerSeries{T, S}, [T(1)], a.prec)
   else
      bit = ~((~uint(0)) >> 1)
      while (int(bit) & b) == 0
         bit >>= 1
      end
      z = a
      bit >>= 1
      while bit !=0
         z = z*z
         if (int(bit) & b) != 0
            z *= a
         end
         bit >>= 1
      end
      return z
   end
end
   

###########################################################################################
#
#   PowerSeriesRing constructor
#
###########################################################################################

function PowerSeriesRing{T <: Ring}(::Type{T}, s::String)
   S = symbol(s)
   T1 = PowerSeries{T, S}
   T2 = T
   
   # Conversions and promotions

   Base.convert(::Type{T1}, x::T) = PowerSeries(T1, [x], nothing)
   Base.promote_rule(::Type{T1}, ::Type{T}) = T1

   P = T2.parameters
   while length(P) > 0
      T2 = P[1]
      if isa(T2, DataType) && T2 <: Ring
         Base.convert(::Type{T1}, x::T2) = PowerSeries(T1, [convert(T, x)], nothing)
         Base.promote_rule(::Type{T1}, ::Type{T2}) = T1
         P = T2.parameters
      else
         break
      end
   end

   Base.convert(::Type{T1}, x::Integer) = PowerSeries(T1, [convert(T, x)], nothing)
   Base.promote_rule{R <: Integer}(::Type{T1}, ::Type{R}) = T1

   # (Type, gen) 

   return (PowerSeries{T, S}, PowerSeries(PowerSeries{T, S}, [T(0), T(1)], nothing))
end
