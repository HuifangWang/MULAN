function xnM=mln_norm_data(x)
xnM=x;
nchan=size(x,1);
for i=1:nchan
    ix=x(i,:);
mn = mean(ix);
sd = std(ix);
sd(sd==0) = 1;

xn = bsxfun(@minus,ix,mn);
xn = bsxfun(@rdivide,xn,sd);
xnM(i,:)=xn;
end