"""
# Once.jl
"""
module Once

export @once

"""
    @once var::Type = init_expression

Define `const var`, initiliased once on first access.
Value is accessed via `var[]`.
"""
macro once(ex)
    if !(ex.head == :(=)
    &&   ex.args[1] isa Expr
    &&   ex.args[1].head == :(::)
    &&   ex.args[1].args[1] isa Symbol)
        throw(ArgumentError("Invalid `@once` expression."))
    end

    name = ex.args[1].args[1]
    type = ex.args[1].args[2]
    init = ex.args[2]
    wrapper = Symbol(name, "_wrapper")

    esc(quote
        mutable struct $wrapper
            value::$type
            $wrapper() = new()
        end

        const $name = $wrapper()

        function Base.getindex(once::$wrapper)
            @show once
            if !isdefined(once, :value)
                once.value = $init
            end
            once.value
        end
    end)
end


# Documentation.

readme() = join([
    Docs.doc(@__MODULE__),
    Docs.@doc @once
   ], "\n\n")


end # module
