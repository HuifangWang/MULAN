
function mln_CalEvaN(dirname,prenom,strfile,paramsfile,nc,is,npts,cs,models)
% Generate the data, calucate the connection methods by all given methods and evalution the results by AUC.
% dirname: the folder to store all files
% prenom: spectial name for new datasets
% strfile: the file stores the structures
% Paramsfile: the params used in the calucation
% nc: the channels of data
% is: which structure stored in the structure file
% npts: length of data
% cs: the connection strength
% models: 'nmm','fMRI','linear','rossler', 'henon'

%Examples: mln_CalEvaN nmm nmm GenerateData/structureN5L5 nmmParams 5 20 3000 1 nmm
% dirname is the direction name which

% Huifang Wang, Marseille, Nov 25, 2013,  Calculate all
% datasets, Get the AUC
VGroupMethlog={'TimeBasic','FreqBasic','Hsquare','Granger','FreqAH','MutualInform','TE'};

if ~exist(dirname,'dir')
    mkdir(dirname);
end
datadir=[dirname,'/data'];
if ~exist(datadir,'dir')
    mkdir(datadir);
end
Resultsdir=[dirname,'/Results'];
if ~exist(Resultsdir,'dir')
    mkdir(Resultsdir);
end
Resultsdir=[dirname,'/ToutResults'];
if ~exist(Resultsdir,'dir')
    mkdir(Resultsdir);
end
Resultsdir=[dirname,'/AUC'];
if ~exist(Resultsdir,'dir')
    mkdir(Resultsdir);
end

%mln_generateParams(dirname);
if exist([paramsfile,'.mat'],'file')
   strfile1=which([paramsfile,'.mat']); 
    
%strfilethere=['./',dirname,'/',strfile,'.mat'];

copyfile (strfile1, ['./',dirname]);
end

is=str2double(is);
nc=str2double(nc);
npts=str2double(npts);
cs=str2double(cs);
switch models
    case 'nmm'
        dataname=mln_generate_nmm(is,nc,strfile,dirname,prenom,cs,npts);
    case 'fMRI'
        dataname=mln_generate_fMRI(is,nc,strfile,dirname,prenom,cs,npts);
    case 'linear'
        dataname=mln_generate_linear(dirname,prename,npts,strfile,is,cs,1);
    case 'rossler'
        dataname=mln_generate_rossler(dirname,prename,npts,strfile,is,cs,0,0,1);
    case 'henon'
        dataname=mln_generate_henon(dirname,prename,npts,strfile,is,cs,0,0,1);
end

MULANCalMUltiBP(dirname,dataname,paramsfile,VGroupMethlog)
mln_MethodStructuresAUC(dirname,dataname);
