function varargout = MULAN_gen_data(varargin)
% MULAN_GEN_DATA M-file for MULAN_gen_data.fig
%      MULAN_GEN_DATA, by itself, creates a new MULAN_GEN_DATA or raises the existing
%      singleton*.
%
%      H = MULAN_GEN_DATA returns the handle to a new MULAN_GEN_DATA or the handle to
%      the existing singleton*.
%
%      MULAN_GEN_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULAN_GEN_DATA.M with the given input arguments.
%
%      MULAN_GEN_DATA('Property','Value',...) creates a new MULAN_GEN_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MULAN_gen_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MULAN_gen_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MULAN_gen_data

% Last Modified by GUIDE v2.5 03-Feb-2014 16:16:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MULAN_gen_data_OpeningFcn, ...
                   'gui_OutputFcn',  @MULAN_gen_data_OutputFcn, ...
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


% --- Executes just before MULAN_gen_data is made visible.
function MULAN_gen_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MULAN_gen_data (see VARARGIN)

% Choose default command line output for MULAN_gen_data
handles.output = hObject;
Paramsdata=initial_param_data();
set(handles.Parameterset,'Data',Paramsdata);
axes(handles.Logo);
imshow('MULANLOGO.png');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MULAN_gen_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MULAN_gen_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Gen_nmm.
function Gen_nmm_Callback(hObject, eventdata, handles)
% hObject    handle to Gen_nmm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
mln_generate_nmm(params.No_Net,params.Nums_Nodes,params.strfile,params.dir,params.filename,params.CS,params.Nsignals);
%(is,nc,strfile,dirname,prename,cs,N) 


% --- Executes on button press in Gen_rossler.
function Gen_rossler_Callback(hObject, eventdata, handles)
% hObject    handle to Gen_rossler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
mln_generate_rossler(params.dir,params.filename,params.Nsignals,params.strfile,params.No_Net,params.CS,0,0,0);

%dirname,prename,npts,strfile,is,cs,odelay,flag_noise,SNR
% --- Executes on button press in Gen_linear.
function Gen_linear_Callback(hObject, eventdata, handles)
% hObject    handle to Gen_linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
mln_generate_linear(params.dir,params.filename,params.Nsignals,params.strfile,params.No_Net,params.CS,1);
%mln_generate_linear(dirname,prename,npts,strfile,is,cs,delaydelay)

% --- Executes on button press in Gen_henon.
function Gen_henon_Callback(hObject, eventdata, handles)
% hObject    handle to Gen_henon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
mln_generate_henon(params.dir,params.filename,params.Nsignals,params.strfile,params.No_Net,params.CS,0,0,0);


% --- Executes on button press in Gen_fmri.
function Gen_fmri_Callback(hObject, eventdata, handles)
% hObject    handle to Gen_fmri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
mln_generate_fMRI(params.No_Net,params.Nums_Nodes,params.strfile,params.dir,params.filename,params.CS,params.Nsignals);

function  paramsdata=initial_param_data()

param_df=struct('dir','Examples',...,
    'filename','Ex',...,
    'strfile','structureN5L5',...,
    'Nums_Nodes',5,...,
    'No_Net',20,...,
    'CS',1,...,
    'Nsignals',3000);

paramsfields=fieldnames(param_df);
Nparamf=length(paramsfields);
paramsdata=cell(Nparamf,2);
for i=1:Nparamf
    paramsdata{i,1}=paramsfields{i};
    paramsdata{i,2}=param_df.(paramsfields{i});
end

