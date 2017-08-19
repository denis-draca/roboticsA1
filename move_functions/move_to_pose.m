function [] = move_to_pose( end_transform , myRobot)
%move_to_pose end_transform

current_angle = myRobot.getpos();
current_pose = myRobot.fkine(current_angle);

list_of_angles = jtraj(current_angle, myRobot.ikine(end_transform), 30);%apparently this doesnt work with 7 dof

for i = 1:length(list_of_angles)
    angle = list_of_angles(i , 1:7);
    myRobot.animate(angle);
    drawnow();
    pause(0.01);
    
end

