function mixed = Mixer(input , time , carrier , if_frequency , bandwidth)
    arguments
        input (1,:) {mustBeNumeric}
        time (1,:) {mustBeNumeric}
        carrier (1,1) {mustBeNumeric}
        if_frequency (1,1) {mustBeNumeric}
        bandwidth (1,1) {mustBeNumeric}
    end

    mult = input .* sin(2*pi*(carrier - if_frequency)*time);
    mixed_high = lowpass(mult,bandwidth,4*carrier);
    mixed = mixed_high;
end