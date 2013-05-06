function [CVA] = spm_cva(Y,X,X0,c,U)
% Canonical Variate Analysis
% FORMAT [CVA] = spm_cva(Y,X,X0,c,[U])
% Y            - data
% X            - design
% X0           - null space
% c            - contrast weights
% U            - dimension reduction (projection matrix)
% 
% 
% CVA.c        - contrast weights
% CVA.X        - contrast subspace
% CVA.Y        - whitened and adjusted data
% CVA.X0       - null space of contrast
% 
% CVA.V        - canonical vectors  (data)
% CVA.v        - canonical variates (data)
% CVA.W        - canonical vectors  (design)
% CVA.w        - canonical variates (design)
% CVA.C        - canonical contrast (design)
% 
% CVA.r        - canonical correlations
% CVA.chi      - Chi-squared statistics testing D >= i
% CVA.df       - d.f.
% CVA.p        - p-values
%
%__________________________________________________________________________
% 
% CVA uses the generalised eigenvalue solution to the treatment and
% residual sum of squares and products of a general linear model. The
% eigenvalues (i.e., canonical values), after transformation, have a
% chi-squared distribution and allow one to test the null hypothesis that
% the mapping is D or more dimensional. The first p-value is formally
% identical to that obtained using Wilks' Lambda and tests for the 
% significance of any mapping.
% 
% This routine uses the current contrast to define the subspace of interest
% and treats the remaining design as uninteresting. Conventional results
% for the canonical values are used after the data (and design matrix) have
% been whitened; using the appropriate ReML estimate of non-sphericity.
% 
% References:
% 
% Characterizing dynamic brain responses with fMRI: a multivariate
% approach. Friston KJ, Frith CD, Frackowiak RS, Turner R. NeuroImage. 1995
% Jun;2(2):166-72.
%
% A multivariate analysis of evoked responses in EEG and MEG data. Friston
% KJ, Stephan KM, Heather JD, Frith CD, Ioannides AA, Liu LC, Rugg MD,
% Vieth J, Keber H, Hunter K, Frackowiak RS. NeuroImage. 1996 Jun;
% 3(3):167-174.
%__________________________________________________________________________
% Copyright (C) 2008-2011 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: spm_cva.m 5408 2013-04-12 19:03:58Z karl $


if nargin < 3, X0 = [];             end
if nargin < 4, c  = eye(size(X,2)); end
if isempty(c), c  = eye(size(X,2)); end

%-Get null-space of contrast
%--------------------------------------------------------------------------
X0    = [X0, X - X*c*pinv(c)];
X     = full(X*c);
X0    = spm_svd(X0);


%-Dimension reduction (if necessary)
%==========================================================================
if nargin < 5
    [n m] = size(Y);
    n     = fix(n/4);
    if m > n
        U = spm_svd(Y');
        try
            U = U(:,1:n);
        end
    else
        U = speye(size(Y,2));
    end
else
    U = spm_svd(U);
end
Y     = Y*U;


%-Canonical Variates Analysis
%==========================================================================

%-Remove null space of contrast
%--------------------------------------------------------------------------
Y     = Y - X0*(X0'*Y);
X     = X - X0*(X0'*X);
P     = pinv(X);

%-Degrees of freedom
%--------------------------------------------------------------------------
[n,m] = size(Y);
b     = rank(X);
h     = min(b,m);
f     = n - b - size(X0,2);

%-Generalised eigensolution for treatment and residual sum of squares
%--------------------------------------------------------------------------
T     = X*(P*Y);
SST   = T'*T;
SSR   = Y - T;
SSR   = SSR'*SSR;
[v,d] = eig(SSR\SST);
[q,r] = sort(-real(diag(d)));
r     = r(1:h);
d     = real(d(r,r));
v     = real(v(:,r));
V     = U*v;                       % canonical vectors  (data)
v     = Y*v;                       % canonical variates (data)
W     = P*v;                       % canonical vectors  (design)
w     = X*W;                       % canonical variates (design)
C     = c*W;                       % canonical contrast (design)

%-Inference on dimensionality - p(i) test of D >= i; Wilks' Lambda := p(1)
%--------------------------------------------------------------------------
cval  = diag(d);
[chi, df, p, r] = deal(zeros(1,h));
for i = 1:h
    chi(i) = (f - (m - b + 1)/2)*sum(log(cval(i:h) + 1));
    df(i)  = (m - i + 1)*(b - i + 1);
    p(i)   = 1 - spm_Xcdf(chi(i),df(i));
    r(i)   = sqrt(cval(i) / (1 + cval(i)));
end

%-Prevent overflow
%--------------------------------------------------------------------------
p          = max(p,exp(-16));
r          = min(max(r,0),1);


%-Assemble results
%==========================================================================
CVA.X      = X;                    % contrast subspace
CVA.Y      = Y;                    % whitened and adjusted data
CVA.c      = c;                    % contrast weights
CVA.X0     = X0;                   % null space of contrast
 
CVA.V      = V;                    % canonical vectors  (data)
CVA.v      = v;                    % canonical variates (data)
CVA.W      = W;                    % canonical vectors  (design)
CVA.w      = w;                    % canonical variates (design)
CVA.C      = C;                    % canonical contrast (design)

CVA.r      = r;                    % canonical correlations
CVA.chi    = chi;                  % Chi-squared statistics testing D >= i
CVA.df     = df;                   % d.f.
CVA.p      = p;                    % p-values
