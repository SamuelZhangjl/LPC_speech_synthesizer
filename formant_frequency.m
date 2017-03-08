function [formant_vector,formant_amp] = formant_frequency(f_vector,fdb_response,order)
    i = 1;
    n = 3;
    formant_vector = zeros(1,order);
    formant_amp = zeros(1,order);
    while(i<=order)
       if(fdb_response(n-1)<fdb_response(n) && fdb_response(n)>fdb_response(n+1))
           formant_vector(i) = f_vector(n);
           formant_amp(i) = fdb_response(n);
           i = i+1;
       else 
       end
       
       if(n<length(f_vector))
           n = n+1;
       end
       
    end
end