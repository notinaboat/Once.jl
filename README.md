# Once.jl


```
@once f()::Type = expression
```

Define funciton `f()` that evaluates `expression` once on the first call. Subsequent calls return a cached value without re-evaluating expression.

```
julia> @once f()::String = (println("foo"); "bar")
f (generic function with 1 method)

julia> f()
foo
"bar"

julia> f()
"bar"
```

