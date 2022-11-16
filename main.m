function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 16-Nov-2022 03:15:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in upload.
function upload_Callback(hObject, eventdata, handles)
% hObject    handle to upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile({'*.jpg';'*.jpeg';'*.png'},'Select Image');
if isequal(file,0)
    disp('User Cancel')
else
    disp(['User Selected',fullfile(path,file)]);
    [img, cm] = imread(fullfile(path,file));
    if isempty(cm)
        myImage = img;
    else
        myImage = uint8(ind2rgb(img,cm).* 255);
    end
    setappdata(0, 'Image1', myImage)
    axes(handles.img1);
    hold off;
    cla reset;
    imshow(myImage);
    
    setappdata(0, 'Image2', myImage)
    axes(handles.img2);
    hold off;
    cla reset;
    imshow(myImage);
end

% --- Executes on button press in histo.
function histo_Callback(hObject, eventdata, handles)
% hObject    handle to histo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myImago1 = getappdata(0, 'Image1');
myImago2 = getappdata(0, 'Image2');

[R1, x] = imhist(myImago1(:,:,1));
[G1, x] = imhist(myImago1(:,:,2));
[B1, x] = imhist(myImago1(:,:,3));

axes(handles.hist1);
hold off;
cla reset;
plot(x,R1,'Red',x,G1,'Green', x,B1,'Blue');
xlim([0,255]);
box off;
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'xcolor','none');
set(gca,'ycolor','none');

if size(myImago2,3)==3
    [R2, x] = imhist(myImago2(:,:,1));
    [G2, x] = imhist(myImago2(:,:,2));
    [B2, x] = imhist(myImago2(:,:,3));
    
    axes(handles.hist2);
    hold off;
    cla reset;
    plot(x,R2,'Red',x,G2,'Green', x,B2,'Blue','LineWidth',1.5);
    xlim([0,255]);
    box off;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'xcolor','none');
    set(gca,'ycolor','none');
elseif islogical(myImago2)== 1
    axes(handles.hist2);
    hold off;
    cla reset;
    a = sum(myImago2(:)==0);
    b = sum(myImago2(:)==1);
    x = [a b];
    bar([0 1], x);
    set(gca,'ytick',[]);
else
    H = imhist(myImago2);
    axes(handles.hist2);
    hold off;
    cla reset;
    plot(x,H,'Black');
    xlim([0,255]);
    box off;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'xcolor','none');
    set(gca,'ycolor','none');
end






% --- Executes on button press in negativebtn.
function negativebtn_Callback(hObject, eventdata, handles)
% hObject    handle to negativebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myImago2 = getappdata(0, 'Image1');
L = 2^8;
neg = (L-1) - myImago2;
setappdata(0, 'Image2', neg)
axes(handles.img2);
hold off;
cla reset;
imshow(neg);



% --- Executes on button press in grayscalebtn.
function grayscalebtn_Callback(hObject, eventdata, handles)
% hObject    handle to grayscalebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myImago2 = getappdata(0, 'Image1');
gray = rgb2gray(myImago2);
setappdata(0, 'Image2', gray)
axes(handles.img2);
hold off;
cla reset;
imshow(gray);

% --- Executes on button press in thres.
function thres_Callback(hObject, eventdata, handles)
% hObject    handle to thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myImago2 = getappdata(0, 'Image1');
T = str2num(get(handles.ts,'String'));
bw = im2bw(myImago2,T/255);
setappdata(0, 'Image2', bw);
axes(handles.img2);
hold off;
cla reset;
imshow(bw);

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function img1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate img1

function ts_Callback(hObject, eventdata, handles)
% hObject    handle to ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ts as text
%        str2double(get(hObject,'String')) returns contents of ts as a double


% --- Executes during object creation, after setting all properties.
function ts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ts_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ts_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ts_sliderx = get(hObject,'Value');
ts_sliderx = round(ts_sliderx);
set(handles.ts,'String',strcat(num2str(ts_sliderx)));



% --- Executes during object creation, after setting all properties.
function ts_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ts_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myImago2 = getappdata(0, 'Image1');
setappdata(0, 'Image2', myImago2)
axes(handles.img2);
hold off;
cla reset;
imshow(myImago2);

[R2, x] = imhist(myImago2(:,:,1));
[G2, x] = imhist(myImago2(:,:,2));
[B2, x] = imhist(myImago2(:,:,3));

axes(handles.hist2);
plot(x,R2,'Red',x,G2,'Green', x,B2,'Blue','LineWidth',1.5);
xlim([0,255]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'xcolor','none');
set(gca,'ycolor','none');