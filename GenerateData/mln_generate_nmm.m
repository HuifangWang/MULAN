% Huifang Wang For nmm Structure cluster Version
% related to the structures and pink noise
% Karl Friston
% $Id: spm_csd_demo.m 4402 2011-07-21 12:37:24Z karl $
 function dataname=mln_generate_nmm(is,nc,strfile,dirname,prename,cs,N) 
  
 dataname=[prename,'nmmCS',num2str(100*cs),'S',num2str(is),'N',num2str(N)];
 filename=['./',dirname,'/data/',dataname,'.mat'];
 [cdata] = imread('MULANLOGO.png'); 
 if exist(filename,'file')
     
     msgbox('Data already there','Success','custom',cdata);
 else
     if ~exist(dirname,'dir')
         mkdir(dirname);
     end
     datadir=[dirname,'/data'];
     if ~exist(datadir,'dir')
         mkdir(datadir);
     end

% number of sources and LFP channels (usually the same)
%--------------------------------------------------------------------------
n     = nc; % number of sources
% CS=1;
% specify network (connections)
%--------------------------------------------------------------------------
A{1}=zeros(n); %A{1}  = tril(ones(n,n),-1);                % a forward connection
A{2}  = zeros(n);%triu(ones(n,n),+1);                % a backward connection
A{3}  = sparse(n,n);                       % lateral connections
B     = {};                                % trial-specific modulation
C     = speye(n,n);                        % sources receiving innovations
 
% get priors
%--------------------------------------------------------------------------
[pE,pC] = spm_lfp_priors(A,B,C);           % neuronal priors
[pE,pC] = spm_ssr_priors(pE,pC);           % spectral priors
[pE,pC] = spm_L_priors(n,pE,pC);           % spatial  priors
 
% create LFP model
%--------------------------------------------------------------------------
M.IS  = 'spm_lfp_mtf';
M.FS  = 'spm_lfp_sqrt';
M.f   = 'spm_fx_lfp';
M.g   = 'spm_gx_erp';
M.x   = sparse(n,13);
M.n   = n*13;
M.pE  = pE;
M.pC  = pC;
M.m   = n;
M.l   = nc;
M.Hz  = [1:64]';
 
 

% or generate data
%==========================================================================
 
% Integrate with pink noise process
%--------------------------------------------------------------------------

U.dt = 8/1000;
U.u  = randn(N,M.m)/100;
%U.u=zeros(N,M.m)/16;
U.u  = sqrt(spm_Q(1/16,N))*U.u;

load(strfile,'PGS');
%===============================================================
P           = pE;
Astru=PGS{is};
SparseA=sparse(Astru(1,:),Astru(2,:),1);
P.A{1}=full(SparseA);
P.A{1}(nc,nc)=0;
P.A{1}=P.A{1}.*cs; 


LFP  = spm_int_L(P,M,U);
LFP=LFP';
Params.fs=1000/8;
Connectivity=P.A{1};
Connectivity(Connectivity<0)=0;

 save(filename,'LFP','Connectivity','Params');
 msgbox('Data Generated','Success','custom',cdata);

 end

