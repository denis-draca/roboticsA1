function [ complete ] = load_bottom( bottom_pos )

%ADD table
[f,v,data] = plyread('small_table.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

table_pose = bottom_pos;

table_v_size = size(v,1);

table_v = [table_pose * [v, ones(table_v_size,1)]']';

table_mesh = trisurf(f,table_v(:,1),table_v(:,2), table_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');


[f,v,data] = plyread('housing_bottom.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

bottom_v_size = size(v,1);

new_v = [bottom_pos * [v, ones(bottom_v_size,1)]']';

bottom_mesh = trisurf(f,new_v(:,1),new_v(:,2), new_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

complete{1}.mesh = bottom_mesh;
complete{1}.count = bottom_v_size;
complete{1}.verts = v;

end

