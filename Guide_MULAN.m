function varargout = Guide_MULAN(varargin)
% Guide_MULAN MATLAB code for Guide_MULAN.fig
%      Guide_MULAN, by itself, creates a new Guide_MULAN or raises the existing
%      singleton*.
%
%      H = Guide_MULAN returns the handle to a new Guide_MULAN or the handle to
%      the existing singleton*.
%
%      Guide_MULAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Guide_MULAN.M with the given input arguments.
%
%      Guide_MULAN('Property','Value',...) creates a new Guide_MULAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Guide_MULAN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Guide_MULAN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Guide_MULAN
% Huifang Wang Marseille, July,5,2012
% Last Modified by GUIDE v2.5 13-Feb-2014 23:13:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Guide_MULAN_OpeningFcn, ...
                   'gui_OutputFcn',  @Guide_MULAN_OutputFcn, ...
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


% --- Executes just before Guide_MULAN is made visible.
function Guide_MULAN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Guide_MULAN (see VARARGIN)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
path=cd;
addpath(genpath(path));
savepath;
axes(handles.Logo);
imshow('MULANLOGO.png');
handles.VGroupMethlog={'TimeBasic','FreqBasic','Hsquare','Granger','FreqAH','MutualInform','TE'};
set(handles.MethodGroup,'String',handles.VGroupMethlog);
if isempty(varargin)
set(handles.dirfolder,'String','Examples')    
set(handles.loadfile,'String','ExnmmCS100S20N3000.mat');
Loaddata_Callback(hObject, eventdata, handles);
set(handles.MethodGroup,'Value',4);
MethodGroup_Callback(hObject, eventdata, handles);
else
    
varinput=varargin{1};
handles.datafile=varinput.datafile;
set(handles.loadfile,'String',handles.datafile);
lfpdata=load(handles.datafile);
handles.Params= lfpdata.Params;
handles.Resultfile=varinput.Resultfile;


handles.setMethod=varinput.Method;
handles.setMethodGroup=varinput.GroupMethlog;

guidata(hObject, handles);

results=load(handles.Resultfile);
Paramsdata=results.(varinput.Method).Params;
param_to_show=showparams(Paramsdata);
set(handles.Parameterset,'Data',param_to_show);

set(handles.WindowsLength,'String',num2str(varinput.Winlength));

 IndexC = strfind(handles.VGroupMethlog, handles.setMethodGroup);
    iMethodGroup = find(not(cellfun('isempty', IndexC)));
    set(handles.MethodGroup,'Value',iMethodGroup);
    
    [methods_in_group,paramsfields]=setgroupmethlogparam(handles.setMethodGroup);
    set(handles.methods,'String',methods_in_group);
    IndexC = strfind(methods_in_group, handles.setMethod);
    iMethod= find(not(cellfun('isempty', IndexC)));
    Nmethod=length(iMethod);
    if Nmethod>1
        for iindex=1:Nmethod
            indexMethod=iMethod(iindex);
            if strcmp(methods_in_group(indexMethod),handles.setMethod);
                iMethod=indexMethod;
                break;
            end
        end
    end
    set(handles.methods,'Value',iMethod);
    
set(handles.thresholdNG,'String',num2str(varinput.threshold));
AverageDemost_Callback(hObject, eventdata, handles);


Loaddata_Callback(hObject, eventdata, handles);

end
% Choose default command line output for GUIDynamics
handles.output = hObject;
% UIWAIT makes Guide_MULAN wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Guide_MULAN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Loaddata.
function Loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to Loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strfiledate = get(handles.loadfile,'String');

try exist(strfiledate,'file')
        
            prevar = load(strfiledate);
            if isstruct(prevar)
                fileprevar=fieldnames(prevar);
                iLFP=strncmpi(fileprevar,'LFP',3);
                if ~isempty(find(strncmpi(fileprevar,'LFP',1)==1,1))
                    lfp = prevar.(char(fileprevar(iLFP)));
                 
                else
                    errordlg('Which date want to process?')
                end
                
                 
                if size(lfp,1)>size(lfp,2)
                    handles.lfp=lfp';
                else
                    handles.lfp=lfp;
                end
            
            end 
            
             if ~isempty(find(strncmpi(fileprevar,'Params',6)==1,1))
     
                    handles.Params= prevar.Params;
                   
 end

 if ~isempty(find(strncmpi(fileprevar,'Connectivity',12)==1,1))
     
                    handles.ReferenceMatrix= prevar.Connectivity;
                   
