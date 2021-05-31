###############################################################################
#
#  Power testing and root
#
###############################################################################

function ispower(a::RingElem, n::Int)
    if isone(a) || iszero(a)
        return true, a
    end
    if isone(-a) && isodd(n)
        return true, a
    end
    R = parent(a)
    Rt = UPolyRing(R)
    t = gen(Rt)
    r = roots(t^n-a)
    if length(r) == 0
        return false, a
    else
        return true, r[1]
    end
end
  
function root(a::RingElem, n::Int)
    fl, b = ispower(a, n)
    fl || error("element does not have a $n-th root")
    return b
end
