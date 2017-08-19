%% 
clear;
clc;
startup_rvc;
%% 
% START These will change on the day
sawyer_1_pose = transl(0.6, 0 , 0) ;
sawyer_2_pose = transl(-0.6, 0 , 0) ;

pcb_pos = transl(-0.3, 0.4, 0);
bottom_pos = transl(0, 0.4, 0);
top_pos = transl(0.3, 0.4, 0);
%END
%% 

x1 = sawyer_1_pose(1,4);
y1 = sawyer_1_pose(2,4);
x2 = sawyer_2_pose(1,4);
y2 = sawyer_2_pose(2,4);

centre = transl((x1+x2)/2, (y1 + y2), 0);
joinPos = centre*transl(0, 0.1, 0.5);

%% 
pcbMesh = PartLoader('pcb.ply', pcb_pos);
topMesh = PartLoader('housing_top.ply',top_pos);
bottomMesh = PartLoader('housing_bottom.ply', bottom_pos);
tableMesh = PartLoader('small_table.ply' ,[pcb_pos,top_pos,bottom_pos]);

worldMesh = PartLoader('world3.ply', centre);

dropPose = centre;
chuteMesh = PartLoader('chute.ply', dropPose);
completeMesh = PartLoader('complete.ply', dropPose);
%% 
sawyer1 = Sawyer(sawyer_1_pose, 'sawyer1');
sawyer2 = Sawyer(sawyer_2_pose, 'sawyer2');
%% reset part poses

pcbMesh.MovePart(pcb_pos);
topMesh.MovePart(top_pos);
bottomMesh.MovePart(bottom_pos);

completeMesh.MovePart(dropPose);
%% 

if Distance2p(sawyer1.model.base, top_pos) < Distance2p(sawyer2.model.base, top_pos)
    
    topMesh = sawyer1.PickUpPart(topMesh, joinPos);
    pcbMesh = sawyer2.PickUpPart(pcbMesh, joinPos * trotx(pi));
    
    sawyer2.ReturnHome;
    
    bottomMesh = sawyer2.PickUpPart(bottomMesh, joinPos * trotx(pi));
    
    pcbMesh.MovePart(dropPose);
    topMesh.MovePart(dropPose);
    bottomMesh.MovePart(dropPose);
    
    completeMesh.MovePart(joinPos);
    completeMesh = sawyer1.DropPart(completeMesh, dropPose);
    
else
    topMesh = sawyer2.PickUpPart(topMesh, joinPos);
    pcbMesh = sawyer1.PickUpPart(pcbMesh, joinPos * trotx(pi));
    
    sawyer2.ReturnHome;
    
    bottomMesh = sawyer1.PickUpPart(bottomMesh, joinPos * trotx(pi));
    
    pcbMesh.MovePart(dropPose);
    topMesh.MovePart(dropPose);
    bottomMesh.MovePart(dropPose);
    
    completeMesh.MovePart(joinPos);
    completeMesh = sawyer2.DropPart(completeMesh, dropPose);
    
    
end
%% imitate rosBag
sawyer1 = Sawyer(transl(0,0,0), 's');
bag1Path = '2017-07-04-23-03-07.bag';

sawyer1.CopyROSBag(bag1Path);





