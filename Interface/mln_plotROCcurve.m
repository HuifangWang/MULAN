%% function plot ROC
function plotROCcurve(Fpr,Tpr,auc,ha2)
cla(ha2);
rf=[0,1];
%hold on
Fpr=[Fpr;0]; %% put the [0,0] as the beginning point to be drew
Tpr=[Tpr;0];
plot(Fpr,Tpr,'g-','linewidth',2,'parent',ha2);
set(ha2,'NextPlot','add');
plot(rf,rf,'parent',ha2);
%set(get(ha2,'XLabel'),'String','False positive rate ');
%set(get(ha2,'YLabel'),'String','True positive rate');
%title('ROC');
axis(ha2,'tight')
htext=findobj(ha2,'Type','text');
delete(htext);
text(0.4,0.3,num2str(auc),'parent',ha2);
%hold off