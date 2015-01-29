function params=mln_cell2struct(cparams)
nparams=size(cparams,1);
for i=1:nparams
    parafiled=char(cparams{i,1});

    params.(parafiled)=cparams{i,2};
end