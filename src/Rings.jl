function a(c::T, d::U) where {T , U}
   return true, c, parent(c)(d)
end

function g(c::T, d::U) where {T , U}
  f, h, i = a(c, d)
  return h, i
end

*(c, d) = *(g(c, d)...)
