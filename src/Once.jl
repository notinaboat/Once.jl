"""
# Once.jl
"""
module Once

export @once

"""
    @once f()::Type = expression

Define funciton `f()` that evaluates `expression` once on the first call.
Subsequent calls return a cached value without re-evaluating expression.

```
julia> @once f()::String = (println("foo"); "bar")
f (generic function with 1 method)

julia> f()
foo
"bar"

julia> f()
"bar"
```

"""
macro once(ex)
    if !(ex.head == :(=)
    &&   ex.args[1] isa Expr
    &&   ex.args[1].head == :(::)
    &&   ex.args[1].args[1] isa Expr
    &&   ex.args[1].args[1].head == :call
    &&   length(ex.args[1].args[1].args) == 1)
        throw(ArgumentError("Invalid `@once` expression."))
    end

    name = ex.args[1].args[1].args[1]
    type = ex.args[1].args[2]
    init_expression = ex.args[2]

    quote
        let flag = Ref(false), cache = Ref{$type}()

            @noinline init()::$type = $init_expression

            global $name
            Base.@__doc__ @inline function $name()
                if !flag[]
                    cache[] = init()
                    flag[] = true
                end
                cache[]
            end
        end
    end |> esc
end


# Documentation.

readme() = join([
    Docs.doc(@__MODULE__),
    Docs.@doc @once
   ], "\n\n")


end # module
