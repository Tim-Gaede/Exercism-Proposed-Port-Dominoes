def can_chain(dominoes):
    # Brute force method tests up to n! × 2ⁿ combinations
    if len(dominoes) == 0:
        return []



    indicies = [i   for i in range(0, len(dominoes))]
    numCodes = 2**len(dominoes)


    permuWasLast = False
    while permuWasLast == False:
        domis_test = []
        for i in range(0, len(dominoes)):
            domis_test.append((dominoes[indicies[i]][0], dominoes[indicies[i]][1]))

        code = 0
        while code < numCodes:
            rem = code
            i = 0
            while rem > 0:
                if rem % 2 == 0:
                    domis_test[i] = flipped(domis_test[i])
                rem //= 2
                i += 1

            if solution_valid(domis_test):
                return domis_test

            code += 1

        permuWasLast = next_permu(indicies)

    return None



def solution_valid(dominoes):
    if dominoes[0][0] != dominoes[-1][1]:
        # Starting number does not equal the ending number
        return False

    brokenLink_found = False
    i = 0
    while brokenLink_found == False  and  i < len(dominoes) - 1:
        if dominoes[i][1] != dominoes[i+1][0]:
            brokenLink_found = True

        i += 1

    return brokenLink_found == False





def flipped(tup):
    return (tup[1], tup[0])





def next_permu(arr):
    # Returns a value of true if the permutation is lexicographically last.
    # Find non-increasing suffix
    i = len(arr) - 1
    while i > 0 and arr[i - 1] >= arr[i]:
        i -= 1
    if i <= 0:
        return True

    # Find successor to pivot
    j = len(arr) - 1
    while arr[j] <= arr[i - 1]:
        j -= 1
    arr[i - 1], arr[j] = arr[j], arr[i - 1]

    # Reverse suffix
    arr[i:] = arr[len(arr) - 1: i - 1: -1]
    return False
