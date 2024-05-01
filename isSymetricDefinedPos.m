function isSymetric = isSymetricDefinedPos(A)

isSymetric = true;

n = size(A);
for k = 1:n
    determinant = det(A(1:k, 1:k));
    if determinant <= 0
        isSymetric = false;
        break;
    end
end
