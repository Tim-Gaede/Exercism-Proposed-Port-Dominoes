using Test

include("dominoes.jl")


# Tests adapted from `problem-specifications//canonical-data.json` @ v2.1.0


println("\n"^2, "-"^60, "\n"^3)

@testset "Empty input empty output." begin
    input = []
    solution = can_chain(input)
    @test solution == []
end
println()

@testset "Singleton input singleton output." begin
    input = [(1, 1)]
    solution = can_chain(input)
    @test solution_valid(input, solution) == true
end
println()

@testset "Singleton can't be chained." begin
    input = [(1, 2)]
    solution = can_chain(input)
    @test solution == nothing
end
println()

@testset "Three elements." begin
    input = [(1, 2), (3, 1), (2, 3)]
    solution = can_chain(input)
    @test solution_valid(input, solution) == true
end
println()

@testset "Can reverse dominoes." begin
    input = [(1, 2), (1, 3), (2, 3)]
    solution = can_chain(input)
    @test solution_valid(input, solution) == true
end
println()

@testset "Can't be chained." begin
    input = [(1, 2), (4, 1), (2, 3)]
    solution = can_chain(input)
    @test solution == nothing
end
println()

@testset "Disconnected simple." begin
    input = [(1, 1), (2, 2)]
    solution = can_chain(input)
    @test solution == nothing
end
println()

@testset "Disconnected double loop." begin
    input = [(1, 2), (2, 1), (3, 4), (4, 3)]
    solution = can_chain(input)
    @test solution == nothing
end
println()

@testset "Disconnected single isolated." begin
    input = [(1, 2), (2, 3), (3, 1), (4, 4)]
    solution = can_chain(input)
    @test solution == nothing
end
println()

@testset "Need backtrack." begin
    input = [(1, 2), (2, 3), (3, 1), (2, 4), (2, 4)]
    solution = can_chain(input)
    @test solution_valid(input, solution) == true
end
println()

@testset "Separate loops." begin
    input = [(1, 2), (2, 3), (3, 1), (1, 1), (2, 2), (3, 3)]
    solution = can_chain(input)
    @test solution_valid(input, solution) == true
end
println()


println("\n\nNow testing nine dominoes.")
println("A brute force method should still take under a minute.\n")
@testset "Nine elements." begin
    input = [(1, 2), (5, 3), (3, 1), (1, 2), (2, 4), (1, 6),
                      (2, 3), (3, 4), (5, 6)]
    time = @timed solution = can_chain(input)

    print("It took ", time[2], " seconds.  ")

    if time[2] < 1.0e-5
        println("You're not cheating, right?")
    elseif time[2] < 1.0
        println("WOW!  That was fast!")
    elseif time[2] < 60.0
        println("Not too long.")
    else
        println("That was a bit long.")
    end

    println()

    @test solution_valid(input, solution) == true
end
println()


# Utility functions:
#-------------------------------------------------------------------------------
function flip!(dominoes::Array{Tuple{Int,Int},1}, index)
    domino_flipped = (dominoes[index][2], dominoes[index][1])

    dominoes[index] = domino_flipped
end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
function solution_valid(input::Array{Tuple{Int,Int},1}, soln::Array{Any,1})

    # First and last number in the entire chain must be equal
    if first(soln)[1] != last(soln)[2];    return false;    end


    # There can be no "broken link"
    for i = 1 : length(soln) - 1
        if soln[i][2] != soln[i+1][1];    return false;   end
    end


    # The input and output must be the same dominoes
    if length(input) != length(soln);    return false;    end


    input_test = input
    for i = 1 : length(input_test)
        if input_test[i][1] > input_test[i][2];    flip!(input_test, i);  end
    end
    sort!(input_test)

    soln_test = soln
    for i = 1 : length(soln_test)
        if soln_test[i][1] > soln_test[i][2];    flip!(soln_test, i);  end
    end
    sort!(soln_test)


    for i = 1 : length(input)
        if input_test[i][1] != soln_test[i][1];    return false;    end
        if input_test[i][2] != soln_test[i][2];    return false;    end
    end




    true
end
#-------------------------------------------------------------------------------
