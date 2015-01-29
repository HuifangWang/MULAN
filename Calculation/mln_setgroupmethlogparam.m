function [methods_in_group,paramsfields]=setgroupmethlogparam(GroupMethlog)
% set the group methods and param depends on the method Group
% Huifang Wang Dec 14, 2012
% Huifang Wang June 4, 2013
switch GroupMethlog
    case 'TimeBasic'
        methods_in_group={'BCorrU','BCorrD','PCorrU','PCorrD'};
        paramsfields={'wins','overlap','MaxDelay'};
    case 'FreqBasic'
        methods_in_group={'BCohF','BCohW','PCohF','PCohW'};
        paramsfields={'wins','overlap','minfreq','maxfreq','stepfreq'};
    case 'Hsquare'
        methods_in_group={'BH2U','PH2U','BH2D','PH2D'};
        paramsfields={'wins','overlap','MaxDelay','bins'};
    case 'SynchroSNH'
        methods_in_group={'DSynchroS','PSynchroS','DSynchroH','PSynchroH','DSynchroN','PSynchroN'};
        paramsfields={'wins','overlap','NeighborN','modelOrder','PatternN'};
    case 'Granger'
        methods_in_group={'GC','PGC','CondGC'};
        paramsfields={'wins','overlap','modelOrder'};
    case 'FreqAH'
        methods_in_group={'MVAR','Smvar','hmvar','PDC','COH1','COH2',...
            'DTF','DC1','dDTF','ffDTF','pCOH1','pCOH2','AS','oPDCF','GGC','Af','GPDC'};
        paramsfields={'wins','overlap','modelOrder','minfreq','maxfreq','stepfreq'};
    case 'MutualInform'
        methods_in_group={'BMITU','PMITU','BMITD1','PMITD1','BMITD2','PMITD2'};
        paramsfields={'wins','overlap','MaxDelay','bins'};
    case 'PhaseSynch'
        methods_in_group={'DPSPLVH','DPSENTH'};
        paramsfields={'wins','overlap','MaxDelay'};
   case 'TE'
       methods_in_group={'BTEU','BTED','PTEU','PTED'};
       paramsfields={'wins','overlap','MaxDelay'};

end