function varargout = GUIevaluationROC2(varargin)
% GUIEVALUATIONROC2 M-file for GUIevaluationROC2.fig
%      GUIEVALUATIONROC2, by itself, creates a new GUIEVALUATIONROC2 or raises the existing
%      singleton*.
%
%      H = GUIEVALUATIONROC2 returns the handle to a new GUIEVALUATIONROC2 or the handle to
%      the existing singleton*.
%
%      GUIEVALUATIONROC2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIEVALUATIONROC2.M with the given input arguments.
%
%      GUIEVALUATIONROC2('Property','Value',...) creates a new GUIEVALUATIONROC2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIevaluationROC2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIevaluationROC2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIevaluationROC2
% Huifang Wang 
% Last Modified by GUIDE v2.5 27-Sep-2012 15:08:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIevaluationROC2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIevaluationROC2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIevaluationROC2 is made visible.
function GUIevaluationROC2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIevaluationROC2 (see VARARGIN)


% UIWAIT makes GUIevaluationROC2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

varinput=varargin{1};

multiNet=abs(varinput.Net);
Standard_Net=abs(varinput.ReferenceNet);
%handles.lfp=varinput.lfp;
handles.Resultfile=varinput.Resultfile;
handles.Methlog=varinput.Methlog;
handles.issymetricM=mln_issymetricM(handles.Methlog);
set(handles.datafilename,'String',varinput.Resultfile);
set(handles.methodlog,'String',varinput.Methlog);
param_to_show=mln_showparams(varinput.Params);
set(handles.Parametershow,'Data',param_to_show);
Params=varinput.Params;

axes(handles.Logo);
imshow('MULANLOGO.png');
 %% size(multiNet)=(Nchan,Nchan,nf,nw)
 
A1_Net=mean(squeeze(mean(multiNet,3)),3);

%% Normalized data
Standard_Net=Standard_Net-diag(diag(Standard_Net));
Norm_Standard=mln_normalizeNet(Standard_Net);

A1_Net=A1_Net-diag(diag(A1_Net));
Norm_A1_Net=mln_normalizeNet(A1_Net);

%mln_showNetworkGraph(abs(Norm_Standard),handles.graphStrandard,thresholdr,Params);

%% Show reference Matrix
mln_showConnectionMatrix(Norm_Standard,handles.MatrixStrandard,0,Params);
absNorm_Standard=abs(Norm_Standard);
thresholdr=min(absNorm_Standard(absNorm_Standard>0));
mln_showNetworkGraph(abs(Norm_Standard),handles.graphStrandard,thresholdr,Params);

%% Plot average values 1
[ih,f0,f1,Fpr,Tpr,Fnr,pFDR,t,auc1,flagFasleRate,th_roc1]=mln_calc_FalseRate(Norm_A1_Net,Norm_Standard,handles.issymetricM,0);

mln_showConnectionMatrix(Norm_A1_Net,handles.A1Matrix,0,Params);

if flagFasleRate
plot(ih,f0,'b-',ih,f1,'r--','linewidth',2,'parent',handles.A1H1h0);
legend(handles.A1H1h0,'H0','H1',2);
%mln_plotROCcurve(Fpr,Tpr,auc,handles.A1ROC);



% draw another ROC
[~,~,~,Fpr2,Tpr2,~,~,t,auc2, ~,th_roc2]=mln_calc_FalseRate(Norm_A1_Net,Norm_Standard,handles.issymetricM,1);

%mln_plotROCcurve(Fpr,Fpr2,Tpr,Tpr2,[auc1, auc2],[th_roc1;th_roc2],handles.A1ROC);
plotROCcurve(Fpr,Tpr,auc1,th_roc1,Fpr2,Tpr2,auc2,th_roc2,handles.A1ROC)
% show structure of Graph from ROC
absA1=abs(Norm_A1_Net);
thresholdROC=th_roc2(1);
mln_showNetworkGraph(absA1,handles.A3Graph,thresholdROC,Params);

plot(t,pFDR,'m-','Linewidth',2,'parent',handles.A1FDR);
% find the threshold to 
infsmall=1e-6;
threshold=min(t(find(pFDR<infsmall,1)));
handles.threshold4pFDR=threshold;
htext=findobj(handles.A1FDR,'Type','text');

delete(htext);
% show structures
if ~isempty(threshold) 
 text(0.4,0.3,num2str(threshold),'parent',handles.A1FDR);
 mln_showNetworkGraph(Norm_A1_Net,handles.A1Graph,threshold,Params);
else
absA1=abs(Norm_A1_Net);
threshold1=min(absA1(absA1>0)); 
mln_showNetworkGraph(absA1,handles.A1Graph,threshold1,Params);
end
end


%%
% Choose default command line output for GUIevaluationROC2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = GUIevaluationROC2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function datafilename_Callback(hObject, eventdata, handles)
% hObject    handle to datafilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datafilename as text
%        str2double(get(hObject,'String')) returns contents of datafilename as a double


% --- Executes during object creation, after setting all properties.
function datafilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datafilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function methodlog_Callback(hObject, eventdata, handles)
% hObject    handle to methodlog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of methodlog as text
%        str2double(get(hObject,'String')) returns contents of methodlog as a double


% --- Executes during object creation, after setting all properties.
function methodlog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodlog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% function plot ROC
function plotROCcurve(Fpr1,Tpr1,auc1,th1,Fpr2,Tpr2,auc2,th2,ha2)
cla(ha2);
rf=[0,1];
%hold on
Fpr1=[Fpr1;0]; %% put the [0,0] as the beginning point to be drew
Tpr1=[Tpr1;0];
Fpr2=[Fpr2;0]; %% put the [0,0] as the beginning point to be drew
Tpr2=[Tpr2;0];
set(ha2,'NextPlot','add');
plot(Fpr2,Tpr2,'g-','linewidth',4,'parent',ha2);
plot(Fpr1,Tpr1,'b-','linewidth',2,'parent',ha2);

plot(rf,rf,'k-.','parent',ha2);
plot(th2(2),th2(3),'p','MarkerEdgeColor','m',...%[0.47,0.06,0.9]
                'MarkerFaceColor','m',...
                'MarkerSize',8,'parent',ha2);
            plot(th1(2),th1(3),'*','MarkerEdgeColor',[0.47,0.06,0.9],...
                'MarkerFaceColor','m',...
                'MarkerSize',8,'parent',ha2);
%set(get(ha2,'XLabel'),'String','False positive rate ');
%set(get(ha2,'YLabel'),'String','True positive rate');
%title('ROC');
%axis([-0.01,1,0,1.01])
htext=findobj(ha2,'Type','text');
delete(htext);
text(0.4,0.1,num2str(auc1),'Color','b','parent',ha2);
text(0.4,0.3,num2str(auc2),'Color',[0,127/225,0],'parent',ha2);
%hold off
