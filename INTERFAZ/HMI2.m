function varargout = HMI2(varargin)
% HMI2 MATLAB code for HMI2.fig
%      HMI2, by itself, creates a new HMI2 or raises the existing
%      singleton*.
%
%      H = HMI2 returns the handle to a new HMI2 or the handle to
%      the existing singleton*.
%
%      HMI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HMI2.M with the given input arguments.
%
%      HMI2('Property','Value',...) creates a new HMI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HMI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HMI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HMI2

% Last Modified by GUIDE v2.5 01-Nov-2017 21:52:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HMI2_OpeningFcn, ...
                   'gui_OutputFcn',  @HMI2_OutputFcn, ...
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

% --- Executes just before HMI2 is made visible.
function HMI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HMI2 (see VARARGIN)

% Choose default command line output for HMI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HMI2 wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);

% --- Outputs from this function are returned to the command line.
function varargout = HMI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function mainWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

clear all, clc;
global puerto textButtom;
textButtom = 'None';
%% Ubicamos ejes en figura
axes('Position',[0 0 1 1]);

%%
[x , map] = imread( 'Imagen', 'jpg');
image(x),colormap(map),axis off,hold on;
% sz=18;
m = 'Sistema de posicionamiento para paneles solares';
set_text(m, 10);

%% ----- Centramos la figura -- - - - - - - -
scrsz = get(0 ,'ScreenSize');
pos_act = get(gcf,'Position');
xr = scrsz(3)-pos_act(3);
xp = round(xr/2);
yr = scrsz(4)-pos_act(4);
yp = round(yr/2);
set(gcf,'Position',[xp yp pos_act(3) pos_act(4)]);

% --- Executes during object creation, after setting all properties.
function Bcontinuar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bcontinuar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% handles
% "Inicia Bcontinuar"
% pos_mw  = get(gcf,'Position')
% SizeRecalc(pos_mw, hObject, 2, 30, 0.5)
% pos_mw  = get(gcf,'Position');
% pos_act = get(hObject,'Position');
% xr = pos_mw(3)-pos_act(3);
% xp = round(xr/2);
% yr = pos_mw(4)-pos_act(4);
% yp = round(yr/2);
% set(hObject,'Position',[xp yp 150 75]);

% --- Executes during object creation, after setting all properties.
function panelCom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to panelCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject,'BackgroundColor','alpha');
% pos_mw  = get(gcf,'Position');
% pos_act = get(hObject,'Position');
% pos_mw(3) = pos_mw(3)*0.2;
% pos_mw(4) = pos_mw(4)*0.2;
% xr = pos_mw(3)-pos_act(3);
% xp = round(xr/2);
% % xp = pos_mw(3)/2 - pos_mw(3)*0.2;
% yr = pos_mw(4)-pos_mw(4);
% yp = round(yr/30);
% set(hObject,'Position',[xp yp pos_act(3) pos_act(4)]);

% --- Executes during object creation, after setting all properties.
function serialPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(hObject, 'String', 'No hay conexiones');

function serialPort_Callback(hObject, eventdata, handles)
elegirPuerto(hObject, handles);

% --- Executes on button press in Bconectar.
function Bconectar_Callback(hObject, eventdata, handles)
global puerto textButtom stop sunSys;
if textButtom == "Conectar"
    elegirPuerto(handles.serialPort, handles);
%     puerto
    sunSys = conectar(puerto);
    set(handles.BGdisplay, 'Visible', 'on')
    indicadoresVisible(handles, 'on')
    textButtom = 'Iniciar';
    set(handles.serialPort, 'Visible', 'off');
elseif textButtom == "Buscar"
    if (isempty(puerto) || puerto == 'No hay conexiones')%"No hay conexiones")
        elegirPuerto(handles.serialPort, handles);
        puertosCom(handles.serialPort, handles.Bconectar);
    end
elseif textButtom == "Iniciar"
    mensaje = recolector(sunSys)
    b = split(mensaje)
    b = b{1}
%     eval("a = py.dict(pyargs("+b+"))")
%     textButtom = 'Parar'
    
%     stop = 0
    %eventdata("Action")
%     recalc_val()
elseif textButtom == "Parar"
    if stop == 0
%         Bconectar_Callback(hObject, eventdata, handles)
    end
end
set(hObject, 'String', textButtom)
% recalc_val()

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_text(msj, sz)
text(450,450,msj,'Fontname','ComicSansMS', 'HorizontalAlignment', 'Center', ...
    'Fontangle','Italic','Fontweight','Bold','Fontsize',sz, ...
    'color',[0.9 0.1 0.1]);
    
% --- Executes on button press in Bcontinuar.
function Bcontinuar_Callback(hObject, eventdata, handles)
% hObject    handle to Bcontinuar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Visible', 'off');
serialVisible(handles, 'on');
% handles(1)
'Este es el callback';%"Este es el callback";

function elegirPuerto(obj, h)
global puerto;
puerto = get(obj, 'String')
puerto(get(obj, 'Value'))
h.metricdata.puerto = puerto;

function serialVisible(h, io)
set(h.serialPort, 'Visible', io);
puertosCom(h.serialPort, h.Bconectar);
% set(h.serialPort, 'String', seriallist);
set(h.Bconectar, 'Visible', io);
indicadoresVisible(h, 'off');

function puertosCom(obj1, obj2)
global textButtom textPopupm;
puertos = seriallist;
if isempty(puertos)
%     'Mk esta imprimiendo esto'
    textButtom = 'Buscar';
    textPopupm = 'No hay conexiones';
%     errordlg('Input must be a number','Error');
else
    textButtom = 'Conectar';
    textPopupm = puertos;
