function [ part_mesh] = pick_up_part( part_pose, myRobot, part_mesh, end_pos )

move_pose = part_pose * trotx(pi);

list_of_angles = jtraj(myRobot.getpos, myRobot.ikine(move_pose), 30);%apparently this doesnt work with 7 dof

for i = 1:length(list_of_angles)
    angle = list_of_angles(i , 1:7);
    myRobot.animate(angle);
    drawnow();

end

list_of_angles = jtraj(myRobot.getpos, myRobot.ikine(end_pos), 30);

for i = 1:length(list_of_angles)
    angle = list_of_angles(i , 1:7);
    myRobot.animate(angle);
    
    current_transform = myRobot.fkine(angle);
    
    part_mesh = move_part(current_transform, part_mesh);
    
    drawnow();
    
end

end

