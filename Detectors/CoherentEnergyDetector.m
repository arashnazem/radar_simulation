function det = CoherentEnergyDetector(I,Q,th)
    arguments 
        I(1,:) {mustBeNumeric}
        Q(1,:) {mustBeNumeric}
        th(1,1) {mustBeNumeric}
    end 
    
    det = zeros(1,length(I));

    for i = 1:length(I)
        if sqrt(I(1,i)^2 + Q(1,i)^2) > th
            det(1,i) = 1;
        end 
    end

end