end
        catch ME
            errordlg('filename is invalid')
end

mln_showConnectionMatrix(handles.ReferenceMatrix,handles.connectionMatrix,1,handles.Params);
mln_showNetworkGraph(handles.ReferenceMatrix,handles.NetworkGraph,min(min(handles.ReferenceMatrix)),handles.Params);


%handles.fs=100;
handles.datafile=strfiledate;

guidata(hObject,handles);

% set(handles.Timeslider, 'Enable', 'on');
% timeRes=handles.params.timeRes;
% slidestep=handles.params.slidestep;
% set(handles.Timeslider, 'Max', handles.params.TotalTime-timeRes, ...
%     'Min', timeRes, 'SliderStep',[slidestep 5*slidestep], 'Value', timeRes);
% 
% Show_current_time=get(handles.Timeslider,'Value');

% windowSize=handles.params.TotalTime;
%Nnodes=size(net,1);
totalTimeLFP=num2str(length(handles.lfp)/handles.Params.fs);
set(handles.totalTime,'String',totalTimeLFP);
scales=str2double(get(handles.scalesSingnals,'String'));
st=str2double(get(handles.timeinstant,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);


function loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of loadfile as text
%        str2double(get(hObject,'String')) returns contents of loadfile as a double


% --- Executes during object creation, after setting all properties.
function loadfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in demostration.
function demostration_Callback(hObject, eventdata, handles)
% hObject    handle to demostration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% from the Method group to find the resultfile
iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});

cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
params=mln_struct_str2num(params);
params.fs=handles.Params.fs;
%%% Define the file to store results
dirname=get(handles.dirfolder,'String');

datadir=[dirname,'/Results'];
 Resultfile=[datadir,'/',GroupMethlog,'_',handles.datafile];
     
iMethlog=get(handles.methods,'Value');
VMethlog=get(handles.methods,'String');
Methlog=char(VMethlog{iMethlog});

handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'E');
st=str2double(get(handles.timeinstant,'String'));
%wl=str2double(get(handles.WindowsLength,'String'));
iw=mln_localizationwindows(st,params,handles.Params.fs);
wl=params.wins/handles.Params.fs;
set(handles.WindowsLength,'String',num2str(wl));
net=handles.NetCalcd.Mat(:,:,iw);
net=mln_normalizeNet(net-diag(diag(net)));
thresholdnw=str2double(get(handles.thresholdNG,'String'));
mln_showConnectionMatrix(net,handles.connectionMatrix,1,handles.Params);
mln_showNetworkGraph(net,handles.NetworkGraph,thresholdnw,handles.Params);
scales=str2double(get(handles.scalesSingnals,'String'));
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);

guidata(hObject,handles);

% --- Executes on selection change in MethodGroup.
function MethodGroup_Callback(hObject, eventdata, handles)
% hObject    handle to MethodGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MethodGroup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MethodGroup


iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});

handles.Resultfile=[get(handles.dirfolder,'String'),'/Results/',GroupMethlog,'_',get(handles.loadfile,'String')];


[methods_in_group,paramsfields]=mln_setgroupmethlogparam(GroupMethlog);
set(handles.methods,'Value',1);
set(handles.methods,'String',methods_in_group);

methodlog=get(handles.methods,'String');
if exist(handles.Resultfile,'file')
% set the parameters according to the results obtained 
results=load(handles.Resultfile);
Paramsdata=results.(methodlog{1}).Params;
param_to_show=mln_showparams(Paramsdata);
set(handles.Parameterset,'Data',param_to_show);
else


Paramsdata=mln_initialparamsmethods(paramsfields);
set(handles.Parameterset,'Data',Paramsdata);
end

% --- Executes during object creation, after setting all properties.
function MethodGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MethodGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
params=mln_struct_str2num(params);
params.fs=handles.Params.fs;
Methlogs=get(handles.methods,'String');
%%% Define the file to store results
dirname=get(handles.dirfolder,'String');

    datadir=[dirname,'/Results'];
     if ~exist(datadir,'dir')
         mkdir(datadir);
     end
     Resultfile=[datadir,'/',GroupMethlog,'_',handles.datafile];
     
     if ~iscalcualted(Resultfile,params)
          

