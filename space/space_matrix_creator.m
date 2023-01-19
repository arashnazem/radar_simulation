%this function create the radar scenario , provides whats in radar beam at the time
%sector_count: number of sectors of angle
%radius_count: number of sectors of radius
%radius_step: each radius sector is equal to how much meter
%rotation_frequency: rotation frequency of radar beam in Hertz
%rotation_count : how much this scenario should continue 
%targets : array of space_target provides information about targets
function out =  space_matrix_creator(sector_count , radius_count, radius_step , rotation_frequency , rotation_count, targets)
    arguments
        sector_count (1,1) {mustBeNumeric}
        radius_count (1,1) {mustBeNumeric}
        radius_step (1,1) {mustBeNumeric}
        rotation_frequency (1,1) {mustBeNumeric}
        rotation_count (1,1) {mustBeNumeric}
        targets (1,:) space_target
    end


    delta_t = 1/(rotation_frequency*sector_count);
    delta_phi = 2*pi/sector_count;
    count = rotation_count * sector_count;
    targets_count = length(targets);

    space(1,count) = Space_row;

    for i = 0:count-1
        for j = 1:targets_count
            starg = targets(1,j);
            if i*delta_t > starg.start_time
                starg.active = 1;
                starg.x = starg.x + delta_t * starg.speed_x;
                starg.y = starg.y + delta_t * starg.speed_y;
                r = sqrt(starg.x^2 + starg.y ^2);
                starg.r_sector = round( r / radius_step);
                
                if (starg.r_sector > radius_count)
                    starg.out = 1;
                else
                    starg.out = 0;
                end
                phi = atan(starg.y/starg.x);
                if starg.x < 0
                    phi = phi + pi;
                end
                if starg.x > 0 & starg.y < 0
                    phi = phi + 2*pi; 
                end
                %
                starg.phi_sector = round(phi / 2 / pi * sector_count );
                starg.v_radius = starg.speed_x * cos(phi) + starg.speed_y * sin(phi);
                
                if (starg.is_clutter == 1)
                    starg.v_radius = -starg.clutter_speedwidth + (starg.clutter_speedwidth+starg.clutter_speedwidth)*rand(1,1);
                end
            else
                starg.active = 0;
            end

            targets(1,j) = starg; 
        end

        phi_sec = rem(i,sector_count);
        in_view_count = 0;
        viewed(1,targets_count) = Radar_target;
        
        for j = 1:targets_count
            starg = targets(1,j);
            if starg.phi_sector == phi_sec
                if starg.active == 1 && starg.out == 0
                    targ = Radar_target;
                    targ.area = starg.area;
                    targ.distance = starg.r_sector;
                    targ.speed = starg.v_radius;
                    in_view_count = in_view_count + 1;
                    viewed(1,in_view_count) = targ;
                end
            end
        end

        ss = Space_row;
        ss.target_number = in_view_count;
        ss.targets = viewed(1,1:in_view_count);

        space(1 , i+1) = ss;
    end
    
    out = space;
end