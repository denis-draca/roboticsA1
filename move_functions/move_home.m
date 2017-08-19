function [] = move_home( myRobot )

list_of_angles = jtraj(myRobot.getpos, zeros(1,7), 30);%apparently this doesnt work with 7 dof

for i = 1:length(list_of_angles)
    angle = list_of_angles(i , 1:7);
    myRobot.animate(angle);
    drawnow();
    pause(0.01);
    
end

end

