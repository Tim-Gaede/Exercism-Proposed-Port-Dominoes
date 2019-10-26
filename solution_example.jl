function can_chain(dominoes::Array{Tuple{Int,Int},1})
    # Brute force method tests up to n! × 2ⁿ combinations
    if length(dominoes) == 0;    return [];    end

    indicies = [i   for i = 1 : length(dominoes)]
    numCodes = 2^length(dominoes)


    permu_was_last = false
    while !permu_was_last
        domis_test = []
        for i = 1 : length(dominoes)
            domi_test = (dominoes[indicies[i]][1], dominoes[indicies[i]][2])
            push!(domis_test, domi_test)
        end

        code = 0
        while code < numCodes
            rem = code
            i = 1
            while rem > 0
                if rem % 2 == 0;    flip!(domis_test, i);    end
                rem ÷= 2
                i += 1
            end
            if solution_valid(domis_test);    return domis_test;    end

            code += 1
        end

        permu_was_last = permuNext!(indicies)
    end

    nothing
end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
function solution_valid(dominoes::Array{Tuple{Int,Int},1})
    # First and last number in the entire chain must be equal
    if first(dominoes)[1] != last(dominoes)[2];    return false;    end

    # There can be no "broken link"
    for i = 1 : length(dominoes) - 1
        if dominoes[i][2] != dominoes[i+1][1];    return false;   end
    end


    true
end
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
function flip!(dominoes::Array{Tuple{Int,Int},1}, index)
    domino_flipped = (dominoes[index][2], dominoes[index][1])

    dominoes[index] = domino_flipped
end
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
function permuNext!(a::Array{Any,1})
 # Returns a value of true if the permutation is lexicographically last.
    len = length(a)
    iₗ = 1

    # Find iₗ
    disorder_fnd = false
    for i = 1 : len-1
        if a[i] < a[i+1]
            disorder_fnd = true
            iₗ = i
        end
    end


    if disorder_fnd
        # Find iᵣ
        iᵣ = iₗ + 1
        for i = iₗ + 2 : len
            if a[iₗ] < a[i];    iᵣ = i; end
        end

        a[iₗ], a[iᵣ]  =  a[iᵣ], a[iₗ] # Swap

        # Swap pairs of elements to the right of iₗ
        pairs = (len - iₗ)  ÷  2
        for p = 1 : pairs
            a[iₗ + p], a[len - p + 1]  =  a[len - p + 1], a[iₗ + p]
        end
    end

    !disorder_fnd
end
#-------------------------------------------------------------------------------
