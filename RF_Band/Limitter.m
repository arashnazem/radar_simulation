function output = Limitter(input, threshold)
    arguments
        input (1,:) {mustBeNumeric}
        threshold (1,1) {mustBeNumeric}
    end
    
    for i = 1 : 1 : length(input)
        if abs(input(1,i)) > threshold
            input(1,i) = sign(input(1,i)) * threshold;
        end
    end

    output = input;
end