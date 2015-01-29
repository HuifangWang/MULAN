function Net=mln_tofindNet(Resultfile,Methlog,params,flaguse)
Net=[];
if exist(Resultfile)
NetSaved=load(Resultfile);
oddfieldname=fieldnames(NetSaved);
NMlog=length(Methlog);
if  ~isempty(find(strncmpi(oddfieldname,Methlog,NMlog)==1,1))% if there is results about 'Methlog'
   % try to find the results with the same parameters
   Nmethlog=length(NetSaved.(Methlog));
   
   for i=1:Nmethlog
       if mln_compareparams(NetSaved.(Methlog)(i).Params,params)
           Net=NetSaved.(Methlog)(i);
           switch flaguse
               case 'E'
                   if length(size(Net))>3
                       Net.Mat=squeeze(mean(abs(Net.Mat),3));  
                   end
           end
                   break;
           end
       end
       
   end
   
end
