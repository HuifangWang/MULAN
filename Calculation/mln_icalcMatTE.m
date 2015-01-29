function Mat=mln_icalcMatTE(lfp,maxlag)
%% this function is used to calculate the Transfer Entropy with time
%% delay
% Nov, 13, Huifang Wang Marseille based on Andrea Brovelli's code

[nchan,lengthx]=size(lfp);
BTED=zeros(nchan,nchan,maxlag);


for tau=1:maxlag; 
   
   ind_tx=[tau+1:lengthx]';
   ind_tx=repmat(ind_tx, [1, tau+1]) - repmat( [0:tau], [lengthx-tau 1]);
    for ichan=1:nchan; 
         for jchan=ichan+1:nchan;
             [BTED(jchan,ichan,tau),BTED(ichan,jchan,tau)]=cal_te_xy(lfp(ichan,:),lfp(jchan,:),ind_tx);   

         end
    end
end
Mat.BTED=max(BTED,[],3);
Mat.BTEU=max(Mat.BTED,Mat.BTED');%% updated Huifang Dec, 13, 2012
Mat.PTED=mln_Dir2Partial(Mat.BTED+eye(size(Mat.BTED)));
Mat.PTEU=mln_Dir2Partial(Mat.BTEU+eye(size(Mat.BTEU)));

%% subfunction
function [texy, teyx]=cal_te_xy(sx,sy,ind_tx)

x=squeeze(sx(1,ind_tx));
y=squeeze(sy(1,ind_tx));
sizetx=size(ind_tx);
x = reshape(x, sizetx);
y = reshape(y, sizetx);


% ---From Andrea Brovelli------------------------------------------------------------------
    % TE( x -> y )
    % ---------------------------------------------------------------------
    % Conditional Entropy Hycy: H(Y_i+1|Y_i) = H(Y_i+1) - H(Y_i)
    det_yi1 = det(cov(y));
    det_yi  = det(cov(y(:,2:end)));
    Hycy = log(det_yi1) - log(det_yi);    
    % Conditional Entropy Hycx: H(Y_i+1|Y_i,Y_i)
    det_yxi1 = det(cov([ y x(:,2:end) ]));
    det_yxi  = det(cov([ y(:,2:end) x(:,2:end) ]));
    Hycx = log(det_yxi1) - log(det_yxi);
    % Transfer Entropy x -> y
    texy = Hycy - Hycx;
    
    % ---------------------------------------------------------------------
    % TE( y -> x )
    % ---------------------------------------------------------------------
    % Conditional Entropy Hxcx: H(X_i+1|X_i) = H(X_i+1) - H(X_i)
    det_xi1 = det(cov(x));
    det_xi  = det(cov(x(:,2:end)));
    Hxcx = log(det_xi1) - log(det_xi);
    % Conditional Entropy Hxcy: H(X_i+1|X_i,Y_i)
    det_xyi1 = det(cov([x y(:,2:end) ]));
    det_xyi  = det(cov([x(:,2:end) y(:,2:end) ]));
    Hxcy = log(det_xyi1) - log(det_xyi);
    % Transfer Entropy y -> x
    teyx = Hxcx - Hxcy;
