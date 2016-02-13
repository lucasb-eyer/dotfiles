if 6 < Dates.hour(now()) < 12
    println("おはようございます, Lucas!")
elseif Dates.hour(now()) < 18
    println("こんにちは, Lucas!")
else
    println("こんばんは, Lucas!")
end

# Stolen from https://github.com/JuliaLang/julia/issues/3721
Base.REPLCompletions.latex_symbols["\\koala"] = "\U1f428"
Base.REPLCompletions.latex_symbols["\\slice"] = "\U1f355"
