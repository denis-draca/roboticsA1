limit0 = (350/2)*pi/180;
limit1 = limit0;
limit2 = limit0;
limit3 = limit0;
limit4 = (341/2)*pi/180;
limit5 = limit4;
limit6 = (540/2)*pi/180;

L1 = Link('d',0.317,'a',-0.081,'alpha',-pi/2,'offset',0, 'qlim', [-limit0, limit0]);

L2 = Link('d',-0.18,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-limit1, limit1]);

L3 = Link('d',0.4,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-limit2, limit2]);

L4 = Link('d',-0.1685,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-limit3, limit3]);

L5 = Link('d',0.4,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-limit4, limit4]);

L6 = Link('d',-0.1366,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-limit5, limit5]);

L7 = Link('d',0.133,'a',0,'alpha',0,'offset',0, 'qlim', [-limit6, limit6]);
myRobot = SerialLink([L1 L2 L3 L4 L5 L6 L7], 'name', 'sawyer');

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

part_pose = transl(0.3, 0.3, 0);
trplot(part_pose, 'frame', '1', 'color', 'b', 'length' ,1);

%myRobot = pick_up_part(part_pose, myRobot);
%pose2 = [0.3 0.2 0 0 0 0 0];

%move_to_pose(myRobot.fkine(pose2), myRobot);




%move_to_pose(current_pose, myRobot);