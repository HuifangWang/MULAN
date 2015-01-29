function updateResult(Resultfile,Net,params)
% update the Resultfile with adding net with structure name Methlog
%%% Huifang Wang Apr.10, 2012, Marseille
%%% Huifang Wang June 20, update for save multi methods at the same time in
%%% order to save saving time
[cdata] = imread('MULANLOGO.png'); 
VMethodlog=fieldnames(Net);
Nmethod=length(VMethodlog);
if ~exist(Resultfile,'file')
    for j=1:Nmethod
        Methlog=char(VMethodlog(j));
        Rconnect.(Methlog)(1).Mat=Net.(Methlog);
        if ~isempty(params)
        Rconnect.(Methlog)(1).Params=params;
        end
    end
else
    %Net.Params=params;
    prevar=load(Resultfile);
    if isstruct(prevar)
        Rconnect=prevar;
        
        for j=1:Nmethod
            Methlog=char(VMethodlog(j));
            NMlog=length(Methlog);
            oldfieldname=fieldnames(Rconnect);
            if isempty(find(strncmpi(oldfieldname,Methlog,NMlog)==1,1))
                Rconnect.(Methlog)(1).Mat=Net.(Methlog);
                if ~isempty(params)
                Rconnect.(Methlog)(1).Params=params;
                end
            else
                Rconnect.(Methlog)(end+1).Mat=Net.(Methlog);
                if ~isempty(params)
                Rconnect.(Methlog)(end).Params=params;
                end
                
            end
        end
        
    end
    
end


msgbox('Calculation completed','Success','custom',cdata);
save(Resultfile,'-struct','Rconnect');