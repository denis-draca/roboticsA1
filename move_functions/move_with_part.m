function [ part_mesh ] = move_with_part( myRobot, part_mesh, end_pose )

list_of_angles = jtraj(myRobot.getpos, myRobot.ikine(end_pose * trotx(pi)), 50);%apparently this doesnt work with 7 dof

for i = 1:length(list_of_angles)
    angle = list_of_angles(i , 1:7);
    myRobot.animate(angle);
    current_transform = myRobot.fkine(angle);
    
    part_mesh = move_part(current_transform, part_mesh);
    drawnow();

end
end

