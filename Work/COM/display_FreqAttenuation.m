function output  = display_FreqAttenuation(scan, path, params )
    ColorSet={[0 0 0],[0.1137 0.2392 0.7686],[1 0.4 0.2],[0.4 1 0.4],[1 1 0],[0.5 0.5 0.5]};
% Plot the attenuation in dB/cm
   if isfield(params, 'ind_path')
        % parameter exist do not do anything
   else
        % plot all path signals
        params.ind_path=1:length(path.ind_signal);
   end
   
   switch scan.ScanInfo.source
       case 'TSAR_TransmissionMeasurement_2'
            %attenuation of antenna calculated previously (measured)
           freq=scan.Signal{1}.sig_var;
           p1 = -1.525e-19;
           p2 = 5.623e-10;
           p3 = -8.11;
           TransAntenna_dB=p1*freq.^2+p2*freq+p3;
           
       case 'SEMCAD-X'
           % attenuation of antenna calculated previously (Simulated)
           freq=scan.Signal{1}.sig_var;
           p1 = -1.189e-20;
           p2 = -1.264e-09;
           p3 = -2.885 ;
           TransAntenna_dB=p1*freq.^2+p2*freq+p3;
   end
   % Parameter for curve fitting to compensate gain variation over frequency (GFP)
  % | er | p1 | p2 | p3 |
  GFP= [   5 -2.269e-19 3.457e-09 -25 ;...
           10 -2.511e-19 3.701e-09  -20 ;...
           20 -2.513e-19 3.554e-09 -16.5 ;...
           30 -3.162e-19 4.349e-09 -16;...
           50 -2.79e-19  4.031e-09 -14  ;... 
           80 -2.914e-19 4.069e-09  -10 ];
   
   
   er_list=params.er;
%  figure('Color',[1 1 1]),
    hold on,grid on,box on

   xlabel('Frequency (GHz)');
   ylabel('Attenuation (dB/cm)');
   % Get the indices of the first signal
   ind1=path.ind_signal(1);
   mean_attenuation=zeros(length(scan.Signal{ind1}.sig_var),1);
   % Select the Frequency to Plot
   freqstop = params.freqstop;
   freqstart = params.freqstart; 
   ind_f = find(scan.Signal{ind1}.sig_var>=freqstart & scan.Signal{ind1}.sig_var<=freqstop);
   n=1;
   for ind=params.ind_path
        ind2=path.ind_signal(ind);
        %Plot the signals
        name=scan.Signal{ind2}.name;
        transmission_breast=20*log10(abs(scan.Signal{ind2}.sig_data));
        % Compensate for loss in sensor body.
        transmission_breast=transmission_breast-TransAntenna_dB/2;
        % Compensate for Radial spreading (1.5 dB/cm)
        transmission_breast=transmission_breast+1.5*(path.length(ind)*100);
        % Compensate for Gain variation
        er=er_list(n); % this needs to be found in the Er_table
        % Find the nearest value for the permittivity
        ind_er=knnsearch(GFP(:,1),er)
        GainComp_dB=GFP(ind_er,2)*freq.^2+GFP(ind_er,3)*freq+GFP(ind_er,4);
        transmission_breast=transmission_breast-1*GainComp_dB;
        % Here we calculate the mean attenuation
        attenuation=-transmission_breast./(path.length(ind)*100);
        plot(scan.Signal{ind2}.sig_var(ind_f)./1e9,attenuation(ind_f),'LineWidth',2,'Color',ColorSet{2},'DisplayName',name);
        mean_attenuation=mean_attenuation+attenuation;
        %indices
        n=n+1
   end
   mean_attenuation=mean_attenuation./length(params.ind_path);
   plot(scan.Signal{ind2}.sig_var(ind_f)./1e9,mean_attenuation(ind_f),'LineWidth',3,'Color',ColorSet{4},'DisplayName','mean');
        
   output = mean_attenuation;
end

