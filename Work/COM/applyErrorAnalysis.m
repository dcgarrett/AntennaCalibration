function [ deps_dparam, dsig_dparam ] = applyErrorAnalysis( param, param_array, deltaParam, fileName, filePath, fcent, simOrMeas, plotOption )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% param: str:   -S11, S21, S12, S22; T11, T21, T12, T22; R11, R21, R12,
%                R22, len
% param_array:  -array of the parameter values around which to determine
%               the partial derivative
for i = 1:length(param_array)
    [f, epsEst(i,:), sigEst(i,:), ~, ~, ~, ~, ~] = MAIN_GRL_Calibration(filePath, fileName, measLength, simOrMeas,'GRL_plot',0,'DP_plot',0,'fcent',fcent,param,param_array(i));
end

deps_dparam = (epsEst(2:end,:) - epsEst(1:end-1, :)) ./ (param_array(2) - param_array(1));
for i = 1:length(f)-1
    avg_deps_dparam(i) = mean(deps_dparam(:,i));
end


if plotOption
    figure;
    hold on;
    plot(param_array, epsEst(:,500))
    xlabel(param)
    ylabel(['Estimated permittivity at ',num2str(f_sim(500)/1e9),'GHz'])
    box on;
    
    figure;
    hold on;
    plot(param_array, sigEst(:,500))
    xlabel(param)
    ylabel(['Estimated conductivity at ',num2str(f_sim(500)/1e9),'GHz'])

    figure;
    hold on;
    plot(f(2:end),avg_deps_dparam .* deltaS21mag)
    xlabel('Frequency')
    ylabel(['(dEps/dS21mag) * ', num2str(deltaParam)])
    xlim([3e9 8e9])
    box on;
    
    figure;
    hold on;
    plot(f(2:end),avg_dsig_dparam .* deltaParam)
    xlabel('Frequency')
    ylabel(['(dSig/dS21mag) * ', num2str(deltaParam)])
    xlim([3e9 8e9])
    box on;
end
end

