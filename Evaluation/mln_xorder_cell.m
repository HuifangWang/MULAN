function indx=mln_xorder_cell(oCells,nCells)
Nindx=length(nCells);
indx=NaN(Nindx,1);
for iindx=1:Nindx
indx(iindx)=find(strcmp(nCells{iindx},oCells));
end