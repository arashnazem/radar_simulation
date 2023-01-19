function d = indicator(radar , fig , img_stack ,targets , phi , phi_number , radius_count)
    arguments
        radar(1,1) Radar_target;
        fig(1,1) figure;
        targets
    end

    img = zeros(2*radius_count,2*radius_count);
    zero = radius_count;
    img_stack(phi,:) = targets;
    
end