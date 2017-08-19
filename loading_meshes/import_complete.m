function [ complete ] = import_complete( complete_pos )

[f,v,data] = plyread('complete.ply','tri');

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

complete_v_size = size(v,1);

new_v = [complete_pos * [v, ones(complete_v_size,1)]']';

top_mesh = trisurf(f,new_v(:,1),new_v(:,2), new_v(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

complete{1}.mesh = top_mesh;
complete{1}.count = complete_v_size;
complete{1}.verts = v;
end

