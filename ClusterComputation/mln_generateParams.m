function mln_generateParams()

calParams.defwindow='150';
calParams.defoverlap='0.5';
calParams.defmodelorders='5';
calParams.minfreq='1';
calParams.maxfreq='30';
calParams.stepfreq='0.5';
calParams.defbins='16';
calParams.defMaxDelay='5';

save('nmmParams.mat','calParams');