function [fundamental_vector,fundamental_amp] = fundamental_frequency(fft_vector,sound_fft)
    i = 1;
    n = 3;
    fundamental_vector = 0;
    fundamental_amp = 0;
    
    for r = (1:length(fft_vector))
        if(sound_fft(r)<80)
            sound_fft(r) = 0;
        end
    end
    
    while(i<2)
       if(sound_fft(n-1)<sound_fft(n) && sound_fft(n)>sound_fft(n+1))
           fundamental_vector = fft_vector(n);
           fundamental_amp = sound_fft(n);
           i = i+1;
       else 
       end
       
       if(n<length(fft_vector))
           n = n+1;
       end
    end


end