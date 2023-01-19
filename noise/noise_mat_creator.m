function stack = noise_mat_creator(power , row_count , column_count)
    arguments 
        power (1,1) {mustBeNumeric}
        row_count (1,1) {mustBeNumeric}
        column_count (1,1) {mustBeNumeric}
    end

    stack = zeros(row_count , column_count);

    for i = 1:row_count
        stack(i,:) = wgn(1 , column_count , 10*log(power));
    end

end