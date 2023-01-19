function Q = Quad(radar , IF_row , n , sin_wave) 
    arguments
        radar (1,1) Radar_properties
        IF_row (1,:) {mustBeNumeric}
        n(1,1) {mustBeNumeric}
        sin_wave (1,:) {mustBeNumeric}
    end
    %t = 0/radar.PRF:1/(radar.sample_rate):((0+1)/radar.PRF-1/(radar.sample_rate));
    %sin_wave = cos(2*pi*radar.IF_Frequency*t + pi/4);


    Q = sin_wave .* IF_row;
    %Q = lowpass(Q , 1.5*radar.IF_Frequency , 4 * radar.IF_Frequency);
    Q = filter([1 1 0],[1 0 0],Q);
end