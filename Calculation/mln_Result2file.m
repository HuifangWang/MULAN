%% change the format of results
% Huifang Wang Marseille

function mln_Result2file(dirname,dataprenom,GroupMethlog)
datafile=[dirname,'/data/',dataprenom,'.mat'];
%GroupMethlog={'TimeBasic','FreqBasic','Hsquare','Granger','FreqAH','MutualInform'};
is3dimemsion=[1,0,1,1,0,1,1];
for igroup=1:length(GroupMethlog)
    Resultfile=[dirname,'/Results/',GroupMethlog{igroup},'_',dataprenom];
    is3d=is3dimemsion(igroup);
    iNetSaved=load(Resultfile);
    fieldname=fieldnames(iNetSaved);
    for imethods=1:length(fieldname)
        Methlog=fieldname{imethods};
         if  strncmpi(Methlog,'Standard',8)
            continue;
        end
       
        if is3d
            Mat=iNetSaved.(Methlog).Mat;
        else
            NetCalcd=iNetSaved.(Methlog);
            Mat=squeeze(mean(abs(NetCalcd.Mat),3));
            
        end
        NewStru.(Methlog)=Mat;
      
    end    
    iParams=iNetSaved.(Methlog).Params;
    if igroup==1
        NewStru.Params=iParams;
    else
    NewStru.Params=updateP(NewStru.Params,iParams);
    end
end

load(datafile,'Connectivity');
Connectivity=mln_normalizeNet(Connectivity-diag(diag(Connectivity)));
NewStru.Connectivity=Connectivity;
filesaved=[dirname,'/ToutResults/Tout_',dataprenom];
save(filesaved,'-struct','NewStru')

% delete the files
% for igroup=1:length(GroupMethlog)
%     Resultfile=[dirname,'/Results/',GroupMethlog{igroup},'_',dataprenom,'.mat'];
%     delete(Resultfile);
% end

function NParams=updateP(S1,S2)
fNames1 = fieldnames(S1);
fNames2 = fieldnames(S2);
diff = setdiff(fNames2,fNames1);
NParams=S1;
if isempty(diff)
   return;
else
    numFields = length(diff);

for i=1:numFields

    % get values for each struct for this field
    NParams.(diff{i})=S2.(diff{i});

end

end
    

