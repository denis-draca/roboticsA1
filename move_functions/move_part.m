function [ part_mesh ] = move_part( new_pos, part_mesh )

updatedPoints = [new_pos * [part_mesh{1}.verts,ones(part_mesh{1}.count,1)]']';
    
% Update the mesh vertices in the patch handle
part_mesh{1}.mesh.Vertices = updatedPoints(:,1:3);

drawnow();

end