switch GroupMethlog
    case 'TimeBasic'
        mln_calcMatTimeBasic(Resultfile,Methlogs,handles.lfp,params);
    case 'FreqBasic'
        mln_calcMatFreqBasic(Resultfile,Methlogs,handles.lfp,params);
    case 'Hsquare'
        mln_calcMatH2(Resultfile,Methlogs,handles.lfp,params);
    case 'SynchroSNH'
        mln_calcMatSynchroSNH(Resultfile,Methlogs,handles.lfp,params);
    case 'Granger'
        mln_calcMatGranger(Resultfile,Methlogs,handles.lfp,params);
    case 'FreqAH'
        mln_calcMatMvar(Resultfile,Methlogs,handles.lfp,params);
    case 'MutualInform'
        mln_calcMatMITime(Resultfile,Methlogs,handles.lfp,params);
    case 'PhaseSynch'
        mln_calcMatPS(Resultfile,Methlogs,handles.lfp,params);
    case 'TE'
        mln_calcMatTE(Resultfile,Methlogs,handles.lfp,params);
end
     end



%guidata(hObject, handles);

% --- Executes on button press in analyze.
function analyze_Callback(hObject, eventdata, handles)
% hObject    handle to analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see G
iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});

cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams); 
params=mln_struct_str2num(params); 
params.fs=handles.Params.fs;

Resultfile=['Results/',GroupMethlog,'_',handles.datafile];

iMethlog=get(handles.methods,'Value');
VMethlog=get(handles.methods,'String');
Methlog=char(VMethlog{iMethlog});

handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'A');
if isempty(handles.NetCalcd)
    msgbox('Please calculate First','Error','help');
    return;
end
gin.Net=handles.NetCalcd.Mat;
gin.fs=params.fs;
gin.Methlog=Methlog;

switch GroupMethlog
    case 'TimeBasic'
        handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'A');

    case 'FreqBasic'
        handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'E');

    case 'Hsquare'
        handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'A');

    case 'SynchroSNH'
        %calcMatSynchroSNH(Resultfile,Methlogs,handles.lfp,params);
    case 'Granger'
        handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'A');

    case 'FreqAH'
        handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'E');

    case 'MutualInform'
        handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'A');

    case 'PhaseSynch'
        %calcMatPS(Resultfile,Methlogs,handles.lfp,params);
end
gin.Net=handles.NetCalcd.Mat;
        mln_plotTime4Analysis(gin);
guidata(hObject,handles);


function thresholdNG_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdNG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdNG as text
%        str2double(get(hObject,'String')) returns contents of thresholdNG as a double
%if ~isempty(find(strncmpi(fieldnames(handles),'Net',4)==1,1))
AverageDemost_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function thresholdNG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdNG (see GCBO)
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


