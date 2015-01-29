% Huifang Wang, Sep. 26, 2013
% Huifang Wang, Nov. 26, 2013 update Method Structure AUC for mlnI
function flg=mln_MethodStructuresAUC(dirname,prenom)

flg=0; % flg for the error


filename=['./',dirname,'/ToutResults/Tout_',prenom,'.mat'];

calresult=load(filename);
fieldname=fieldnames(calresult);
% remove params and connectivity
fieldname(strcmp('Params',fieldname))=[];

fieldname(strcmp('Connectivity',fieldname))=[];
%%
%idx=find(strcmp('pCOH1',fieldname));
%fieldname(idx)=[];
%%
Nmethod=length(fieldname);
Meths.MSAUC=zeros(Nmethod,1);
Meths.Mth=zeros(Nmethod,1);
filesaved=['AUC_',prenom,'.mat'];

Meths.Methodnames=fieldname;

Meths.Connectivity=calresult.Connectivity;
    
        for imethod=1:Nmethod
            Methods=fieldname{imethod};
            Mat=calresult.(Methods);
            if isnan(max(Mat))
                
                auc=0;
                chis=1;
                iMat=NaN(size(Mat,1));
                
            else
            iMat=mean(abs(Mat),3);
            iMat=iMat-diag(diag(iMat));
            [~,~,~,~,~,~,~,~,auc,~,thresh3] =mln_calc_FalseRate(iMat,calresult.Connectivity,mln_issymetricM(Methods),1);
            chis=mln_chis(Mat,thresh3(1));
            end
            Meths.MSAUC(imethod,1)=auc;
            
            if isempty(chis)
                pause
            end
            Meths.Mth(imethod,1)=chis;
            Meths.Mat(:,:,imethod)=iMat;
        end


save(['./',dirname,'/AUC/',filesaved],'Meths');
