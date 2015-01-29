function MULANCalMUltiBP(dirname,prenom,paramsfile,VGroupMethlog)
% Huifang Wang, Marseille, August 26, 2013, Calculate all datasets with
% basic prenom
paramsfile=[dirname,'/',paramsfile];
load(paramsfile,'calParams')

MulanCal(dirname,prenom,calParams,VGroupMethlog);
mln_Result2file(dirname,prenom,VGroupMethlog)

