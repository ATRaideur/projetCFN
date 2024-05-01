function isAStrictlyDominant = isStrictDominant(A)
    % Check if matrix A is strictly dominant

    % Check if A is square
    n = size(A);
    isAStrictlyDominant = true;

    % Check rows
    for i = 1:n
        rowSum = sum(abs(A(i,:))) - abs(A(i,i));
        if abs(A(i,i)) <= rowSum
            isAStrictlyDominant = false;
            break;
        end
    end
    
    % Check columns if rows are strictly dominant
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
