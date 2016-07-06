function [ er, cond ] = material_database( f, name, type )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
switch type
    case 'Debye'
        switch name
            case 'Group 1'
                er_inf = 7.821;
                sig_stat = 0.713;
                tau = 1.066e-11;
                er_stat = 49.301;
            case 'Group 2'
                er_inf = 5.573;
                sig_stat = 0.524;
                tau = 9.149e-12;
                er_stat = 40.143;
            case 'Group 3'
                er_inf = 3.14;
                sig_stat = 0.036;
                tau = 1.465e-11;
                er_stat = 12.289;
            case 'er30dispersive'
                er_inf = 15;
                sig_stat = 0;
                tau = 2e-11;
                er_stat = 30;
            case 'Triton100'
                er_inf = 2.8689;
                sig_stat = 0.0049;
                tau = 48.157e-12;
                er_stat = 4.6978;
            case 'Triton40'
                er_inf = 10.3892;
                sig_stat = 0.0577;
                tau = 26.242e-12;
                er_stat = 39.3659;
            case 'Triton30'
                er_inf = 13.4393;
                sig_stat = 0.067;
                tau = 24.395e-12;
                er_stat = 47.7651;
        end
        
        [er, cond] = debye(f, er_stat, er_inf, sig_stat, tau);
    
    case 'Cole-Cole'
        switch name
            case 'Group 1'
                er_inf = 7.821;
                sig_stat = 0.713;
                tau = 1.066e-11;
                er_stat = er_inf + 41.48;
                alpha = 0.047;
            case 'Group 2'
                er_inf = 5.573;
                sig_stat = 0.524;
                tau = 9.149e-12;
                er_stat = er_inf + 34.57;
                alpha = 0.095;
            case 'Group 3'
                er_inf = 3.14;
                sig_stat = 0.036;
                tau = 1.465e-11;
                er_stat = er_inf + 1.708;
                alpha = 0.061;
        end
        
        [er, cond] = GenerateMultiPoleColeColeData(f, er_inf, sig_stat, er_stat, tau, alpha);
end



end

