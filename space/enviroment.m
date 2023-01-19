classdef enviroment
    properties (Constant)
        speedoflihgt {mustBeNumeric} = 3*10^8
    end

    methods (Static)
        function [frequency , phase] =  doppler_calc(carrier , ta , distance, speed)
            arguments
                carrier (1,1) {mustBeNumeric}
                ta (1,1) {mustBeNumeric}
                distance (1,1) {mustBeNumeric} 
                speed (1,1) {mustBeNumeric}
            end

            meterdistance = distance * ta / 2;
            phase = 4 * pi * carrier * meterdistance /enviroment.speedoflihgt;
            frequency = 2*speed*carrier/enviroment.speedoflihgt;
        end

        function distance_in_meter = TaToMeter(ta , distance)
            distance_in_meter = distance * ta * enviroment.speedoflihgt / 2;
        end

        function amp = getampbypower(meterdist , Power , G , Ae , area)
            amp = sqrt(2) * sqrt(Power * G * Ae * area / ((4 * pi * meterdist ^ 2)^2));
        end
    end
end