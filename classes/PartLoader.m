classdef PartLoader
    %PartLoader Reads a ply file and generates a 3d model, one that
    %can be moved
    %   PartLoader takes a ply file as an input into its constructor and
    %   displays it on screen. If no figure already exists then one will be
    %   created. If a figure does exist then it will be added to that
    %   figure.
    %
    %   Constructor Inputs:
    %       fileLocation -> location of the ply file to be used as
    %       reference to generate the mesh
    %       position -> start location of the mesh
    %
    %   Along with that it allows for simple interaction:
    %   MovePart:
    %       Inputs:
    %           movePos -> end transform of where you want the part moved
    %           to
    %   The Movepart method redraws the already generated mesh to the new
    %   provided location
    
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

