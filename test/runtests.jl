using Test
using Once

a = "foo"

@once f()::String = begin
    global a
    a *= "bar"
    v = a
    a *= "bar"
    return v
end

@test f() == "foobar"
@test a == "foobarbar"
a = ""
@test f() == "foobar"
@test a == ""
@test f() == "foobar"
@test a == ""

a = 7

@once f2()::Int = begin
    global a
    a *= 2
    v = a
    a *= 2
    return v
end

@test f2() == 14
@test a == 28
a = 1
@test f2() == 14
@test a == 1
@test f2() == 14
@test a == 1
