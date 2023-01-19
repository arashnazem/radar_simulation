function sampled = Sampler(input,fs,ta)
    arguments
        input (1,:) {mustBeNumeric}
        fs (1,1) {mustBeNumeric}
        ta (1,1) {mustBeNumeric}
    end

    stepsize = fs * ta;
    sampled = downsample(input, round(ta*fs));

end