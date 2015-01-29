function MULANCalMUltiBP_Oct(dirname,prenom,idata,paramsfile)
% Huifang Wang, Marseille, August 26, 2013, Calculate all datasets with
% basic prenom
idata=str2double(idata);
paramsfile=[dirname,'/',paramsfile];
load(paramsfile,'calParams')

mkdir([dirname,'/Results']);
mkdir([dirname,'/ToutResults']);
VGroupMethlog={'TimeBasic','FreqBasic','Hsquare','Granger','FreqAH','MutualInform','TE'};

dataprenom=[prenom,num2str(idata)];
MulanCal(dirname,dataprenom,calParams,VGroupMethlog);
mln_Result2file(dirname,dataprenom,VGroupMethlog);

