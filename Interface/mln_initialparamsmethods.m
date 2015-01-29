function paramsdata=mln_initialparamsmethods(paramsfields)
defwindow='350';
defoverlap='0.5';
defmodelorders='5';
minfreq='1';
maxfreq='40';
stepfreq='0.5';
defbins='16';
defPatternN='10';
defNeighborN='10';
defMaxDelay='12';

param_df=struct('wins',defwindow,...
                 'overlap',defoverlap,...
                 'modelOrder',defmodelorders,...
                 'minfreq',minfreq,'maxfreq',maxfreq,'stepfreq',stepfreq,...
                 'bins',defbins,...
             'NeighborN',defNeighborN,...
                 'PatternN',defPatternN,...
                 'MaxDelay',defMaxDelay);
             
Nparamf=length(paramsfields);
paramsdata=cell(Nparamf,2);
for i=1:Nparamf
    paramsdata{i,1}=paramsfields{i};
    paramsdata{i,2}=param_df.(paramsfields{i});
end
