###############################################################################
#
#   Integers / Integer
#
###############################################################################

struct Integers{T <: Integer} <: Ring
end

###############################################################################
#
#   Rationals / Rational
#
###############################################################################

struct Rationals{T <: Integer} <: Field
end

const RingElement   = Union{RingElem,   Integer, Rational, AbstractFloat}

const FieldElement = Union{FieldElem, Rational, AbstractFloat}
