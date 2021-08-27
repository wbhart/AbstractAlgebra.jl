struct FracField
end

struct Frac{T}
   b
   
   Frac{T}(c, den) where T = new()
end

struct RationalFunctionField{e} 
end

mutable struct Rat{T}
   d
   parent::RationalFunctionField{T}
   
   Rat{T}(f) where T = new(f)
end
