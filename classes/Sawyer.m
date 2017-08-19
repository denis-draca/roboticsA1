classdef Sawyer
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        limit0 
        limit1 
        limit2 
        limit3 
        limit4
        limit5 
        limit6
        
        model;
        links;
        modelName;
        
        steps = 30;
        
    end
    
    methods
        function  self = Sawyer(baseTransform, name)
            hold on;
            self.limit0 = (350/2)*pi/180;
            self.limit1 = self.limit0;
            self.limit2 = self.limit0;
            self.limit3 = self.limit0;
            self.limit4 = (341/2)*pi/180;
            self.limit5 = self.limit4;
            self.limit6 = (540/2)*pi/180;
            
            l1 = Link('d',0.317,'a',-0.081,'alpha',pi/2,'offset',0, 'qlim', [self.limit0, self.limit0]);

            l2 = Link('d',0.18,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-self.limit1, self.limit1]);

            l3 = Link('d',0.4,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-self.limit2, self.limit2]);

            l4 = Link('d',0.1685,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-self.limit3, self.limit3]);

            l5 = Link('d',0.4,'a',0,'alpha',pi/2,'offset',0, 'qlim', [-self.limit4, self.limit4]);

            l6 = Link('d',0.1366,'a',0,'alpha',-pi/2,'offset',0, 'qlim', [-self.limit5, self.limit5]);

            l7 = Link('d',0.133,'a',0,'alpha',0,'offset',0, 'qlim', [-self.limit6, self.limit6]);
            
            self.links = [l1 l2 l3 l4 l5 l6 l7];
            
            self.model = SerialLink(self.links, 'name', name);
            
            
            self.model.plotopt3d = { 'noname', 'nowrist', 'notiles'};

            for linkIndex = 0:self.model.n
               [ faceData, vertexData, plyData(linkIndex + 1)] = plyread(['j',num2str(linkIndex),'.ply'],'tri');
                self.model.faces{linkIndex + 1} = faceData;
                self.model.points{linkIndex + 1} = vertexData;

            end


            self.model.delay = 0;
            % Check if there is a robot with this name, otherwise plot one 
            if isempty(findobj('Tag', self.model.name))
                self.model.base = baseTransform;
                self.model.plot3d([0,0,0,0,0,0,0], 'notiles');
                camlight
            end
            view([0.5, 0.5 , 0.5]);


            self.model.delay = 0;
            handles = findobj('Tag', self.model.name);
            h = get(handles,'UserData'); 
            for i = 1:8
                 h.link(i).Children.FaceVertexCData = [plyData(i).vertex.red, plyData(i).vertex.green, plyData(i).vertex.blue]/255 ;
                 h.link(i).Children.FaceColor = 'interp';
            end

            hold on;

            %ADD SAWYER STAND
            [face,vertices,data] = plyread('base_v3.ply','tri');

            % Scale the colours to be 0-to-1 (they are originally 0-to-255
            vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;

            basePose = baseTransform;

            baseVsize = size(vertices,1);

            newV = [basePose * [vertices, ones(baseVsize,1)]']';

            baseMesh = trisurf(face,newV(:,1),newV(:,2), newV(:,3) ...
                ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');

        end
            
        function volume = SawyerVolume(self)
            angleChange = 30*pi/180;
            totalSize = uint64((self.limit0.*2./angleChange) .* ...
            (self.limit1.*2./angleChange) .* (self.limit2.*2./angleChange) .*...
            (self.limit3.*2./angleChange).*(self.limit4.*2./angleChange) .* ...
            (self.limit5.*2./angleChange));
        
            disp('makeing arrays')
            xPoints = zeros(1,totalSize);
            yPoints = zeros(1,totalSize);
            zPoints = zeros(1,totalSize);
            disp('done')

            currentPoint = 1;

            for j0 = -self.limit0:angleChange:self.limit0
                for j1 = -self.limit1:angleChange:self.limit1
                    for j2 = -self.limit2:angleChange:self.limit2
                        for j3 = -self.limit3:angleChange:self.limit3
                            for j4 = -self.limit4:angleChange:self.limit4
                                for j5 = -self.limit5:angleChange:self.limit5

                                        jointAngles = [j0,j1,j2,j3,j4,j5,0];
                                        endTransform = self.model.fkine(jointAngles);
                                        xPoints(1,currentPoint) = endTransform(1,4);
                                        yPoints(1,currentPoint) = endTransform(2,4);
                                        zPoints(1,currentPoint) = endTransform(3,4);

                                        currentPoint = currentPoint + 1;


                                end
                            end
                        end
                    end
                end
                disp('done')
            end

            maxX = xPoints(1,1);
            minX = xPoints(1,1);

            for i = 1:length(xPoints)
                if xPoints(1,i) > maxX
                    maxX = xPoints(1,i);
                end

                if xPoints(1,i) < minX
                    minX = xPoints(1,i);
                end
            end

            maxY = yPoints(1,1);
            minY = yPoints(1,1);

            for i = 1:length(yPoints)
                if yPoints(1,i) > maxY
                    maxY = yPoints(1,i);
                end

                if yPoints(1,i) < minY
                    minY = yPoints(1,i);
                end
            end

            maxZ = zPoints(1,1);
            minZ = zPoints(1,1);

            for i = 1:length(zPoints)
                if zPoints(1,i) > maxZ
                    maxZ = zPoints(1,i);
                end

                if zPoints(1,i) < minZ
                    minZ = zPoints(1,i);
                end
            end

            diffX = maxX - minX
            diffY = maxY - minY
            diffZ = maxZ - minZ

            bigSphere_r = diffX/2;
            smallSphere_r = bigSphere_r - (diffZ/2);

            bigSphereVol = (4/3)*pi*bigSphere_r.^2;
            smallSphereVol = (4/3)*smallSphere_r.^2;

            totalVolume = bigSphereVol - smallSphereVol

            plot3(xPoints, yPoints, zPoints, '.');

            volume = [maxX, minX, maxY, minY, maxZ, minZ, totalVolume];

        end
        
        function ReturnHome(self)
            listOfAngles = jtraj(self.model.getpos, zeros(1,7), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);
                drawnow();
                pause(0.01);

            end 
        end
        
        function newMesh = PickUpPart(self, partMesh, endPose)
           
            movePose = partMesh.pose * trotx(pi);

            listOfAngles = jtraj(self.model.getpos, ...
            self.model.ikine(movePose), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);
                drawnow();

            end

            listOfAngles = jtraj(self.model.getpos, self.model.ikine(endPose),... 
            self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);

                currentTransform = self.model.fkine(angle);

                partMesh.MovePart(currentTransform);

                drawnow();

            end
            
            newMesh = partMesh;
            
        end
        
        function newMesh = DropPart(self, partMesh, endPose)
            
            movePose = endPose * trotx(pi);

            listOfAngles = jtraj(self.model.getpos, ...
            self.model.ikine(movePose), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);
                currentTransform = self.model.fkine(angle);

                partMesh.MovePart(currentTransform);
                drawnow();

            end 
            
            newMesh = partMesh;
        end
        
        function SetSteps(self, newStepCount)
            self.steps = newStepCount;
        end
        
        function CopyROSBag(self, bagFile)
            
        end
        
    end    
end

