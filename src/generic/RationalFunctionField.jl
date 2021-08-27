parent(a) = a.parent

c(e::T) where T = e.d::Frac

function h(::T) where T
   i::FracField
end

function *(Rat, b::Rat{T}) where T
   c(b)  
end

function (::RationalFunctionField)(b::Frac{T}) where T 
   j && Rat{T}(b)
end

function (a::RationalFunctionField)(b)
   h(a)(b)
end

function RationalFunctionField(k, l; cached)
   T = Int 
   g = 1
   m = Rat{T}(g)
     RationalFunctionField, m
end
