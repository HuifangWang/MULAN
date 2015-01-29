function mln_showTimeSeriesLFP(lfp,st,wins,scale,Params,a1)

% st: start time
%wins: how large wins to show;
%scale: 

spoint=floor(st*Params.fs)+1;
winspoint=floor(wins*Params.fs);
lfp=lfp(:,spoint:winspoint+spoint);
[nChannel,ttpoint]=size(lfp);
%spacechannel=7;
ylabel=nChannel:-1:1;
if isempty(find(strncmpi(fieldnames(Params),'str',3)==1,1))
YLabels = num2cell(ylabel); 
else
    YLabels=Params.str;
end
lfp=flipud(lfp);
cla(a1,'reset');
%hold on;
      

ttime=(spoint:winspoint+spoint)./Params.fs;

%lfp = detrend(lfp);
  
SeparateBy = scale*(max(lfp(:)) - min(lfp(:)));
plot(a1, ttime, lfp' + SeparateBy*repmat((1:nChannel),[ttpoint,1]));

%set(a1,'ylim',[0 SeparateBy*(nChannel+1)]);
set(a1,'xlim',[st ttime(end)])


set(a1,'YTick',SeparateBy*(1:nChannel));
set(a1,'YTickLabel',fliplr(YLabels));
%set(a1,'Ydir','reverse');
%Y_Limit=get(a1,'YLim');
%plot([t,t],Y_Limit,'color','red','parent',a1);
%hold off