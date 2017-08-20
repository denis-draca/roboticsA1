function varargout = SawyerManufacturing(varargin)
% SAWYERMANUFACTURING MATLAB code for SawyerManufacturing.fig
%      SAWYERMANUFACTURING, by itself, creates a new SAWYERMANUFACTURING or raises the existing
%      singleton*.
%
%      H = SAWYERMANUFACTURING returns the handle to a new SAWYERMANUFACTURING or the handle to
%      the existing singleton*.
%
%      SAWYERMANUFACTURING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAWYERMANUFACTURING.M with the given input arguments.
%
%      SAWYERMANUFACTURING('Property','Value',...) creates a new SAWYERMANUFACTURING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the SAWYERMANUFACTURING before SawyerManufacturing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SawyerManufacturing_OpeningFcn via varargin.
%
%      *See SAWYERMANUFACTURING Options on GUIDE's Tools menu.  Choose "SAWYERMANUFACTURING allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SawyerManufacturing

% Last Modified by GUIDE v2.5 20-Aug-2017 13:25:10

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SawyerManufacturing_OpeningFcn, ...
                   'gui_OutputFcn',  @SawyerManufacturing_OutputFcn, ...
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


% --- Executes just before SawyerManufacturing is made visible.
function SawyerManufacturing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SawyerManufacturing (see VARARGIN)
% Choose default command line output for SawyerManufacturing

clc;
startup_rvc;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes SawyerManufacturing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SawyerManufacturing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function inS1_Callback(hObject, eventdata, handles)
% hObject    handle to inS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inS1 as text
%        str2double(get(hObject,'String')) returns contents of inS1 as a double


% --- Executes during object creation, after setting all properties.
function inS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function inS2_Callback(hObject, eventdata, handles)
% hObject    handle to inS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inS2 as text
%        str2double(get(hObject,'String')) returns contents of inS2 as a double


% --- Executes during object creation, after setting all properties.
function inS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function inPCB_Callback(hObject, eventdata, handles)
% hObject    handle to inPCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inPCB as text
%        str2double(get(hObject,'String')) returns contents of inPCB as a double


% --- Executes during object creation, after setting all properties.
function inPCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inPCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inTop_Callback(hObject, eventdata, handles)
% hObject    handle to inTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inTop as text
%        str2double(get(hObject,'String')) returns contents of inTop as a double


% --- Executes during object creation, after setting all properties.
function inTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function inBottom_Callback(hObject, eventdata, handles)
% hObject    handle to inBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inBottom as text
%        str2double(get(hObject,'String')) returns contents of inBottom as a double


% --- Executes during object creation, after setting all properties.
function inBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buMainTask.
function buMainTask_Callback(hObject, eventdata, handles)
% hObject    handle to buMainTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


sawyer1 = get(handles.inS1, 'String');
sawyer2 = get(handles.inS2, 'String');
pcbPos = get(handles.inPCB, 'String');
topPos = get(handles.inTop, 'String');
bottomPos = get(handles.inBottom, 'String');

loopCount = get(handles.inLoopCount, 'String');

if isempty(sawyer1)...
        || isempty(sawyer2) ...
        || isempty(pcbPos) ...
        || isempty(topPos) ...
        || isempty(bottomPos) ...
        || isempty(loopCount)

    disp('not all values have been provided, please do so')
