export RationalFunctionField

parent_type(::Type{Rat{T}}) where T <: FieldElement = RationalFunctionField{T}

elem_type(::Type{RationalFunctionField{T}}) where T <: FieldElement = Rat{T}

base_ring(a::RationalFunctionField{T}) where T <: FieldElement = a.base_ring::parent_type(T)

base_ring(a::Rat) = base_ring(parent(a))

parent(a::Rat) = a.parent

data(x::Rat{T}) where T <: FieldElement = x.d::Frac{dense_poly_type(T)}

function fraction_field(a::RationalFunctionField{T}) where T <: FieldElement
   return a.fraction_field::FracField{dense_poly_type(T)}
end

function check_parent(a::Rat{T}, b::Rat{T}, throw::Bool = true) where T <: FieldElement
   fl = parent(a) != parent(b)
   fl && throw && error("Incompatible rings in rationa function field operation")
   return !fl
end

function Base.denominator(a::Rat, canonicalise::Bool=true)
   return denominator(data(a), canonicalise)
end

function *(a::Rat{T}, b::Rat{T}) where T <: FieldElement
   check_parent(a, b)
   R = parent(a)
   return R(data(a) * data(b))
end

promote_rule(::Type{Rat{T}}, ::Type{Rat{T}}) where T <: FieldElement = Rat{T}

promote_rule(::Type{Rat{T}}, ::Type{Rat{T}}) where T <: FieldElem = Rat{T}

function promote_rule(::Type{Rat{T}}, ::Type{U}) where {T <: FieldElement, U <: RingElem}
   promote_rule(Frac{dense_poly_type(T)}, U) === Frac{dense_poly_type(T)} ? Rat{T} : Union{}
end

function (a::RationalFunctionField{T})(b::Frac{<:PolyElem{T}}) where T <: FieldElement
   K = fraction_field(a)
   parent(b) != K && error("Unable to coerce rational function")
   z = Rat{T}(b)
   z.parent = a
   return z::Rat{T}
end

function (a::RationalFunctionField)(b::RingElem)
   return a(fraction_field(a)(b))
end

function RationalFunctionField(k::Field, s::Symbol; cached=true)
   T = elem_type(k)

   R, x = AbstractAlgebra.PolynomialRing(k, s, cached=cached)
   g = x//1
   t = Rat{T}(g)

   par_object = RationalFunctionField{T}(k, parent(g), s, cached)

   t.parent = par_object

   return par_object, t
end
