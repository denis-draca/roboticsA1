classdef Sawyer
    %Sawyer Generates physical model of the sawyer and allows for
    %manufacturing control
    %   The Sawyer class does a number of things
    %   Mainly:
    %       Generates sawyer model
    %       Sets the limits and DH parameters
    %       Links ply file models to the appropriate links
    %   Using this, the sawyer class has been designed to perform the
    %   manufacturing task related to our company but can be expanded to
    %   other applications
    %
    %   Constructor inputs:
    %       baseTransform -> location of the sawyer base, the part will be
    %       generated at this location
    %       name -> the name that will be given to the sawyer model
    %
    %
    %   To accomplish these tasks it contains the following Methods:
    %   SawyerVolume:
    %           inputs:
    %               None
    %           Outputs:
    %               volume -> matrix in the form:
    %               [maxX, minX, maxY, minY, maxZ, minZ, totalVolume];
    %                   MaxX - max reachable x position
    %                   minX - min reachable x position
    %                   MaxY - max reachable Y position
    %                   minY - min reachable Y position
    %                   MaxZ - max reachable z position
    %                   minZ - min reachable z position
    %                   totalVolume - working volume of the sawyer
    %       This Method will calculate the working volume of the sawyer
    %       based on the model of the sawyer itself. This is accomplished
    %       by generating a point cloud of possible endefector positions
    %       given 30 degree angle changes for each joint. From that the
    %       volume is approximated by assuming the working volume as a
    %       sphere with a smaller hemisphere cut off from the top and
    %       bottom
    %   ReturnHome:
    %           inputs:
    %               None
    %           Outputs:
    %               None
    %       This simply brings the sawyer back to its home positon, that
    %       is, where all joints are 0
    %   PickUpPart:
    %           inputs:
    %               partMesh -> the object relating to the mesh of the part
    %               that will be picked up
    %               endPose -> Where the mesh will be moved to
    %           Outputs:
    %               newMesh -> updated mesh of the part that was moved
    %       This method will locate the part it needs to pick up (in this
    %       case by recieving the part object as an input) and then moving
    %       the part to the provided join position
    %   DropPart:
    %           inputs:
    %               partMesh -> the object relating to the mesh of the part
    %               that will be dropped off
    %               endPose -> Where the mesh will be moved to
    %           Outputs:
    %               newMesh -> updated mesh of the part that was moved
    %       Given that the sawyer is already holding a part it will then
    %       move that part to the designated drop zone (passed to the
    %       method) and drop the part there
    %   SetSteps:
    %           inputs:
    %               newStepCount -> The amount of steps that each of the
    %               movements will work at
    %           outputs:
    %               none
    %       This sets how many steps will be performed in order to move
    %       from the current position to the desired position
    %   CopyROSBag:
    %           inputs:
    %               bagFile -> location to the bag that the sawyer will
    %               imitate
    %           outputs:
    %               none
    %       Given a ros bag location as an input, the sawyer will then
    %       perform the tasks outlined in the ROS bag.
    %       TuckArm:
    %           inputs:
    %               None
    %           Outputs:
    %               None
    %       This simply brings the sawyer back to its tucked positon.
    
    
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
            
            l1 = Link('d',0.317,'a',-0.081,'alpha',pi/2,'offset',0, ...
            'qlim', [self.limit0, self.limit0], 'offset', pi);

            l2 = Link('d',0.18,'a',0,'alpha',-pi/2,'offset',0,...
            'qlim', [-self.limit1, self.limit1], 'offset', pi/2);

            l3 = Link('d',0.4,'a',0,'alpha',pi/2,'offset',0, ...
            'qlim', [-self.limit2, self.limit2], 'offset', pi);

            l4 = Link('d',0.1685,'a',0,'alpha',-pi/2,'offset',0,...
            'qlim', [-self.limit3, self.limit3]);

            l5 = Link('d',0.4,'a',0,'alpha',pi/2,'offset',0,...
            'qlim', [-self.limit4, self.limit4], 'offset', pi);

            l6 = Link('d',0.1366,'a',0,'alpha',-pi/2,'offset',0,...
            'qlim', [-self.limit5, self.limit5]);

            l7 = Link('d',0.133,'a',0,'alpha',0,'offset',0,...
            'qlim', [-self.limit6, self.limit6]);
            
            self.links = [l1 l2 l3 l4 l5 l6 l7];
            
            self.model = SerialLink(self.links, 'name', name);
            
            
            self.model.plotopt3d = { 'noname', 'nowrist', 'notiles'};

            for linkIndex = 0:self.model.n
               [ faceData, vertexData, plyData(linkIndex + 1)] = ...
               plyread(['j',num2str(linkIndex),'.ply'],'tri');
                self.model.faces{linkIndex + 1} = faceData;
                self.model.points{linkIndex + 1} = vertexData;

            end


            self.model.delay = 0;
            % Check if there is a robot with this name, otherwise plot one 
            if isempty(findobj('Tag', self.model.name))
                self.model.base = baseTransform;
                tuckPose = [0 70 0 137 88.9 -156 0].* pi/180;
                self.model.plot3d(tuckPose, 'notiles');
                camlight
            end
            view([0.5, 0.5 , 0.5]);


            self.model.delay = 0;
            handles = findobj('Tag', self.model.name);
            h = get(handles,'UserData'); 
            for i = 1:8
                 h.link(i).Children.FaceVertexCData = ...
                 [plyData(i).vertex.red, plyData(i).vertex.green,...
                 plyData(i).vertex.blue]/255 ;
                 h.link(i).Children.FaceColor = 'interp';
            end

            hold on;

            %ADD SAWYER STAND
            [face,vertices,data] = plyread('base_v3.ply','tri');

            % Scale the colours to be 0-to-1 (they are originally 0-to-255
            vertexColours = [data.vertex.red, data.vertex.green, ...
                data.vertex.blue] / 255;

            basePose = baseTransform;

            baseVsize = size(vertices,1);

            newV = [basePose * [vertices, ones(baseVsize,1)]']';

            baseMesh = trisurf(face,newV(:,1),newV(:,2), newV(:,3) ...
                ,'FaceVertexCData',vertexColours,'EdgeColor','interp',...
            'EdgeLighting','flat');

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
        
        function CopyROSBag(self, bagFile, step)
            bag = rosbag(bagFile);
            filteredBag = select(bag,'Topic', '/robot/joint_states');
            
            data = readMessages(filteredBag);
            
            for i = 1:step:length(data)
                state = data{i};
                jointStates = state.Position(2:8,1).';
                jointStates(1, 4) = -1*jointStates(1, 4) ;
                
                self.model.animate(jointStates);
                drawnow();
            end
        end
        
        function TuckArm(self)
            tuckPose = [0 70 0 137 88.9 -156 0].* pi/180;
            listOfAngles = jtraj(self.model.getpos, tuckPose , self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);
                drawnow();
                pause(0.01);

            end 
        end
    end    
end

