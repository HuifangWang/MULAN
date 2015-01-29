function mln_statesplot(lfp,Params,delay)
Nchan=size(lfp,1);
%% if Number of channels is larger than 6, we divided the figures with each
%% one less or equals 6x6
NumberChanforPage=6;
Npage=(floor(Nchan/NumberChanforPage)+1);
if isempty(find(strncmpi(fieldnames(Params),'str',3)==1,1));
    str=1:Nchan;
else
str=Params.str;
end
if Nchan>NumberChanforPage
    for ipage=1:Npage
        if ipage==Npage
            ichanV=(ipage-1)*NumberChanforPage+1:Nchan;
            
        else
            ichanV=(ipage-1)*NumberChanforPage+1:ipage*NumberChanforPage;
        end
        istr=str(ichanV);
        for jpage=1:Npage
            hf=figure('name',['States plot for ', num2str(delay), ' time delay in Page ',num2str(ipage), ' , ',num2str(jpage)]);
            
            if jpage==Npage
                jchanV=(jpage-1)*NumberChanforPage+1:Nchan;
            else
                jchanV=(jpage-1)*NumberChanforPage+1:jpage*NumberChanforPage;
            end
            jstr=str(jchanV);
            plotstatesplot(hf,ichanV,jchanV,istr,jstr,lfp,delay)
        end
    end
else
    hf=figure('name',['States plot for ', num2str(delay), 'time delay ']);
    istr=str;
    jstr=str;
    ichanV=1:Nchan;
    plotstatesplot(hf,ichanV,ichanV,istr,jstr,lfp,delay)
    
end


%for idelay=0:NSP
function plotstatesplot(hf,ichanV,jchanV,istr,jstr,lfp,idelay)
Nchan=max(length(ichanV),length(jchanV));
for i=1:length(ichanV)
    ilfp=lfp(ichanV(i),idelay+1:end);
    for j=1:length(jchanV)
        
        jlfp=lfp(jchanV(j),1:end-idelay);
        subplot(Nchan,Nchan,(i-1)*Nchan+j,'parent',hf);
        plot(ilfp,jlfp,'b.');
        axis equal;
        if i==1
            if isempty(jstr)
            title(['C',num2str(jchanV(j))]);
            else
                title(jstr(j));
            end
        end
        if j==1
            if isempty(istr)
            ylabel(['C',num2str(ichanV(i))]);
            else
             ylabel(istr(i));
            end
        end
    end
end
%end




