function [S_meas, Thru, Refl] = adjust_for_added_error(S_meas, Thru, Refl, p)

S_meas(1,2,:) = add_error_S(squeeze(S_meas(1,2,:)), p.Results.errorMUTS21abs, p.Results.errorMUTS21arg);
S_meas(2,1,:) = add_error_S(squeeze(S_meas(2,1,:)), p.Results.errorMUTS21abs, p.Results.errorMUTS21arg);
S_meas(1,1,:) = add_error_S(squeeze(S_meas(1,1,:)), p.Results.errorMUTS11abs, p.Results.errorMUTS11arg);
S_meas(2,2,:) = add_error_S(squeeze(S_meas(2,2,:)), p.Results.errorMUTS11abs, p.Results.errorMUTS11arg);

Thru(1,2,:) = add_error_S(squeeze(Thru(1,2,:)), p.Results.errorThruS21abs, p.Results.errorThruS21arg);
Thru(2,1,:) = add_error_S(squeeze(Thru(2,1,:)), p.Results.errorThruS21abs, p.Results.errorThruS21arg);
Thru(1,1,:) = add_error_S(squeeze(Thru(1,1,:)), p.Results.errorThruS11abs, p.Results.errorThruS11arg);
Thru(2,2,:) = add_error_S(squeeze(Thru(2,2,:)), p.Results.errorThruS11abs, p.Results.errorThruS11arg);

Refl(1,2,:) = add_error_S(squeeze(Refl(1,2,:)), p.Results.errorReflS21abs, p.Results.errorReflS21arg);
Refl(2,1,:) = add_error_S(squeeze(Refl(2,1,:)), p.Results.errorReflS21abs, p.Results.errorReflS21arg);
Refl(1,1,:) = add_error_S(squeeze(Refl(1,1,:)), p.Results.errorReflS11abs, p.Results.errorReflS11arg);
Refl(2,2,:) = add_error_S(squeeze(Refl(2,2,:)), p.Results.errorReflS11abs, p.Results.errorReflS11arg);
    
end