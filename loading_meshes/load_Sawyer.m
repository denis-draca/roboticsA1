%% Flying monkey's head from blender
% After saving in blender then load the triangle mesh
[f,v,data] = plyread('sawyer.ply','tri');

% Get vertex count
monkeyVertexCount = size(v,1);

% Move center point to origin
midPoint = sum(v)/monkeyVertexCount;
monkeyVerts = v - repmat(midPoint,monkeyVertexCount,1);

% Create a transform to describe the location (at the origin, since it's centered
monkeyPose = eye(4);

% Scale the colours to be 0-to-1 (they are originally 0-to-255
vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

% Then plot the trisurf
monkeyMesh_h = trisurf(f,monkeyVerts(:,1),monkeyVerts(:,2), monkeyVerts(:,3) ...
    ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
