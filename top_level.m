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
join_pos = centre*transl(0, 0.1, 0.5);

%% 
pcb = PartLoader('pcb.ply', pcb_pos);
top = PartLoader('housing_top.ply',top_pos);
bottom = PartLoader('housing_bottom.ply', bottom_pos);
table = PartLoader('small_table.ply' ,[pcb_pos,top_pos,bottom_pos]);

world = PartLoader('world3.ply', centre);


%% 
sawyer1 = Sawyer(sawyer_1_pose, 'sawyer1');
sawyer2 = Sawyer(sawyer_2_pose, 'sawyer2');
%% 

if distance_2p(sawyer1.base, top_pos) < distance_2p(sawyer2.base, top_pos)
    
    drop_pos = sawyer_1_pose * transl(0.5,0,0);
    complete_mesh = import_complete(drop_pos);
    
    top_mesh = pick_up_part(top_pos, sawyer1, top_mesh, join_pos);
    pcb_mesh = pick_up_part(pcb_pos, sawyer2, pcb_mesh, join_pos * trotx(pi));
    
    move_home(sawyer2);
    
    bottom_mesh = pick_up_part(bottom_pos, sawyer2, bottom_mesh, join_pos * trotx(pi));
    
    pcb_mesh = move_part(drop_pos, pcb_mesh);
    top_mesh = move_part(drop_pos, top_mesh);
    bottom_mesh = move_part(drop_pos, bottom_mesh);
    
    complete_mesh = move_part(join_pos, complete_mesh);
    
    complete_mesh = move_with_part(sawyer1, complete_mesh, drop_pos);
    
else
    drop_pos = sawyer_2_pose * transl(0.5,0,0);
    complete_mesh = import_complete(drop_pos);
    
    top_mesh = pick_up_part(top_pos, sawyer2, top_mesh,  join_pos);
    pcb_mesh = pick_up_part(pcb_pos, sawyer1, pcb_mesh, join_pos * trotx(pi));
    
    
    move_home(sawyer1);
    
    bottom_mesh = pick_up_part(bottom_pos, sawyer1, bottom_mesh, join_pos * trotx(pi));
    
    pcb_mesh = move_part(drop_pos, pcb_mesh);
    top_mesh = move_part(drop_pos, top_mesh);
    bottom_mesh = move_part(drop_pos, bottom_mesh);
    
    complete_mesh = move_part(join_pos, complete_mesh);
    
    complete_mesh = move_with_part(sawyer2, complete_mesh, drop_pos);
    


%% 



load_environment(centre);

sawyer1 = make_sawyer('sawyer_1', sawyer_1_pose);
sawyer2 = make_sawyer('sawyer_2', sawyer_2_pose);

bottom_mesh = load_bottom(bottom_pos);
top_mesh = load_top(top_pos);
pcb_mesh = load_pcb(pcb_pos);

if distance_2p(sawyer1.base, top_pos) < distance_2p(sawyer2.base, top_pos)
    
    drop_pos = sawyer_1_pose * transl(0.5,0,0);
    complete_mesh = import_complete(drop_pos);
    
    top_mesh = pick_up_part(top_pos, sawyer1, top_mesh, join_pos);
    pcb_mesh = pick_up_part(pcb_pos, sawyer2, pcb_mesh, join_pos * trotx(pi));
    
    move_home(sawyer2);
    
    bottom_mesh = pick_up_part(bottom_pos, sawyer2, bottom_mesh, join_pos * trotx(pi));
    
    pcb_mesh = move_part(drop_pos, pcb_mesh);
    top_mesh = move_part(drop_pos, top_mesh);
    bottom_mesh = move_part(drop_pos, bottom_mesh);
    
    complete_mesh = move_part(join_pos, complete_mesh);
    
    complete_mesh = move_with_part(sawyer1, complete_mesh, drop_pos);
    
else
    drop_pos = sawyer_2_pose * transl(0.5,0,0);
    complete_mesh = import_complete(drop_pos);
    
    top_mesh = pick_up_part(top_pos, sawyer2, top_mesh,  join_pos);
    pcb_mesh = pick_up_part(pcb_pos, sawyer1, pcb_mesh, join_pos * trotx(pi));
    
    
    move_home(sawyer1);
    
    bottom_mesh = pick_up_part(bottom_pos, sawyer1, bottom_mesh, join_pos * trotx(pi));
    
    pcb_mesh = move_part(drop_pos, pcb_mesh);
    top_mesh = move_part(drop_pos, top_mesh);
    bottom_mesh = move_part(drop_pos, bottom_mesh);
    
    complete_mesh = move_part(join_pos, complete_mesh);
    
    complete_mesh = move_with_part(sawyer2, complete_mesh, drop_pos);
    
    
end


%move_home(sawyer1);

