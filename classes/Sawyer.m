% ======================================================================
%> @brief Sawyer Generates physical model of the sawyer and allows for
%>         manufacturing control
%
%> %   The Sawyer class does a number of things
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
% ======================================================================

classdef Sawyer
    
    properties
        %> The absolute limit of joint 0
        limit0 
        %> The absolute limit of joint 1
        limit1 
        %> The absolute limit of joint 2
        limit2 
        %> The absolute limit of joint 3
        limit3 
        %> The absolute limit of joint 4
        limit4
        %> The absolute limit of joint 5
        limit5 
        %> The absolute limit of joint 6
        limit6
        
        %> The sawyer model itself
        model;
        %> List of links and their parameters
        links;
        %> The name given to the sawyer arm
        modelName;
        
        %> The amount of steps that each of the animations will work at
        %this can be changed later
        steps = 30;
        
        %> logger file
        logger;
        
    end
    
    methods
    % ======================================================================
    %> @brief Class constructor
    %>
    %> Builds the sawyer model itself and the stand that it will sit on.
    %>This model will be lined up to fit with the given transform
    %>
    %> @param baseTransform where the sawyer is to sit
    %> @param name the name of the sawyer arm
    %>
    %> @return instance of the Sawyer class.
    % ======================================================================
        function  self = Sawyer(baseTransform, name, logObject)
            self.logger = logObject;
            self.modelName = name;
            
            self.logger.mlog = {self.logger.DEBUG, 'Sawyer', ...
                ['Sawyer Init ', name]};
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
                
                self.logger.mlog = {self.logger.DEBUG, 'Sawyer', ...
                [name, ' init pose: ', ....
                self.logger.MatrixToString(baseTransform)]};
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
    % ======================================================================
    %> @brief SawyerVolume generates a point cloud of possible endefector
    %>positions. From this it calculates the working volume of the sawyer
    %>itself and returns the results.
    %>
    %> @retval volume the volume of the sawyer workspace in the form :
    %> [maxX, minX, maxY, minY, maxZ, minZ, totalVolume];
    %>                   MaxX - max reachable x position
    %>                   minX - min reachable x position
    %>                   MaxY - max reachable Y position
    %>                   minY - min reachable Y position
    %>                   MaxZ - max reachable z position
    %>                  minZ - min reachable z position
    %>                   totalVolume - working volume of the sawyer
    % ======================================================================     
        function volume = SawyerVolume(self)
            self.logger.mlog = {self.logger.DEBUG, 'Sawyer.Volume', ...
                'finding volume'};
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

                            jointAngles = [j0,j1,j2,j3,0,0,0];
                            endTransform = self.model.fkine(jointAngles);
                            xPoints(1,currentPoint) = endTransform(1,4);
                            yPoints(1,currentPoint) = endTransform(2,4);
                            zPoints(1,currentPoint) = endTransform(3,4);

                            currentPoint = currentPoint + 1;
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
            hold on;
            plot3(xPoints, yPoints, zPoints, '.');

            volume = [maxX, minX, maxY, minY, maxZ, minZ, totalVolume];

        end
    % ======================================================================
    %> @brief ReturnHome returns the robot to a position where all the
    %>joints have an angle of 0
    %>
    % ======================================================================   
        function ReturnHome(self)
            listOfAngles = jtraj(self.model.getpos, zeros(1,7), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                
                currentPose = self.model.fkine(angle);
                
                self.logger.mlog = {self.logger.DEBUG, 'Sawyer.ReturnHome', ...
                                        ['current end pose ', ...
                                        self.logger.MatrixToString...
                                        (currentPose)]};
                
                self.model.animate(angle);
                drawnow();
                pause(0.01);

            end 
        end
        
    % ======================================================================
    %> @brief PickUpPart picks up the part pertaining to the given part
    %>mesh, this part will be then brought to the given position
    %>
    %> @param partMesh A PartLoader object containing the mesh that will be
    %>transported
    %> @param endPose the transform of the location that the part will be
    %> brought to 
    %> @retval newMesh returns the modified PartLoader object
    % ======================================================================
        function newMesh = PickUpPart(self, partMesh, endPose)
           
            waypoint = partMesh.pose * transl(0,0,0.2) * trotx(pi);
            
            listOfAngles = jtraj(self.model.getpos, ...
            self.model.ikine(waypoint), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                
                currentPose = self.model.fkine(angle);
                
                self.logger.mlog = {self.logger.DEBUG, 'Sawyer.PickUpPart', ...
                                [self.modelName, ' current end pose ', ...
                                self.logger.MatrixToString(currentPose)]};
                
                self.model.animate(angle);
                drawnow();

            end
            
            
            movePose = partMesh.pose * trotx(pi);

            listOfAngles = jtraj(self.model.getpos, ...
            self.model.ikine(movePose), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                
                currentPose = self.model.fkine(angle);
                
                self.logger.mlog = {self.logger.DEBUG, 'Sawyer.PickUpPart', ...
                                [self.modelName, ' current end pose ', ...
                                self.logger.MatrixToString(currentPose)]};
                
                self.model.animate(angle);
                drawnow();

            end

            listOfAngles = jtraj(self.model.getpos, self.model.ikine(endPose),... 
            self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);

                currentTransform = self.model.fkine(angle);
                
                self.logger.mlog = {self.logger.DEBUG, 'Sawyer.PickUpPart', ...
                                [self.modelName, ' current end pose ', ...
                                self.logger.MatrixToString(currentTransform)]};

                partMesh.MovePart(currentTransform);

                drawnow();

            end
            
            newMesh = partMesh;
            
        end
   % ======================================================================
    %> @brief DropPart drops the part pertaining to the given part
    %>mesh, this part will be brought to the given position
    %>
    %> @param partMesh A PartLoader object containing the mesh that will be
    %>transported
    %> @param endPose the transform of the location that the part will be
    %> brought to 
    %> @retval newMesh returns the modified PartLoader object
    % ======================================================================  
        function newMesh = DropPart(self, partMesh, endPose)
            
            movePose = endPose * trotx(pi);

            listOfAngles = jtraj(self.model.getpos, ...
            self.model.ikine(movePose), self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);
                currentTransform = self.model.fkine(angle);

                self.logger.mlog = {self.logger.DEBUG, 'Sawyer.PickUpPart', ...
                [self.modelName, ' current end pose ', ...
                self.logger.MatrixToString(currentTransform)]};
            
                partMesh.MovePart(currentTransform);
                drawnow();

            end 
            
            newMesh = partMesh;
        end
    % ======================================================================
    %> @brief SetSteps Sets the amount of steps to take between 2
    %>consecutive poses
    %>
    %> @param newStepCount The new step amount
    % ======================================================================    
        function SetSteps(self, newStepCount)
            self.steps = newStepCount;
        end
    % ======================================================================
    %> @brief CopyROSBag this method takes a rosbag location and imitates
    %>the joint positions recorded within it
    %>
    %> @param bagFile location of the rosbag with the .bag suffix
    %> @param step how fast to iterate through the bag (1 step will do each
    %>individual pose, 2 will do every second etc)
    % ======================================================================    
        function CopyROSBag(self, bagFile, step)
            try
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
            catch ERROR
                disp("ERROR WITH EXECUTING ROS IMITATE");
                ERROR
            end
        end
    % ======================================================================
    %> @brief TuckArm Brings the arm to a tucked position
    %>
    % ======================================================================    
        function TuckArm(self)
            tuckPose = [0 70 0 137 88.9 -156 0].* pi/180;
            listOfAngles = jtraj(self.model.getpos, tuckPose , self.steps);

            for i = 1:length(listOfAngles)
                angle = listOfAngles(i , 1:7);
                self.model.animate(angle);
                
                currentPose = self.model.fkine(angle);
                
                self.logger.mlog = {self.logger.DEBUG, 'Sawyer.TuckArm', ...
                [self.modelName ' current end pose ', ...
                self.logger.MatrixToString(currentPose)]};
                
                drawnow();
                pause(0.01);

            end 
        end
        
        function endPose = EndEffectorLocation(self)
            endPose = self.model.fkine(self.model.getpos);
        end
    end    
end
