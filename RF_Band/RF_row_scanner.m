function RF_scanned = RF_row_scanner(radar,space_row,n)
    arguments
        radar (1,1) Radar_properties 
        space_row (1,1) Space_row
        n (1,1) 
    end

    sample_rate = 4 * radar.Carrier;
    stepsize = 1 / sample_rate;
    count = sample_rate / radar.PRF;


    %time = n/radar.PRF:stepsize:(n+1)/radar.PRF;
    %time = time(1,1:count);
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

            reflected_wave = amp * sin(2*pi*(radar.Carrier + frequency)*t - phase);

            tt1 = round(target.distance * radar.Ta * sample_rate);
            tt2 = round((target.distance+1) * radar.Ta * sample_rate);

            RF_scanned_noiseless (1,tt1:tt2) = reflected_wave;
        end
    end

    noise = wgn(1,count,10*log(radar.NoisePower));

    RF_scanned = RF_scanned_noiseless + noise;
    
end