classdef  space_target
    properties
        name
        active
        start_time {mustBeNumeric} = 0
        x {mustBeNumeric}
        y {mustBeNumeric}
        speed_x {mustBeNumeric}
        speed_y {mustBeNumeric}
        area {mustBeNumeric}
        out = 0
        phi_sector {mustBeNumeric} = 0
        r_sector {mustBeNumeric} = 0
        v_radius {mustBeNumeric} = 0
        is_clutter {mustBeNumeric} = 0
        clutter_speedwidth {mustBeNumeric} = 0
    end
end