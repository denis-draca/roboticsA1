classdef PartLoader
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mesh;
        count;
        verts;
        pose;
    end
    
    methods
        
        function self = PartLoader(fileLocation, position)
            [face,verticies,data] = plyread(fileLocation,'tri');

            % Scale the colours to be 0-to-1 (they are originally 0-to-255
            vertexColours = [data.vertex.red, data.vertex.green, ...
                data.vertex.blue] / 255;
            partVSize = size(verticies,1);
            for i = 1:(length(position)/4)
                s = i*4 - 3; 
                
                pos = position(1:4, s:(s+3));
                
                newV = [pos * [verticies, ones(partVSize,1)]']';

                partMesh = trisurf(face,newV(:,1),newV(:,2), newV(:,3) ...
                    ,'FaceVertexCData',vertexColours,'EdgeColor', ...
                        'interp','EdgeLighting','flat');

                self.mesh = partMesh;
                self.count = partVSize;
                self.verts = verticies;
                self.pose = position;
                
                hold on;
                
            end
        
        end
        
        function MovePart(self, movePos)
            
            updatedPoints = [movePos * [self.verts,ones(self.count,1)]']';
    
            % Update the mesh vertices in the patch handle
            self.mesh.Vertices = updatedPoints(:,1:3);

            drawnow();
            self.pose = movePos;
            
        end
    
    end
end

