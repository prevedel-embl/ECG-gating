function varargout = ECG_Filtering(varargin)
% ECG_FILTERING MATLAB code for ECG_Filtering.fig
%      ECG_FILTERING, by itself, creates a new ECG_FILTERING or raises the existing
%      singleton*.
%
%      H = ECG_FILTERING returns the handle to a new ECG_FILTERING or the handle to
%      the existing singleton*.
%
%      ECG_FILTERING('CAfLLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECG_FILTERING.M with the given input arguments.
%
%      ECG_FILTERING('Property','Value',...) creates a new ECG_FILTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECG_Filtering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECG_Filtering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%       
%       Copyright, Prevedel Lab @ EMBL, June, 2021.
%       This Matlab script is used to set parameters of FPGA codes which are used in the ECG-gating system for
%       multi-photon microscopy of the in-vivo mouse brain, as described in Streich et. al, Nat.Meth. 2021.
%
%       Last Modified by Matteo Barbieri and Ling Wang @EMBL on June-2021 10:07:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECG_Filtering_OpeningFcn, ...
                   'gui_OutputFcn',  @ECG_Filtering_OutputFcn, ...
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


% --- Executes just before ECG_Filtering is made visible.
function ECG_Filtering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECG_Filtering (see VARARGIN)

% Choose default command line output for ECG_Filtering
handles.output = hObject;
handles.user_mode=1;
handles.threshold=100;
handles.percent=50;
handles.safe_percent=95;
handles.is_open= 0;
handles.COM_PORT_NUMBER = 4;
handles.delay_percent = 5;
handles.s = 0;
handles.mode_3=0;

handles.Title = 'You fool!';
handles.icon = imread('index.jpg');
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ECG_Filtering_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1_Callback(hObject, eventdata, handles)
safe_percent = str2double(get(hObject, 'String'));
if 80<=safe_percent && safe_percent<=95
    handles.safe_percent= safe_percent;
else
    f = msgbox('Please enter a value between 80 and 95',handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_Callback(hObject, eventdata, handles)
threshold= str2double(get(hObject, 'String'));
if 0<=threshold && threshold<=255
    handles.threshold= threshold;
else
    f = msgbox('Please enter a value between 0 and 255', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)
percent= str2double(get(hObject, 'String'));
if 0<=percent && percent<=90
    handles.percent= percent;
else
    f = msgbox('Please enter a value between 0 and 90', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);


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
function edit4_Callback(hObject, eventdata, handles)
handles.COM_PORT_NUMBER= str2double(get(hObject, 'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit5_Callback(hObject, eventdata, handles)
delay_percent= str2double(get(hObject, 'String'));
if 0<=delay_percent && delay_percent<=50 && delay_percent <= handles.percent - 5
    handles.delay_percent= delay_percent;
elseif delay_percent >= handles.percent - 5
    f = msgbox('Please enter a value smaller than percent -5', handles.Title, 'custom', handles.icon);
else
    f = msgbox('Please enter a value between 0 and 50', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
if handles.is_open ==1
    fprintf(handles.s,'1');
    fprintf(handles.s,'1');
    handles.mode_3=0;
else
    f = msgbox('You have to open the serial port first!', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
if handles.is_open ==1
    fprintf(handles.s,'1');
    fprintf(handles.s,'2');
    handles.mode_3=0;
else
    f = msgbox('You have to open the serial port first!', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
if handles.is_open ==1
    fprintf(handles.s,'1');
    fprintf(handles.s,'3');
    handles.mode_3=1;
else
    f = msgbox('You have to open the serial port first!', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
if handles.is_open ==0
    try
        handles.s = serial(strcat('com',num2str(handles.COM_PORT_NUMBER)), 'BAUD', 115200);
        fopen(handles.s);
        handles.is_open=1;
    catch ME
        if (strcmp(ME.identifier, 'MATLAB:serial:fopen:opfailed'))
            f = msgbox('##### Please select a valid COM port #####', handles.Title,'custom', handles.icon);
        end
        fprintf(ME.identifier);
    end
end
guidata(hObject,handles);
    

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
if handles.is_open ==1
    fclose(handles.s);
    handles.is_open=0;
end
guidata(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
if handles.is_open==1
    if handles.mode_3==1
        fprintf(handles.s,'2');
        fprintf(handles.s, num2str(handles.threshold));
        fprintf(handles.s,'3');
        fprintf(handles.s, num2str(handles.percent));
        %fprintf(handles.s,'4');
        %fprintf(handles.s, num2str(handles.safe_percent));
        fprintf(handles.s,'5');
        fprintf(handles.s, num2str(handles.delay_percent));
    else
        f = msgbox('You have to change to mode 3 first!', handles.Title, 'custom', handles.icon);
    end
else
    f = msgbox('You have to open the serial port first!', handles.Title, 'custom', handles.icon);
end
guidata(hObject,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if handles.is_open==1
    fclose(handles.s);
    handles.is_open=0;
end
delete(hObject);
