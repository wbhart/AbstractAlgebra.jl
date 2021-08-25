module Generic

import Base: iszero, //, +, zero, -, parent, ==, one, *

import ..AbstractAlgebra: CacheDictType, get_cached!

import ..AbstractAlgebra: Ring, Field, RingElem, RingElement

import ..AbstractAlgebra: coeff, base_ring, canonical_unit,
                          elem_type, parent_type, promote_rule,
                          set_length!, zero!

using ..AbstractAlgebra

include("generic/GenericTypes.jl")

include("generic/Poly.jl")

include("generic/Fraction.jl")

include("generic/RationalFunctionField.jl")

end # generic
