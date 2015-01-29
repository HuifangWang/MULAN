function updateResultMulti(Resultfile,netMatrix)
% Update file Resultfile
%% Huifang Wang Apr.10, 2012, Marseille

prevar=load(Resultfile);
if isstruct(prevar)
    Rconnect=prevar;
    if isstruct(netMatrix)
        Methlogs=fieldnames(netMatrix);
        Nmeth=length(Methlogs);
        for i=1:Nmeth
            iMethlogs=char(Methlogs(i));
            Rconnect.(iMethlogs)=netMatrix.(iMethlogs); 
            save(Resultfile,'-struct','Rconnect');
        end
    end
end