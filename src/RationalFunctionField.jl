export RationalFunctionField

function RationalFunctionField(k::Field, s::String; cached=true)
   return Generic.RationalFunctionField(k, Symbol(s); cached=cached)
end



