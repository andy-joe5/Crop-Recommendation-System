function varargout = Soil_detect(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Soil_detect_OpeningFcn, ...
                   'gui_OutputFcn',  @Soil_detect_OutputFcn, ...
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


% --- Executes just before IRIS_Dect is made visible.
function Soil_detect_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
axes(handles.axes1); axis off
axes(handles.axes2); axis off
axes(handles.axes3); axis off
axes(handles.axes4); axis off
set(handles.edit1,'String',' ')
set(handles.edit3,'String',' ')
set(handles.edit4,'String',' ')

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Soil_detect_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;
[fname path]=uigetfile('*.*','Browse Image');
if fname~=0
    img=imread([path,fname]);
    axes(handles.axes1); imshow(img); title('Original Image');
%     set(handles.text13,'String',fname)
    a=img;
    
else
    warndlg('Please Select the necessary Image File');
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

global flag;flag=0;
global a;global x;
if flag==0;
I=rgb2gray(a);
x=I;
axes(handles.axes2); imshow(I); title('Gray Image');
pause(1);
I2 = imtophat(I,strel('disk',15));
I3 = histeq(I2);
y=I3;
axes(handles.axes2); imshow(I3);title('Increase the Image Contrast');
pause(1.5);

flag=0;
end 


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)


global x;global seg;
I=x;
m = zeros(size(I,1),size(I,8));     
m(111:222,123:234) = 1;
I = imresize(I,.5);  
m = imresize(m,.5);

axes(handles.axes4); imshow(I);
seg = region_seg(I, m, 500);
pause(1);
 title('Segmented image');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;global seg;global nn;global y;
  run('predict_SVM.m');

axes(handles.axes3); imshow(seg); title('Classified image- Level1');
 pause(1);
  run('Class_dec.p');
axes(handles.axes3); imshow(nn); title('Classified image');

hsv=rgb2hsv(a);
    hueImage = hsv(:,:, 1);
    % figure, imshow(hueImage);
    meann = mean2(seg);
    meann= meann*100;
    y = round(meann);
    disp(y);
 run('predict.m');
pause(1);
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1); cla(handles.axes1); title(''); axis off
axes(handles.axes2); cla(handles.axes2); title(''); axis off
axes(handles.axes3); cla(handles.axes3); title(''); axis off
axes(handles.axes4); cla(handles.axes4); title(''); axis off
set(handles.edit1,'String','**')
set(handles.edit4,'String','**')
set(handles.edit3,'String','**')



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close Soil_detect



function edit3_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)



% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