% --- Executes on button press in NormalizedData.
function NormalizedData_Callback(hObject, eventdata, handles)
% hObject    handle to NormalizedData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lfp=mln_norm_data(handles.lfp);
scales=str2double(get(handles.scalesSingnals,'String'));
st=str2double(get(handles.timeinstant,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);
guidata(hObject,handles);

% --- Executes on button press in DownSampleData.
function DownSampleData_Callback(hObject, eventdata, handles)
% hObject    handle to DownSampleData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nfs=str2double(get(handles.nfs,'String'));
ntimefs=floor(handles.Params.fs/nfs);
nlfp=downsample(handles.lfp',ntimefs);
lfp=nlfp';
Params=handles.Params;
Params.fs=nfs;
scales=str2double(get(handles.scalesSingnals,'String'));
st=str2double(get(handles.timeinstant,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
mln_showTimeSeriesLFP(lfp,st,wl,scales,Params,handles.TimeSeries);
newdatafile=[handles.datafile(1:strfind(handles.datafile,'fs')+1),num2str(nfs),'.mat'];
save(newdatafile,'lfp','Params');

function nfs_Callback(hObject, eventdata, handles)
% hObject    handle to nfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfs as text
%        str2double(get(hObject,'String')) returns contents of nfs as a double


% --- Executes during object creation, after setting all properties.
function nfs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WindowsLength_Callback(hObject, eventdata, handles)
% hObject    handle to WindowsLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WindowsLength as text
%        str2double(get(hObject,'String')) returns contents of WindowsLength as a double
scales=str2double(get(handles.scalesSingnals,'String'));
st=str2double(get(handles.timeinstant,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries)

% --- Executes during object creation, after setting all properties.
function WindowsLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WindowsLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scalesSingnals_Callback(hObject, eventdata, handles)
% hObject    handle to scalesSingnals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scalesSingnals as text
%        str2double(get(hObject,'String')) returns contents of scalesSingnals as a double
scales=str2double(get(handles.scalesSingnals,'String'));
st=str2double(get(handles.timeinstant,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries)

% --- Executes during object creation, after setting all properties.
function scalesSingnals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalesSingnals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeinstant_Callback(hObject, eventdata, handles)
% hObject    handle to timeinstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeinstant as text
%        str2double(get(hObject,'String')) returns contents of timeinstant as a double
scales=str2double(get(handles.scalesSingnals,'String'));
st=str2double(get(handles.timeinstant,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);

if ~isempty(find(strncmpi(fieldnames(handles),'NetCalcd',8)==1,1))
iw=mln_localizationwindows(st,handles.NetCalcd.Params,handles.Params.fs);
wl=handles.NetCalcd.Params.wins/handles.Params.fs;
set(handles.WindowsLength,'String',num2str(wl));
net=handles.NetCalcd.Mat(:,:,iw);
net=mln_normalizeNet(net-diag(diag(net)));
thresholdnw=str2double(get(handles.thresholdNG,'String'));
mln_showConnectionMatrix(net,handles.connectionMatrix,1,handles.Params);
mln_showNetworkGraph(net,handles.NetworkGraph,thresholdnw,handles.Params);
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);
end


% --- Executes during object creation, after setting all properties.
function timeinstant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeinstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backwardstep.
function backwardstep_Callback(hObject, eventdata, handles)
% hObject    handle to backwardstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scales=str2double(get(handles.scalesSingnals,'String'));
wl=str2double(get(handles.WindowsLength,'String'));
if ~isempty(find(strncmpi(fieldnames(handles),'NetCalcd',8)==1,1))
winstep=handles.NetCalcd.Params.wins/handles.Params.fs;
else winstep=wl/2;
end
st=str2double(get(handles.timeinstant,'String'))-floor(winstep);
if st<0
    st=0;
end



if ~isempty(find(strncmpi(fieldnames(handles),'NetCalcd',8)==1,1))
iw=mln_localizationwindows(st,handles.NetCalcd.Params,handles.Params.fs);
wl=handles.NetCalcd.Params.wins/handles.Params.fs;
set(handles.WindowsLength,'String',num2str(wl));
net=handles.NetCalcd.Mat(:,:,iw);
net=mln_normalizeNet(net-diag(diag(net)));
thresholdnw=str2double(get(handles.thresholdNG,'String'));
mln_showConnectionMatrix(net,handles.connectionMatrix,1,handles.Params);
mln_showNetworkGraph(net,handles.NetworkGraph,thresholdnw,handles.Params);

end
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);
set(handles.timeinstant,'String',st);

% --- Executes on button press in forwardstep.
function forwardstep_Callback(hObject, eventdata, handles)
% hObject    handle to forwardstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scales=str2double(get(handles.scalesSingnals,'String'));

wl=str2double(get(handles.WindowsLength,'String'));
if ~isempty(find(strncmpi(fieldnames(handles),'NetCalcd',8)==1,1))
winstep=handles.NetCalcd.Params.wins/handles.Params.fs;
else winstep=wl/2;
end
st=str2double(get(handles.timeinstant,'String'))+floor(winstep);
Maxt=floor(size(handles.lfp,2)/handles.Params.fs-(winstep)-1);
if st>Maxt
    st=Maxt;
end
if ~isempty(find(strncmpi(fieldnames(handles),'NetCalcd',8)==1,1))
iw=mln_localizationwindows(st,handles.NetCalcd.Params,handles.Params.fs);
wl=handles.NetCalcd.Params.wins/handles.Params.fs;
set(handles.WindowsLength,'String',num2str(wl));
net=handles.NetCalcd.Mat(:,:,iw);
net=mln_normalizeNet(net-diag(diag(net)));
thresholdnw=str2double(get(handles.thresholdNG,'String'));
mln_showConnectionMatrix(net,handles.connectionMatrix,1,handles.Params);
mln_showNetworkGraph(net,handles.NetworkGraph,thresholdnw,handles.Params);

end
mln_showTimeSeriesLFP(handles.lfp,st,wl,scales,handles.Params,handles.TimeSeries);
set(handles.timeinstant,'String',st);


% --- Executes on button press in StatesPlot.
function StatesPlot_Callback(hObject, eventdata, handles)
% hObject    handle to StatesPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NSP=str2double(get(handles.Statesplot_Delay,'String'));
mln_statesplot(handles.lfp,handles.Params,NSP);


% --- Executes on selection change in methods.
function methods_Callback(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methods


% --- Executes during object creation, after setting all properties.
function methods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on Parameterset and none of its controls.
function Parameterset_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Parameterset (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in AverageDemost.
function AverageDemost_Callback(hObject, eventdata, handles)
% hObject    handle to AverageDemost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});

cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams); 
params=mln_struct_str2num(params);

params.fs=handles.Params.fs;

dirname=get(handles.dirfolder,'String');

datadir=[dirname,'/Results'];
 Resultfile=[datadir,'/',GroupMethlog,'_',handles.datafile];
 

%Resultfile=['Results/',GroupMethlog,'_',handles.datafile];

iMethlog=get(handles.methods,'Value');
VMethlog=get(handles.methods,'String');
Methlog=char(VMethlog{iMethlog});

handles.NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'E');
if ~isempty(find(strncmpi(fieldnames(handles),'NetCalcd',8)==1,1))
net=mean(handles.NetCalcd.Mat,3);
net=mln_normalizeNet(net-diag(diag(net)));
thresholdnw=str2double(get(handles.thresholdNG,'String'));
mln_showConnectionMatrix(net,handles.connectionMatrix,1,handles.Params);
mln_showNetworkGraph(net,handles.NetworkGraph,thresholdnw,handles.Params);
end



function Statesplot_Delay_Callback(hObject, eventdata, handles)
% hObject    handle to Statesplot_Delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Statesplot_Delay as text
%        str2double(get(hObject,'String')) returns contents of Statesplot_Delay as a double


% --- Executes during object creation, after setting all properties.
function Statesplot_Delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Statesplot_Delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compare.
function compare_Callback(hObject, eventdata, handles)
% hObject    handle to compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gin.datafile = get(handles.loadfile,'String');
Guide_COMP(gin);


% --- Executes on button press in evaluation.
function evaluation_Callback(hObject, eventdata, handles)
% hObject    handle to evaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% If there is no reference matrix, return; 
%if ~isempty(find(strncmpi(fieldnames(handles),'ReferenceMatrix',15)==1,1))
    
%else
  %  return;
%end
%% 
iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});

cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
params.fs=handles.Params.fs;

dirname=get(handles.dirfolder,'String');
dataprenom = get(handles.loadfile,'String');

Resultfile=['Results/',GroupMethlog,'_',handles.datafile];
%Resultfile=['Tout_',handles.datafile];
iMethlog=get(handles.methods,'Value');
VMethlog=get(handles.methods,'String');
Methlog=char(VMethlog{iMethlog});

Resultdata=mln_Result2evaluate(dirname,dataprenom,GroupMethlog,Methlog,params);

%Resultdata=load(Resultfile);


%NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'E');
gin.ReferenceNet=Resultdata.Connectivity;
 gin.Resultfile=Resultfile;
 gin.Methlog=Methlog;
