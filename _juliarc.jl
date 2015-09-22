if 6 < Dates.hour(now()) < 12
    println("おはようございます, Lucas!")
elseif Dates.hour(now()) < 18
    println("こんにちは, Lucas!")
else
    println("こんばんは, Lucas!")
end
