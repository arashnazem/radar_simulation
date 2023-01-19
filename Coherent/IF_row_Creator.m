function IF_row = IF_row_Creator(radar,space_row,n,noise)
    arguments
        radar (1,1) Radar_properties 
        space_row (1,1) Space_row
        n (1,1) {mustBeNumeric}
        noise (1,:) {mustBeNumeric}
    end

    sample_rate = radar.sample_rate;
    stepsize = 1 / sample_rate;
    count = sample_rate / radar.PRF;


    RF_scanned_noiseless = zeros(1 , count);

    if space_row.target_number ~= 0
        for i = 1:space_row.target_number
            target = space_row.targets(1,i);
            t1 = target.distance * radar.Ta + n/radar.PRF;
            t2 = (target.distance + 1) * radar.Ta + n/radar.PRF;
            t = t1:stepsize:t2;

            [frequency , phase] = enviroment.doppler_calc(radar.Carrier , radar.Ta , target.distance, target.speed);

            metdist = enviroment.TaToMeter(radar.Ta , target.distance);
            amp = enviroment.getampbypower(metdist , radar.Power , radar.G , radar.Ae , target.area);

            reflected_wave = amp * sin(2*pi*(radar.IF_Frequency + frequency)*t - phase);
            

            tt1 = round(target.distance * radar.Ta * sample_rate);
            tt2 = round((target.distance+1) * radar.Ta * sample_rate);

            RF_scanned_noiseless (1,tt1:tt2) = reflected_wave;
        end
    end
    
    %just for test
    if length(RF_scanned_noiseless) ~= length(noise)
       RF_scanned_noiseless = RF_scanned_noiseless(1,1:length(noise));
    end

    IF_row = RF_scanned_noiseless + noise;
    
end