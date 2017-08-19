function [ specs ] = sawyer_specs( myRobot )

limit0 = (350/2)*pi/180;
limit1 = limit0
limit2 = limit0;
limit3 = limit0;
limit4 = (341/2)*pi/180;
limit5 = limit4;

%sawyer_specs return max reach and volume of the robot in the form
%[max_x, min_x, max_y, min_y, max_z, min_z, volume (m3)]
%   Detailed explanation goes here
angle_change = 30*pi/180;
total_size = uint64((limit0.*2./angle_change) .* (limit1.*2./angle_change) .* (limit2.*2./angle_change) .*(limit3.*2./angle_change).*(limit4.*2./angle_change) .*(limit5.*2./angle_change))
disp('makeing arrays')
x_points = zeros(1,total_size);
y_points = zeros(1,total_size);
z_points = zeros(1,total_size);
disp('done')

current_point = 1;

for j0 = -limit0:angle_change:limit0
    for j1 = -limit1:angle_change:limit1
        for j2 = -limit2:angle_change:limit2
            for j3 = -limit3:angle_change:limit3
                for j4 = -limit4:angle_change:limit4
                    for j5 = -limit5:angle_change:limit5
                        
                            joint_angles = [j0,j1,j2,j3,j4,j5,0];
                            end_transform = myRobot.fkine(joint_angles);
                            x_points(1,current_point) = end_transform(1,4);
                            y_points(1,current_point) = end_transform(2,4);
                            z_points(1,current_point) = end_transform(3,4);
                            
                            current_point = current_point + 1;
                            
                        
                    end
                end
            end
        end
    end
    disp('done')
end

max_x = x_points(1,1);
min_x = x_points(1,1);

for i = 1:length(x_points)
    if x_points(1,i) > max_x
        max_x = x_points(1,i);
    end
    
    if x_points(1,i) < min_x
        min_x = x_points(1,i);
    end
end

max_y = y_points(1,1);
min_y = y_points(1,1);

for i = 1:length(y_points)
    if y_points(1,i) > max_y
        max_y = y_points(1,i);
    end
    
    if y_points(1,i) < min_y
        min_y = y_points(1,i);
    end
end

max_z = z_points(1,1);
min_z = z_points(1,1);

for i = 1:length(z_points)
    if z_points(1,i) > max_z
        max_z = z_points(1,i);
    end
    
    if z_points(1,i) < min_z
        min_z = z_points(1,i);
    end
end

diff_x = max_x - min_x
diff_y = max_y - min_y
diff_z = max_z - min_z

big_sphere_r = diff_x/2;
small_sphere_r = big_sphere_r - (diff_z/2);

big_sphere_vol = (4/3)*pi*big_sphere_r.^2;
small_sphere_vol = (4/3)*small_sphere_r.^2;

total_volume = big_sphere_vol - small_sphere_vol

plot3(x_points, y_points, z_points, '.');

specs = [max_x, min_x, max_y, min_y, max_z, min_z, total_volume];

end

