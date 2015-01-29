function N=NormalizeMatrixSymmetric(M)

%% this function is to Normalize Symmetric Matrix N=M_ij^2/M_iiM_jj
N=M;
Nchan=size(M,1);
for i=1:Nchan
    for j=i:Nchan
        N(i,j)=abs(M(i,j)^2)/(M(i,i)*M(j,j));
    end
end