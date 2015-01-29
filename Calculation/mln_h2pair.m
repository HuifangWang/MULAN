function xyh2=mln_h2pair(x,y,tou,bins)
Nt=length(x);
%% update x y pair with delay tou
x=x(1:Nt-tou);
y=y(1+tou:Nt);

Maxx=max(x);
Minx=min(x);
stepx=(Maxx-Minx)/bins;
xbin=Minx:stepx:Maxx;
%% define xbar and ybar
xbar=zeros(1,bins);
ybar=xbar;
sxy=zeros(1,bins-1);
for ibins=1:bins
    ibinx=find(xbin(ibins)<= x & x <=xbin(ibins+1));
    if isempty(ibinx)
        xbar(ibins)=xbar(ibins-1)+stepx;
        ybar(ibins)=ybar(ibins-1);
    else
        xbar(ibins)=mean(x(ibinx));
        ybar(ibins)=mean(y(ibinx));
    end
end

for ibins=1:bins-1
    sxy(ibins)=(ybar(ibins+1)-ybar(ibins))/(xbar(ibins+1)-xbar(ibins));
end
%%% compute the yh=h(x)
yh=zeros(size(x));
for i=1:Nt-tou
    indexbin=find(xbar>x(i),1);
    
    if isempty(indexbin) 
        indexbin=bins-1;
    end
    
    if indexbin==bins 
        indexbin=bins-1;
    end
    if indexbin==1
        indexbin_1=1;
    else
        indexbin_1=indexbin-1;
    end
    yh(i)=sxy(indexbin_1)*(x(i)-xbar(indexbin_1))+ybar(indexbin_1);
end

yyh = bsxfun(@minus, y, yh);
varyyh = var(yyh);
vary=var(y);
xyh2=1-varyyh/vary;