gin.Net=Resultdata.Mat;
gin.Params=Resultdata.Params;
 GUIevaluationROC2(gin)


% --- Executes on button press in save4Similarity.
function save4Similarity_Callback(hObject, eventdata, handles)
% hObject    handle to save4Similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% get the network
iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
GroupMethlog=char(VMethlogGroup{iMethlogGroup});

cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams); 
params=mln_struct_str2num(params); 
params.fs=handles.Params.fs;

Resultfile=['Results/',GroupMethlog,'_',handles.datafile];

iMethlog=get(handles.methods,'Value');
VMethlog=get(handles.methods,'String');
Methlog=char(VMethlog{iMethlog});

NetCalcd=mln_tofindNet(Resultfile,Methlog,params,'E');

Mat1=abs(mean(NetCalcd.Mat,3));
MatMeths.(Methlog)=normalizeNet(Mat1-diag(diag(Mat1)));
        
resultsimfile=['Similitymean_',handles.datafile];
updateResult(resultsimfile,MatMeths,[]);


% --- Executes on button press in simulated.
function simulated_Callback(hObject, eventdata, handles)
% hObject    handle to simulated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the current Method Group
iMethlogGroup=get(handles.MethodGroup,'Value');
VMethlogGroup=get(handles.MethodGroup,'String');
gin.GroupMethlog=char(VMethlogGroup{iMethlogGroup});
% get teh current method
iMethlog=get(handles.methods,'Value');
VMethlog=get(handles.methods,'String');
gin.Method=char(VMethlog{iMethlog});


