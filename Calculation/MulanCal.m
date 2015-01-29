
function MulanCal(dirname,dataprenom,calParams,VGroupMethlog)
% Huifang Wang, Marseille, August 18, 2013, Calculate all methods  

datafile=[dirname,'/data/',dataprenom,'.mat'];

data=load(datafile);
Params=data.Params;

%% load the data

if exist(datafile,'file')
        try 
            prevar = load(datafile);
            if isstruct(prevar)
                fileprevar=fieldnames(prevar);
                iLFP=strncmpi(fileprevar,'LFP',3);
                if ~isempty(find(strncmpi(fileprevar,'LFP',1)==1,1))
                    lfp = prevar.(char(fileprevar(iLFP)));
                 
                else
                    errordlg('Which date want to process?')
                end
                 
                if size(lfp,1)>size(lfp,2)
                    lfp=lfp';
                else
                    lfp=lfp;
                end
            
            end            
        catch ME
            errordlg('filename is invalid')
        end
end

 if ~isempty(find(strncmpi(fileprevar,'Params',6)==1,1))
     
                    Params= prevar.Params;
                   
 end

 if ~isempty(find(strncmpi(fileprevar,'Connectivity',12)==1,1))
     
                   ReferenceMatrix= prevar.Connectivity;
                   
 end

%% Calculate the 

%%%% Get parameters
%VGroupMethlog={'TimeBasic','FreqBasic','Hsquare','Granger','FreqAH','MutualInform','TE'};

%%% Define the file to store results
Ngroup=length(VGroupMethlog);
for igroup=1:Ngroup
    GroupMethlog=VGroupMethlog{igroup};
    Resultfile=[dirname,'/Results/',GroupMethlog,'_',dataprenom,'.mat'];
    [Methlogs,paramsfields]=mln_setgroupmethlogparam(GroupMethlog);
    params=initialparamsmethodsGiven(paramsfields,calParams);
    params.fs=Params.fs;
    switch GroupMethlog
        case 'TimeBasic'
            mln_calcMatTimeBasic(Resultfile,Methlogs,lfp,params);
        case 'FreqBasic'
            mln_calcMatFreqBasic(Resultfile,Methlogs,lfp,params);
        case 'Hsquare'
            mln_calcMatH2(Resultfile,Methlogs,lfp,params);
        case 'Granger'
            mln_calcMatGranger(Resultfile,Methlogs,lfp,params);
        case 'FreqAH'
            mln_calcMatMvar(Resultfile,Methlogs,lfp,params);
        case 'MutualInform'
            mln_calcMatMITime(Resultfile,Methlogs,lfp,params);
        case 'TE'
            mln_calcMatTE(Resultfile,Methlogs,lfp,params);
    end
end

function params=initialparamsmethodsGiven(paramsfields,calParams)

param_df=struct('wins',calParams.defwindow,...
                 'overlap',calParams.defoverlap,...
                 'modelOrder',calParams.defmodelorders,...
                 'minfreq',calParams.minfreq,'maxfreq',calParams.maxfreq,'stepfreq',calParams.stepfreq,...
                 'bins',calParams.defbins,...
                 'MaxDelay',calParams.defMaxDelay);
             
Nparamf=length(paramsfields);
paramsdata=cell(Nparamf,2);
for i=1:Nparamf
    paramsdata{i,1}=paramsfields{i};
    paramsdata{i,2}=param_df.(paramsfields{i});
end
params=mln_cell2struct(paramsdata);

function params=mln_cell2struct(cparams)
nparams=size(cparams,1);
for i=1:nparams
    parafiled=char(cparams(i,1));

        params.(parafiled)=str2double(cparams(i,2));
  
end

