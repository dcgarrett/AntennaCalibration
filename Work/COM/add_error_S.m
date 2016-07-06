function [Sxx] = add_error_S(Sii, magError, argError)

    % convert Re Im to Mag Phase
    S_meas12mag = abs((Sii));
%    S_meas21mag = abs((Sii));
    
    S_meas12arg = angle(Sii);
%    S_meas21arg = angle(Sii);
    
    % adjust according to desired error
    S_meas12mag = S_meas12mag + magError;
%    S_meas21mag = S_meas21mag + magError;
    
    S_meas12arg = S_meas12arg + argError; % in RADIANS
%    S_meas21arg = S_meas21arg + argError;
    
    % convert back to Re Im
    Sxx = S_meas12mag .* exp(1j.*S_meas12arg);
%    Sxx = S_meas21mag .* exp(1j.*S_meas21arg);
    
end