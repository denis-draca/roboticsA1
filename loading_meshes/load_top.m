function [complete ] = load_top( top_pos )
%ADD table
[f,v,data] = plyread('small_table.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

table_pose = top_pos;

table_v_size = size(v,1);

table_v = [table_pose * [v, ones(table_v_size,1)]']';

table_mesh = trisurf(f,table_v(:,1),table_v(:,2), table_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');



[f,v,data] = plyread('housing_top.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

top_v_size = size(v,1);

new_v = [top_pos * [v, ones(top_v_size,1)]']';

top_mesh = trisurf(f,new_v(:,1),new_v(:,2), new_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

complete{1}.mesh = top_mesh;
complete{1}.count = top_v_size;
complete{1}.verts = v;

end

