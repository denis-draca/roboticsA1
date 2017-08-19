function [ myRobot ] = make_sawyer( name, base_transform )
%UNTITLED Generates and returns sawyer model
%   Detailed explanation goes here

if class(name) ~= 'char'
    return
end

limit0 = (350/2)*pi/180;
limit1 = limit0;
limit2 = limit0;
limit3 = limit0;
limit4 = (341/2)*pi/180;
limit5 = limit4;
limit6 = (540/2)*pi/180;

L1 = Link('d',0.317,'a',-0.081,'alpha',pi/2,'offset',0, 'qlim', [-limit0, limit0]);

L2 = Link('d',0.18,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-limit1, limit1]);

L3 = Link('d',0.4,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-limit2, limit2]);

L4 = Link('d',0.1685,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-limit3, limit3]);

L5 = Link('d',0.4,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-limit4, limit4]);

L6 = Link('d',0.1366,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-limit5, limit5]);

L7 = Link('d',0.133,'a',0,'alpha',0,'offset',0, 'qlim', [-limit6, limit6]);
myRobot = SerialLink([L1 L2 L3 L4 L5 L6 L7], 'name', name);

myRobot.plotopt3d = { 'noname', 'nowrist', 'notiles'};
%myRobot.plotopt3d = {'nojoints', 'noname', 'noshadow', 'nowrist', 'notiles'}; %


for linkIndex = 0:myRobot.n
   [ faceData, vertexData, plyData(linkIndex + 1)] = plyread(['j',num2str(linkIndex),'.ply'],'tri');
    myRobot.faces{linkIndex + 1} = faceData;
    myRobot.points{linkIndex + 1} = vertexData;
    
end
 

myRobot.delay = 0;
% Check if there is a robot with this name, otherwise plot one 
if isempty(findobj('Tag', myRobot.name))
    myRobot.base = base_transform;
    myRobot.plot3d([0,0,0,0,0,0,0], 'notiles');
    camlight
end
view([0.5, 0.5 , 0.5]);


myRobot.delay = 0;
handles = findobj('Tag', myRobot.name);
h = get(handles,'UserData'); 
for i = 1:8
     h.link(i).Children.FaceVertexCData = [plyData(i).vertex.red, plyData(i).vertex.green, plyData(i).vertex.blue]/255 ;
     h.link(i).Children.FaceColor = 'interp';
end

hold on;

%ADD SAWYER STAND
hold on;
[f,v,data] = plyread('base_v2.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

base_pose = base_transform;

base_v_size = size(v,1);

new_v = [base_pose * [v, ones(base_v_size,1)]']';

base_mesh = trisurf(f,new_v(:,1),new_v(:,2), new_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

end

