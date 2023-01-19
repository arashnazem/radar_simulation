function out = MTI(In) 
    arguments
        In(:,:) {mustBeNumeric}
    end

    [row_count column_count] = size(In);
    
    out = zeros(row_count-1,column_count);
    
    for i=1:row_count - 1 
        out(i,:) = In(i+1,:) - In(i,:); 
    end
end