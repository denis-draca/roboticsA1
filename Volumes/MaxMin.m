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

max_x - min_x
max_y - min_y
max_z - min_z

