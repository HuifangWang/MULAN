function Mat=icalcMatGranger(lfp,modelOrder)
[nchan,~]=size(lfp);
STATFLAG=0;
%Nr=1;

ret = cca_partialgc(lfp,modelOrder,STATFLAG);
%ret= cca_granger_regress(lfp,modelOrder,STATFLAG);
Mat.GC=ret.gc;
Mat.PGC=mln_Dir2Partial(Mat.GC+eye(nchan));
Mat.CondGC=ret.fg;

%Mat.SGCausal=pwcausal(lfp,Nr,Nl,modelOrder,fs,freq);
