function [cross, coh]=getcc(cfs1,cfs2,varargin)
%%%% get the cross spectrum and coherence from 

nbIN = nargin;

% Parameters for Smoothing (Width of Windows).
flag_SMOOTH = true;
NSW = [];
NTW = [];

% Number of arrows and flag for plots.


if nbIN>2
    nbIN = nbIN-2;
    k = 1;
    while k<=nbIN
        argNAM = varargin{k};
        if k<nbIN
            argVAL = varargin{k+1};
        else
            argVAL = [];
        end
        switch upper(argNAM(1:3))
            case 'NTW' , NTW = argVAL;
            case 'NSW' , NSW = argVAL;
             
        end
        k = k+2;
    end
end
if ~isempty(NSW) && isequal(fix(NSW),NSW) && (NSW>0)
    flag_SMOOTH = true;
end
if ~isempty(NTW) && isequal(fix(NTW),NTW) && (NTW>0)
    flag_SMOOTH = true;
else
    NTW = min([round(0.05*length(s1)),20]);
end

cfs_s10   = cfs1;
cfs_s1    = smoothCFS(abs(cfs_s10).^2,flag_SMOOTH,NSW,NTW);
cfs_s1    = sqrt(cfs_s1);
cfs_s2    = cfs2;
cfs_s20   = cfs_s2;
cfs_s2    = smoothCFS(abs(cfs_s20).^2,flag_SMOOTH,NSW,NTW);
cfs_s2    = sqrt(cfs_s2);
cross = conj(cfs_s10).*cfs_s20;
cross = smoothCFS(cross,flag_SMOOTH,NSW,NTW);
coh= cross./(cfs_s1.*cfs_s2);

function CFS = smoothCFS(CFS,flag_SMOOTH,NSW,NTW)

if ~flag_SMOOTH , return; end
if ~isempty(NTW)
    len = NTW;
    F   = ones(1,len)/len;
    CFS = conv2(CFS,F,'same');
end
if ~isempty(NSW)
    len = NSW;
    F   = ones(1,len)/len;    
    CFS = conv2(CFS,F','same');
end
%---