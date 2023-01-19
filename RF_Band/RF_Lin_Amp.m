function output = RF_Lin_Amp(input, gain)
    arguments
        input (1,:) {mustBeNumeric}
        gain (1,1) {mustBeNumeric}
    end

    for i = 1:length(input)
        input(1,i) = i * input(1,i) * gain;
    end

    output = input;

end