matricule = 568936
bulletsize = 8; bulletcolor = 'blue';
bullet = {'o','markerfacecolor',bulletcolor,'color',bulletcolor,...
          'markersize',bulletsize};
    rand('state',matricule);
if exist('condA') ~= 1, condA = 1.e14; end
if exist('sizeA') ~= 1, sizeA = 10; end
n = sizeA;

% create matrices of size n x n with given condition number
% First make random matrix
X = rand(n,n);
% then find QR-factorisation to obtain an orthogonal matrix U
[U R] = qr(X);
% repeat the procedure to obtain an orthogonal matrix V
X = rand(n,n);
[V R] = qr(X);
% construct a diagonal matrix with condition number as given
Sigma = diag(1+(n-1:-1:0)/(n-1)*(condA-1));
A = U*Sigma*V';
% reduce values of A to the interval [-1,1]
A = A/max(max(abs(A)));
% check that condition number is as given
condAtest = cond(A);

x = floor(10*rand(n,1));

format long

[L, U] = lu(A);
%calcul de b grace a la factorisation LU
y = U*x;
b = L * y

xhat0 = A\b % solution initiale

nit = 20;
rr = zeros(n,nit+1); eehat = zeros(n,nit+1);

xhat = xhat0;

r = b - A * xhat;

for i = 1:nit
    % calcul de ehat en partant de r = A*e et donc LU*e
    % permet deviter l'utilisation de e = A**-1*r (operation d'inversion)
    y = L\r;
    ehat = U\y;
    
    % mise a jour de xhat
    xhat = xhat + ehat;
    % stockage du résidu et de l'erreur
    rr(:, i) = r; eehat(:, i) = ehat; 
    
    % mise a jour de r
    r = r - A*ehat;
end
% Question 4 :

% 1 .verification de la dominance diagonal 
% (voir fichier isStrictDominant.m)
isAStrictlyDominant = isStrictDominant(A);

if isAStrictlyDominant
    fprintf('les méthodes de Jacobi et Gauss-Seidel sont convergentes\n')  
else 

    % 2 .verification de la symetrie definie positif  
    % (voir fichier isSymetricDefinedPos.m)
    isASym = isSymetricDefinedPos(A);

    D = diag(diag(A));
    istwoDMinusASym = isSymetricDefinedPos(2*D - A);
    
    if isASym
        fprintf('la méthode de Gauss-Seidel est convergente.\n')
        if istwoDMinusASym
            fprintf('la méthode de Jacobi est convergente\n')
        end
    else 
        % methode de rayon spectrale
        L = tril(A, -1);
        U = triu(A, 1);

        % creation de la matrice d'iteration gauss seidel
        [LG UG] = lu(D + L);
        y = LG\U;
        XG = UG\y;
        IterationMatrixGauss = -XG;
        rayonSpec = max((abs(eig(IterationMatrixGauss))));

        if rayonSpec < 1
            fprintf('la méthode de Gauss-Seidel est convergente.\n')
        else
            fprintf('la méthode de Gauss-Seidel est pas convergente.\n')
        end
        
        % creation de la matrice d'iteration jacobi
        [LJ UJ] = lu(D);
        y = LJ\(L+U);
        XJ = UJ\y;
        IterationMatrixJacobi = -XJ;
        rayonSpec = max((abs(eig(IterationMatrixJacobi))));


        if rayonSpec < 1
            fprintf('la méthode de jacobi est convergente.\n')
        else
            fprintf('la méthode de jacobi est pas convergente.\n')
        end
   

    end
end


normrr = sqrt(sum(rr.^2));
figure;
plot((0:nit),log10(normrr),'b','linewidth',3)
hold on
plot((0:nit),log10(normrr),bullet{:})
hold off
title('Evolution de la norme rr');

normeehat = sqrt(sum(eehat.^2));
figure;
plot((0:nit),log10(normeehat),'b','linewidth',3)
hold on
plot((0:nit),log10(normeehat),bullet{:})
hold off
title('Evolution de la norme eehat');


