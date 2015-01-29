function dataname=mln_generate_fMRI(is,nc,strfile,dirname,prename,cs,T)

% Huifang from 
% Karl Friston
% $Id: DEM_demo_large_fMRI.m 5691 2013-10-11 16:53:00Z karl $


dataname=[prename,'fmriCS',num2str(100*cs),'S',num2str(is),'N',num2str(T)];
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
% Simulate timeseries
%==========================================================================
%rng('default')

% DEM Structure: create random inputs
% -------------------------------------------------------------------------
%Nc  = 8;                               % number of runs
%T  = 512;                             % number of observations (scans)
TR = 2;                               % repetition time or timing
n  = nc;                               % number of regions or nodes
t  = (1:T)*TR;                        % observation times

% priors
% -------------------------------------------------------------------------
options.nmax       = 8;               % effective number of notes

options.nonlinear  = 0;
options.two_state  = 0;
options.stochastic = 0;
options.centre     = 1;
options.induced    = 1;

A   = ones(n,n);
B   = zeros(n,n,0);
C   = zeros(n,n);
D   = zeros(n,n,0);
pP  = spm_dcm_fmri_priors(A,B,C,D,options);

load(strfile,'PGS');

%==========================================================================

Astru=PGS{is};
SparseA=sparse(Astru(1,:),Astru(2,:),1);
P.A=full(SparseA);
P.A(nc,nc)=0;
pP.A=P.A.*cs/8; 
 
% true parameters (reciprocal connectivity)
% -------------------------------------------------------------------------
%pP.A = randn(n,n)/8;
pP.A = pP.A - diag(diag(pP.A));
pP.C = eye(n,n);
pP.transit = randn(n,1)/16;

% simulate response to endogenous fluctuations
%==========================================================================

% integrate states
% -------------------------------------------------------------------------
U.u  = spm_rand_mar(T,n,1/2)/2;      % endogenous fluctuations
U.dt = TR;
M.f  = 'spm_fx_fmri';
M.x  = sparse(n,5);
x    = spm_int_J(pP,M,U);

% haemodynamic observer
% -------------------------------------------------------------------------
for i = 1:T
    y(i,:) = spm_gx_fmri(spm_unvec(x(i,:),M.x),[],pP)';
end

% observation noise process
% -------------------------------------------------------------------------
%e    = spm_rand_mar(T,n,1/2)/8;

LFP=y';
Params.fs=1/TR;
Connectivity=pP.A;
%Connectivity(Connectivity<0)=0;
 save(filename,'LFP','Connectivity','Params');
 msgbox('Data Generated','Success','custom',cdata);

 end