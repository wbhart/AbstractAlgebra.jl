# Deprecated in 0.9.*

@deprecate powmod(x, y, z) powermod(x, y, z)

# Deprecated in 0.15.*

@deprecate trail(f) trailing_coefficient(f)

@deprecate lead(f) leading_coefficient(f)

@deprecate lc(f) leading_coefficient(f)

@deprecate lm(f) leading_monomial(f)

@deprecate lt(f) leading_term(f)

@deprecate valence(f::Generic.PolyElem) trailing_coefficient(f)

@deprecate coeffs(a::AbstractAlgebra.MPolyElem{T}) where T <: RingElement coefficients(a)

# Deprecated in 0.16.*

@deprecate map_coeffs(g, p::PolyElem; cached=true, parent=Generic._make_parent(g, p, cached)) map_coefficients(g, p; cached=cached, parent=parent)

@deprecate map_coeffs(f, p::MPolyElem; cached = true, parent = Generic._change_mpoly_ring(parent(f(zero(base_ring(p)))), parent(p), cached)) map_coefficients(f, p; cached = cached, parent = parent)

# Deprecated in 0.18.*

@deprecate involves_at_most_one_variable(p::AbstractAlgebra.MPolyElem) isunivariate(p)

