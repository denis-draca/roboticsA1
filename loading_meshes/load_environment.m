function [ ] = load_environment( base_transform )
%Sets up the environment
%   Detailed explanation goes here

hold on;
%ADD FACTORY
[f,v,data] = plyread('world3.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

world_pose = base_transform;

world_v_size = size(v,1);

world_v = [world_pose * [v, ones(world_v_size,1)]']';

world_mesh = trisurf(f,world_v(:,1),world_v(:,2), world_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

end

