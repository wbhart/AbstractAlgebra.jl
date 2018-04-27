parent_type(::Type{AsFieldElem{T}}) where T = AsField{T}

elem_type(::Type{AsField{T, S}}) where {T, S} = AsFieldElem{T}

base_ring(R::AsField) = base_ring(R.par)

parent(f::AsFieldElem) = AsField(parent(f.data))

isdomain_type(::Type{AsFieldElem{T}}) where T = true

isexact_type(::Type{AsFieldElem{T}}) where T = isexact_type(T)

check_parent(f::AsFieldElem{T}, g::AsFieldElem{T}) where T = check_parent(f.data, g.data)

hash(f::AsFieldElem{T}, h::UInt) where T = xor(hash(f, h), 0xfc539ca42b8a2f5c)

deepcopy_internal(f::AsFieldElem{T}, dict::ObjectIdDict) where T = AsFieldElem(deepcopy_internal(f.data, dict))

(R::AsField{T})() where T = AsFieldElem(R.par())

(R::AsField{T})(a::Integer) where T = AsFieldElem(R.par(a))

(R::AsField{T})(a::AsFieldElem{T}) where T = AsFieldElem(R.par(a.data))

(R::AsField{T})(a::S) where {S <: AbstractAlgebra.RingElem, T} = AsFieldElem(R.par(a))

zero(R::AsField{T}) where T = AsFieldElem(zero(R.par))

one(R::AsField{T}) where T = AsFieldElem(one(R.par))

iszero(f::AsField{T}) where T = iszero(f.data)

isone(f::AsFieldElem{T}) where T = isone(f.data)

isunit(f::AsFieldElem{T}) where T = isunit(f.data)

canonical_unit(f::AsFieldElem{T}) where T = AsFieldElem(canonical_unit(f.data))

function show(io::IO, R::AsField{T}) where T
   print(io, "Field of ")
   show(io, R.par)
end

function show(io::IO, f::AsFieldElem{T}) where T
   show(io, f.data)
end

needs_parentheses(f::AsFieldElem{T}) where T = needs_parentheses(f.data)

isnegative(f::AsFieldElem{T}) where T = isnegative(f.data)

show_minus_one(f::Type{AsFieldElem{T}}) where T = show_minus_one(T)

-(f::AsFieldElem{T}) where T = AsFieldElem(-f.data)

+(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(a.data + b.data)

-(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(a.data - b.data)

*(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(a.data*b.data)

==(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = a.data == b.data

inv(a::AsFieldElem{T}) where T = AsFieldElem(inv(a.data))

isequal(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = isequal(a.data, b.data)

divexact(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(divexact(a.data, b.data))

zero!(a::AsFieldElem{T}) where T = AsFieldElem(zero!(a.data))

mul!(c::AsFieldElem{T}, a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(mul!(c.data, a.data, b.data))

add!(c::AsFieldElem{T}, a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(add!(c.data, a.data, b.data))

addeq!(a::AsFieldElem{T}, b::AsFieldElem{T}) where T = AsFieldElem(addeq!(a.data, b.data))

+(a::AsFieldElem{T}, b::Integer) where T = AsFieldElem(a.data + b)

-(a::AsFieldElem{T}, b::Integer) where T = AsFieldElem(a.data - b)

*(a::AsFieldElem{T}, b::Integer) where T = AsFieldElem(a.data*b)

==(a::AsFieldElem{T}, b::Integer) where T = a.data == b

+(a::Integer, b::AsFieldElem{T}) where T = AsFieldElem(a + b.data)

-(a::Integer, b::AsFieldElem{T}) where T = AsFieldElem(a - b.data)

*(a::Integer, b::AsFieldElem{T}) where T = AsFieldElem(a*b.data)

==(a::Integer, b::AsFieldElem{T}) where T = a == b.data

divexact(a::AsFieldElem{T}, b::Integer) where T = AsFieldElem(divexact(a.data, b))


