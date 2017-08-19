function [ dist ] = Distance2p( pose1, pose2 )

pose = inv(pose2)*pose1;

dist = sqrt(pose(1,4).^2 + pose(2,4).^2 + pose(3,4).^2);


end

