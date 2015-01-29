function P=mln_Dir2Partial(M)

%% This function transfers a Matrix M to Partial ones P

nchannel=size(M,1);
M=M-diag(diag(M))+eye(nchannel);
IM=-inv(M);
P=(IM ./ repmat(sqrt(abs(diag(IM))),1,nchannel)) ./ repmat(sqrt(abs(diag(IM)))',nchannel,1)+eye(nchannel);
