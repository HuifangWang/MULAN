function issym=mln_issymetricM(method)
SymmetricM={'BCorrU', 'PCorrU' , 'BCohF' ,   'BCohW' ,   'PCohF' ,   'PCohW'    'BH2U'    'PH2U',...
    'Smvar' ,   'COH1' ,   'COH2' ,  'pCOH1' ,   'pCOH2' ,     'BMITU',   'PMITU'};

xf=find(strcmp(method,SymmetricM));
if isempty(xf)
    issym=0;
else
    issym=1;
end
    