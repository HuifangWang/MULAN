function varargout = GUI_Preprocess(varargin)
% GUI_PREPROCESS MATLAB code for GUI_Preprocess.fig
%      GUI_PREPROCESS, by itself, creates a new GUI_PREPROCESS or raises the existing
%      singleton*.
%
%      H = GUI_PREPROCESS returns the handle to a new GUI_PREPROCESS or the handle to
%      the existing singleton*.
%
%      GUI_PREPROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PREPROCESS.M with the given input arguments.
%
%      GUI_PREPROCESS('Property','Value',...) creates a new GUI_PREPROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Preprocess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Preprocess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Preprocess

% Last Modified by GUIDE v2.5 15-Feb-2013 17:59:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Preprocess_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Preprocess_OutputFcn, ...
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


% --- Executes just before GUI_Preprocess is made visible.
function GUI_Preprocess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Preprocess (see VARARGIN)

% Choose default command line output for GUI_Preprocess
paramsfields={'wins','overlap','minfreq','maxfreq','stepfreq'};
Paramsdata=mln_initialparamsmethods(paramsfields);
handles.varinput=varargin{1};
axes(handles.Logo);
imshow('MULANLOGO.png');

set(handles.Parameterset,'Data',Paramsdata);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Preprocess wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Preprocess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FourierT.
function FourierT_Callback(hObject, eventdata, handles)
% hObject    handle to FourierT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
params=mln_struct_str2num(params);
raw_data=load(handles.varinput.datafile);
lfp=raw_data.LFP;
fs=raw_data.Params.fs;
freqs=params.minfreq:params.stepfreq:params.maxfreq;
[Psd,freqs,times] = getPsd_fourier(lfp, params.wins,floor(params.overlap*params.wins),fs, freqs);
plot_psd(Psd,raw_data.Params,'Fourier',freqs,times);

% --- Executes on button press in WaveletT.
function WaveletT_Callback(hObject, eventdata, handles)
% hObject    handle to WaveletT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cparams=get(handles.Parameterset,'Data');
params=mln_cell2struct(cparams);
params=mln_struct_str2num(params);
raw_data=load(handles.varinput.datafile);

freqs=params.minfreq:params.stepfreq:params.maxfreq;

raw_data=load(handles.varinput.datafile);
fileprevar=fieldnames(raw_data);
                iLFP=strncmpi(fileprevar,'LFP',3);
                if ~isempty(find(strncmpi(fileprevar,'LFP',1)==1,1))
                    lfp = raw_data.(char(fileprevar(iLFP)));
                end
fs=raw_data.Params.fs;
Psd=getPsd_wavelet(lfp, fs, freqs);
Ntimes=size(Psd,2);
times=(1:Ntimes)/fs;
plot_psd(Psd,raw_data.Params,'Wavelet',freqs,times);

function plot_psd(Psd,Params,flag,freqs,times)
Nchan=size(Psd,1);
%% if Number of channels is larger than 6, we divided the figures with each
%% one less or equals 6x6
NumberChanforPage=6;
Npage=(floor(Nchan/NumberChanforPage)+1);
%% define the name of channels
if isempty(find(strncmpi(fieldnames(Params),'str',3)==1,1));
    str=1:Nchan;
else
str=Params.str;
end

%% 
if Nchan>NumberChanforPage
    for ipage=1:Npage
        if ipage==Npage
            ichanV=(ipage-1)*NumberChanforPage+1:Nchan;
            
        else
            ichanV=(ipage-1)*NumberChanforPage+1:ipage*NumberChanforPage;
        end
        istr=str(ichanV);
        hf=figure('name',['Sepctrum Analysis', flag, 'in Page ',num2str(ipage), ' / ',num2str(Npage)]);
        plotPsd(hf,ichanV,istr,Psd,freqs,times);    
          
    end
else

    ichanV=1:Nchan;
     istr=str;
    hf=figure('name',['Sepctrum Analysis', flag, 'in Page ','1/1']);
    plotPsd(hf,ichanV,istr,Psd,freqs,times);    
end


%for idelay=0:NSP
function plotPsd(hf,ichanV,istr,Psd,freqs,times) 
Nchan=length(ichanV);
for i=1:length(ichanV)
    
    ha=subplot(Nchan,1,i,'parent',hf);
    imagesc(times,freqs,squeeze(abs(Psd(i,:,:)))');
    set(ha,'YDir','normal');
    if iscell(istr)
    title(istr{i});
    else
        title(num2str(istr(i)));
    end
        
end
%end
function [psd,freqs,times] = getPsd_fourier(lfp, window,noverlap,fs, freqs)
[Nchannel,~]=size(lfp);
[psd1,freqs,times]=spectrogram(lfp(1,:),window,noverlap,freqs,fs);
[nFreq,nTime]=size(psd1);
psd=zeros(Nchannel,nTime,nFreq);
psd(1,:,:)=psd1';
for i=2:Nchannel
psd(i,:,:)=spectrogram(lfp(i,:),window,noverlap,freqs,fs)';
end


function nparams=mln_struct_str2num(params)
pfn=fieldnames(params);
for ifield=1:length(pfn)
    nparams.(pfn{ifield})=str2double(params.(pfn{ifield}));
end