gin.datafile = get(handles.loadfile,'String');

MULAN_gen_data(gin);


function totalTime_Callback(hObject, eventdata, handles)
% hObject    handle to totalTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totalTime as text
%        str2double(get(hObject,'String')) returns contents of totalTime as a double


% --- Executes during object creation, after setting all properties.
function totalTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Preprocess.
function Preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to Preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datafile = get(handles.loadfile,'String');
dirname=get(handles.dirfolder,'String');

datadir=[dirname,'/data'];
Resultfile=[datadir,'/',datafile];
 gin.datafile=Resultfile;
GUI_Preprocess(gin);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dirfolder_Callback(hObject, eventdata, handles)
% hObject    handle to dirfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dirfolder as text
%        str2double(get(hObject,'String')) returns contents of dirfolder as a double


% --- Executes during object creation, after setting all properties.
function dirfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nparams=mln_struct_str2num(params)
pfn=fieldnames(params);
for ifield=1:length(pfn)
    nparams.(pfn{ifield})=str2double(params.(pfn{ifield}));
end

function caled=iscalcualted(Resultfile,params)
caled=0;

if exist(Resultfile,'file')
    Rconnect=load(Resultfile);
    oddfieldname=fieldnames(Rconnect);
    Mat=Rconnect.(oddfieldname{1});
    lengthMat=length(Mat);
    for istr=1:lengthMat
    %if  ~isempty(find(strncmpi(oddfieldname,Methlog,NMlog)==1,1))% if there is results about 'Methlog'
        % try to find the results with the same parameters
      %  Nmethlog=length(Rconnect.(Methlog));
        %for i=1:Nmethlog
        cstr=Mat(istr);
            if ~mln_compareparams(cstr.Params,params)
                caled=0;
                return;
            end
        %end
    %end
    [cdata] = imread('MULANLOGO.png');
msgbox('Calculation completed','Success','custom',cdata);
caled=1;

end
end



function Resultdata=mln_Result2evaluate(dirname,dataprenom,GroupMethlog,Methlog,newparams)
datafile=[dirname,'/data/',dataprenom];
%GroupMethlog={'TimeBasic','FreqBasic','Hsquare','Granger','FreqAH','MutualInform'};
Resultfile=[dirname,'/Results/',GroupMethlog,'_',dataprenom];
if exist(Resultfile,'file')
    iNetSaved=load(Resultfile,Methlog);
    Res_Mat=iNetSaved.(Methlog);
    Npara=length(Res_Mat);
    for ipara=1:Npara
        oldparams=Res_Mat(ipara).Params;
        if mln_compareparams(oldparams,newparams)
            iMat=Res_Mat(ipara).Mat;
            if length(size(iMat))>3
                iMat=squeeze(mean(abs(iMat),3));
            end
            Resultdata.Mat=iMat;
            load(datafile,'Connectivity');
            Connectivity=mln_normalizeNet(Connectivity-diag(diag(Connectivity)));
            Resultdata.Connectivity=Connectivity;
            Resultdata.Params=oldparams;
            return;
        end
    end
end
[cdata] = imread('MULANLOGO.png');
msgbox('Calculation first please!','Success','custom',cdata);


% --- Executes on button press in MethodsList.
function MethodsList_Callback(hObject, eventdata, handles)
% hObject    handle to MethodsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure('Name','Methods List');
gca;
imshow('NameList.png');
