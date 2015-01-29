function mln_defineStructure()

%% structure 1: Node 6, NL=4; common source

PGS{1}=[1 3 4;2 2 5];
PGS{2}=[2 3 3 4;1 2 3 5];
PGS{3}=[1 3 4 5;2 2 6 6];
PGS{4}=[1 3 3 4 4 5;2 2 3 6 5 6];
PGS{5}=[1 5 4 3 4;2 2 2 2 3];
PGS{6}=[1 5 4 3 4 5;2 2 2 2 3 1];

save('structureSG1.mat','PGS')