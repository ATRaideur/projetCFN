function isAStrictlyDominant = isStrictDominant(A)

    n = size(A);
    isAStrictlyDominant = true;

    for i = 1:n
        rowSum = sum(abs(A(i,:))) - abs(A(i,i));
        if abs(A(i,i)) <= rowSum
            isAStrictlyDominant = false;
            break;
        end
    end
    
    if isAStrictlyDominant
        for j = 1:n
            colSum = sum(abs(A(:,j))) - abs(A(j,j));
            if abs(A(j,j)) <= colSum
                isAStrictlyDominant = false;
                break;
            end
        end
    end
end
