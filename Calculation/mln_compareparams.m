function issame=mln_compareparams(oldparams,newparams)
%% compare two sets of parameters
%fieldold=fieldnames(oldparams);
% Huifang Wang Marseille, Nov, 12
% Huifang Wang, update 13 Feb. 14
fieldnew=fieldnames(newparams);
Nfield=length(fieldnew);
issame=0;
for i=1:Nfield
    ifield=fieldnew{i};
    p1=oldparams.(ifield);
    p2=newparams.(ifield);
    if ischar(p1)
        p1=str2double(p1);
    end
    if ischar(p2)
        p2=str2double(p2);
    end
    if p1==p2;
        issame=1;
    else
        issame=0;
        return;
    end
end
