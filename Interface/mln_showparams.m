function TextParams=mln_showparams(ParamsStru)
%% this function will make the parmasters can be demostrated by GUI
TextParams='';
if isstruct(ParamsStru)
    params_names=fieldnames(ParamsStru);
    Np=length(params_names);
    for i=1:Np
        iparams=[params_names(i),num2str(ParamsStru.(char((params_names(i)))))];
        TextParams=[TextParams;iparams];
    end
end