%     set(obj, 'String', puertos)
end
set(obj2, 'String', textButtom)
set(obj1, 'String', textPopupm)

function indicadoresVisible(h, jo)
set(h.LBcorriente, 'Visible', jo);
set(h.LBvoltaje, 'Visible', jo);
set(h.LBpotencia, 'Visible', jo);
set(h.LBasimut, 'Visible', jo);
set(h.LBelevacion, 'Visible', jo);
set(h.Tcorriente, 'Visible', jo);
set(h.Tvoltaje, 'Visible', jo);
set(h.Tpotencia, 'Visible', jo);
set(h.Tasimut, 'Visible', jo);
set(h.Televacion, 'Visible', jo);
set(h.RBgrafica, 'Visible', jo);
set(h.BParar, 'Visible', jo);

% --- Executes when mainWindow is resized.
function mainWindow_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to mainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos_mw  = get(gcf,'Position');
pos_mw  = get(hObject,'Position');
%% "Bcontinuar:";
SizeRecalc(pos_mw, handles.Bcontinuar, 2, 100, 0.2, 0.2);
%% "panelCom:";
% SizeRecalc(pos_mw, handles.panelCom, 100, 100, 0.3, 0.3);
l1 = 5;
l2 = 15;
SizeRecalc(pos_mw, handles.serialPort, 100, l1, 0.25, 0.1);
SizeRecalc(pos_mw, handles.Bconectar, 100, l2, 0.25, 0.1);
SizeRecalc(pos_mw, handles.BParar, 100, 5, 0.25, 0.1);
w = 0.3;
h = 0.2;
c2 = 100/1;
c3 =100/25;
c4 = 100/40;
c5 = 100/58;
c6 = 100/78;
c7 = 100/93;
l1 = 3/2;
l2 = 10;
SizeRecalc(pos_mw, handles.BGdisplay, 1, 20, 0.73, 0.25);
pos_mw = get(handles.BGdisplay,'Position');
SizeRecalc(pos_mw, handles.LBvoltaje, c2, l1, h, w);
SizeRecalc(pos_mw, handles.Tvoltaje, c3, l1, h/2, w);
SizeRecalc(pos_mw, handles.LBasimut, c4, l1, h, w);
SizeRecalc(pos_mw, handles.Tasimut, c5, l1, h/2, w);
SizeRecalc(pos_mw, handles.LBpotencia, c6, l1, h, w);
SizeRecalc(pos_mw, handles.Tpotencia, c7, l1, h/2, w);

SizeRecalc(pos_mw, handles.LBcorriente, c2, l2, h, w);
SizeRecalc(pos_mw, handles.Tcorriente, c3, l2, h/2, w);
SizeRecalc(pos_mw, handles.LBelevacion, c4, l2, h, w);
SizeRecalc(pos_mw, handles.Televacion, c5, l2, h/2, w);
SizeRecalc(pos_mw, handles.RBgrafica, c7, l2, h, w);

function SizeRecalc(pos_mw, h, xf, yf, fx, fy)
% pos_mw  = get(gcf,'Position');
pos_mw;
pos_act = get(h,'Position');
pos_mx = pos_mw(3)*fx;
pos_my = pos_mw(4)*fy;
xr = pos_mw(3)-pos_mx;
xp = round(xr/xf);
% xp = pos_mw(3)/2 - pos_mw(3)*0.2;
yr = pos_mw(4)-pos_my;
yp = round(yr/yf);
% yp = pos_mw(4)/3 - pos_mw(4)*0.3;
set(h,'Position',[xp yp pos_mx pos_my]);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to serialPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of serialPort as text
%        str2double(get(hObject,'String')) returns contents of serialPort as a double



function Tvoltaje_Callback(hObject, eventdata, handles)
% hObject    handle to Tvoltaje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tvoltaje as text
%        str2double(get(hObject,'String')) returns contents of Tvoltaje as a double


% --- Executes during object creation, after setting all properties.
function Tvoltaje_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tvoltaje (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tcorriente_Callback(hObject, eventdata, handles)
% hObject    handle to Tcorriente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tcorriente as text
%        str2double(get(hObject,'String')) returns contents of Tcorriente as a double


% --- Executes during object creation, after setting all properties.
function Tcorriente_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tcorriente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tasimut_Callback(hObject, eventdata, handles)
% hObject    handle to Tasimut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tasimut as text
%        str2double(get(hObject,'String')) returns contents of Tasimut as a double


% --- Executes during object creation, after setting all properties.
function Tasimut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tasimut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Televacion_Callback(hObject, eventdata, handles)
% hObject    handle to Televacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Televacion as text
%        str2double(get(hObject,'String')) returns contents of Televacion as a double


% --- Executes during object creation, after setting all properties.
function Televacion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Televacion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RBgrafica.
function RBgrafica_Callback(hObject, eventdata, handles)
% hObject    handle to RBgrafica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject.Value
% Hint: get(hObject,'Value') returns toggle state of RBgrafica
a = get(hObject, 'Value');
if a == 1
    x = 1:.1:10
    axes(handles.Aplot)
    plot(x,sin(x),'-r')
else
    axes(handles.Aplot)
    plot(0,0)
%     clc;
    set(handles.Aplot, 'Visible', 'off');
end


function Tpotencia_Callback(hObject, eventdata, handles)
% hObject    handle to Tpotencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tpotencia as text
%        str2double(get(hObject,'String')) returns contents of Tpotencia as a double


% --- Executes during object creation, after setting all properties.
function Tpotencia_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tpotencia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BParar.
function BParar_Callback(hObject, eventdata, handles)
% hObject    handle to BParar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sunSys;
fclose(sunSys)