else
    cla(handles.axes1);
    axes(handles.axes1);
    set(handles.outMade, 'String', string(0));
    
    loopCount = uint16(str2double(loopCount));
    
    %convert x,y,z,r,p,y positions into poses
    sawyerPos_1 = GenerateTransform(sawyer1);
    sawyerPos_2 = GenerateTransform(sawyer2);
    pcbPos = GenerateTransform(pcbPos);
    topPos = GenerateTransform(topPos);
    bottomPos = GenerateTransform(bottomPos);
    
    
    sawyer1 = Sawyer(sawyerPos_1, 'sawyer1');
    sawyer2 = Sawyer(sawyerPos_2,'sawyer2');
    
    sawyer1_x = sawyerPos_1(1,4);
    sawyer1_y = sawyerPos_1(2,4);
    sawyer2_x = sawyerPos_2(1,4);
    sawyer2_y = sawyerPos_2(2,4);
    
    centre = transl((sawyer1_x+sawyer2_x)/2, (sawyer1_y + sawyer2_y), 0);
    joinPos = centre*transl(0, 0.1, 0.5);
    
    pcbMesh = PartLoader('pcb.ply', pcbPos);
    topMesh = PartLoader('housing_top.ply',topPos);
    bottomMesh = PartLoader('housing_bottom.ply', bottomPos);
    tableMesh = PartLoader('small_table.ply' ,[pcbPos,topPos,bottomPos]);

    worldMesh = PartLoader('world3.ply', centre);

    dropPose = centre;
    chuteMesh = PartLoader('chute.ply', dropPose);
    completeMesh = PartLoader('complete.ply', dropPose);
    
    if Distance2p(sawyer1.model.base, topPos) < Distance2p(sawyer2.model.base, topPos)
        for i = 1:loopCount
            topMesh = sawyer1.PickUpPart(topMesh, joinPos);
            pcbMesh = sawyer2.PickUpPart(pcbMesh, joinPos * ...
            transl(0,0,0.01) * trotx(pi));

            sawyer2.TuckArm;

            bottomMesh = sawyer2.PickUpPart(bottomMesh, joinPos * trotx(pi));

            pcbMesh.MovePart(dropPose);
            topMesh.MovePart(dropPose);
            bottomMesh.MovePart(dropPose);

            completeMesh.MovePart(joinPos);
            completeMesh = sawyer1.DropPart(completeMesh, dropPose);
            
            pause(1);
            pcbMesh.MovePart(pcbPos);
            topMesh.MovePart(topPos);
            bottomMesh.MovePart(bottomPos);
            completeMesh.MovePart(dropPose);
            
            sawyer2.TuckArm;
            sawyer1.TuckArm;
            
            set(handles.outMade, 'String', string(i));
            
        end
    
    else
        for i = 1:loopCount
            topMesh = sawyer2.PickUpPart(topMesh, joinPos);
            pcbMesh = sawyer1.PickUpPart(pcbMesh, joinPos * ...
            transl(0,0,0.01) * trotx(pi));

            sawyer1.TuckArm;

            bottomMesh = sawyer1.PickUpPart(bottomMesh, joinPos * trotx(pi));

            pcbMesh.MovePart(dropPose);
            topMesh.MovePart(dropPose);
            bottomMesh.MovePart(dropPose);

            completeMesh.MovePart(joinPos);
            completeMesh = sawyer2.DropPart(completeMesh, dropPose);
            
            pause(1);
            pcbMesh.MovePart(pcbPos);
            topMesh.MovePart(topPos);
            bottomMesh.MovePart(bottomPos);

            completeMesh.MovePart(dropPose);
            
            sawyer2.TuckArm;
            sawyer1.TuckArm;
            
            set(handles.outMade, 'String', string(i));
            
        end
    end
end



function inROS_Callback(hObject, eventdata, handles)
% hObject    handle to inROS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inROS as text
%        str2double(get(hObject,'String')) returns contents of inROS as a double


% --- Executes during object creation, after setting all properties.
function inROS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inROS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buROS.
function buROS_Callback(hObject, eventdata, handles)
% hObject    handle to buROS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bagLocation = get(handles.inROS, 'String');
animationRate = get(handles.inRate, 'String');

if isempty(bagLocation) ...
        || isempty(animationRate)
    disp('no bag location or animation rate given, please provide both');
else
    cla(handles.axes1);
    axes(handles.axes1);
    
    animationRate = uint16(str2double(animationRate));
    
    sawyer1 = Sawyer(transl(0,0,0), 's');
    sawyer1.CopyROSBag(bagLocation, animationRate);
end



function inRate_Callback(hObject, eventdata, handles)
% hObject    handle to inRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inRate as text
%        str2double(get(hObject,'String')) returns contents of inRate as a double


% --- Executes during object creation, after setting all properties.
function inRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inLoopCount_Callback(hObject, eventdata, handles)
% hObject    handle to inLoopCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inLoopCount as text
%        str2double(get(hObject,'String')) returns contents of inLoopCount as a double


% --- Executes during object creation, after setting all properties.
function inLoopCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inLoopCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function transform = GenerateTransform(rawInput)
splitValues = str2double(strsplit(rawInput,','));

transform = transl(splitValues(1,1),splitValues(1,2),splitValues(1,3)) * ...
    rpy2tr(splitValues(1,4),splitValues(1,5),splitValues(1,6));
