function showConnectionMatrix(net,ha,fbar,Params)
% Huifang Wang, sep. 6, + set color bar after delete the diagonal 
nchan=size(net,1);
if ~isempty(find(strncmpi(fieldnames(Params),'str',3)==1,1))
    nodenames=Params.str;
else
    nodenames=num2cell(1:nchan);
end


cla(ha)
axis equal;

hold all;
if isempty(net)
    return;
end
net=net-diag(diag(net));
imagesc(net,'parent',ha);
axis tight;
set(ha,'Ydir','reverse');
maxClim=max(max(abs(net)));
minClim=-maxClim;
colormap(ha,jet);
set(ha,'CLim',[minClim maxClim]);
if fbar
colorbar('peer',ha,'CLim',[minClim maxClim]);
end
if ~isempty(nodenames)
set(ha,'YTick',1:nchan,'YTickLabel',nodenames);
set(ha,'XTick',1:nchan,'XTickLabel',nodenames);
end