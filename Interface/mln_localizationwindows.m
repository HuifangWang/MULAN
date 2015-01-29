function iw=mln_localizationwindows(ts,params,fs)
% this function is to find the corresponding window to the given time t
ps=ts*fs;
overlap_p=params.wins*params.overlap;
iw=floor((ps-overlap_p)/(params.wins-overlap_p))+1;
if iw<=0
    iw=1;
end

