
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:     ChirpZTrans
% Version:      1.0
% Description:  make a frequency to time domain conversion using the 
%               Chirp-z Transform.
% Input:        FSignal:    Frequency Domain Signal (pulse)
%               to:         Offset time of the time domain Signal
%               dt:         Time step of the time domain Signal
%               M:          Total time domain point
% Output:       Signal:     Time Signal
% Created by Jeremie Bourqui
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%close all

%mex chirpztrans.c

% Reflection Coefficient to weight the pulse with
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data=[Freq , S11_Nothing];
% Frequency
Frequency=F;
% S parameter Real part
Sxx_Real=real(S11_TumOnly)';%real(PEC1_c);
% S parameter Imaginary part
Sxx_Imag=imag(S11_TumOnly)';%imag(PEC1_c);

% Produce the Time signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time Data
dt=2e-12;   %Time Step
T=6e-9     %Time Length
t=0:dt:T;   %Time Vector
N=length(t);                     % Length of signal
Fs=1/dt;


%*** TSAR pulse ***
tao=62.5e-12;
to=4*tao;
TSARpulse=(t-to).*exp(-(t-to).^2/tao^2);

%*** SEMCAD Pulse
%Compute SEMCAD Excitation
band=10000e6;
frequency=6000e6;
phaseshift=0;
timeshift=1e-9;
amplitude=1;

sigma = 1.0 / band;
tpeak = 4.5 * sigma;
w=2*pi*frequency;
t= t-timeshift;

SEMCADpulse = amplitude * exp(-0.5 * ((t-tpeak)/sigma).^2) .* sin(w*t + phaseshift);



% Pulse chosen:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pulse=SEMCADpulse;
% Normalise the pulse energy to 1J
% pulse=pulse./sqrt(trapz(t,pulse.^2));
Energy_t= trapz(t,pulse.^2)
pulse=pulse;
%Plot the pulse
figure('Color',[1 1 1]);
plot(t,pulse,'LineWidth',2)
xlabel('Time [s]');
ylabel('Amplitude (V/m)');
title('Pulse in the time domain')
grid on;

% Transform the pulse in frequency domain with the chirp Z
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The chirp Z transform is used to perform this operation
% The frequencies are extrated from the Sxx parameter frequency vector
fs=1/dt;        % Sampling frequency from the time signal
fmin=min(Frequency);   % Lower Frequency bound
fmax=max(Frequency);   % Upper Frequency bound
m=length(Frequency);   % Number of frequency point
w = exp(-j*2*pi*(fmax-fmin)/(m*fs));
a = exp(j*2*pi*fmin/fs);
Fpulse=czt(pulse',m,w,a); %czt is a Matlab function

% Transform the pulse in frequency domain with standard FFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FpulseFFT = fftshift(fft(pulse));
frFFT = Fs*[-1/2:1/N:1/2-1/N];


% Frequency to consider
FreqStart=1e9;
FreqStop=11e9;


%Plot the pulse in Fequency Domain
figure('Color',[1 1 1]);
hold on
Freq_Index = find(Frequency > FreqStart & Frequency < FreqStop);
plot(Frequency(Freq_Index)/1e9,abs(Fpulse(Freq_Index))/N,'LineWidth',2)
Energy_ChirpZ= trapz(Frequency(Freq_Index),abs(Fpulse(Freq_Index)).^2)
Freq_Index = find(frFFT > FreqStart & frFFT < FreqStop);
plot(frFFT(Freq_Index)/1e9,abs(FpulseFFT(Freq_Index))/N,'LineWidth',2)
Energy_FFT= trapz(frFFT(Freq_Index),abs(FpulseFFT(Freq_Index)).^2)
xlabel('Frequency (GHz)');
ylabel('Amplitude');
grid on;
title('Pulse in the frequency domain')





% Weight the pulse with the Sxx parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transform the Sxx in Imaginary format
WeightFcn=(Sxx_Real + Sxx_Imag*i);
% % Normalised amplitude to 1
% WeightFcn=WeightFcn./abs(WeightFcn);
% % Synthetique Sxx
% WeightFcn=ones(length(Frequency),1).*exp(2*pi*Frequency*i*10-(10*pi/2));
% Actually weight the function
FSignal=Fpulse.*WeightFcn.';



% Inverse ChirpZTransorm (Frequency to time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The Weighted signal is transfom in the time domain using the
% ChirpZTransform
to=0;
M=length(t);
fo=min(Frequency);
df=Frequency(2)-Frequency(1);
N=length(Frequency);

%Apply a window
% figure, plot(FSignal)
% hold on
% Window = hamming(N);
% FSignal=FSignal.*Fpulse;
% plot(FSignal)
clear Signal

% ChirpZ with Matlab
%  for k=1:M
%          for n=1:N
%              chirp_var(n)=FSignal(n).*exp(i*2*pi*(df*to*(n-1)+df*dt*((n-1)^2/2))).*exp(-i*2*pi*df*dt*(((k-1)-(n-1))^2/2));
%          end
%          chirp_sum=sum(chirp_var,2);
%          Signal(k)=exp(i*2*pi*((to+(k-1)*dt)*fo+(df*dt)*(k-1)^2/2)).*chirp_sum;
%  end

%ChirpZ with the compiled C function
Signal = chirpztrans(FSignal, M, N, to, dt, fo, df);
% Take only the real part since the imaginary part is litteraly zero
Signal=real(Signal);

% Plot the signals in time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot Time Domain
figure('Color',[1 1 1]);
plot(t,Signal,'LineWidth',2)
xlabel('Time [s]');
ylabel('Amplitude (V/m)');
grid on;
title('Time Signal')


%Save the transmitted pulse in another memory
Result=[t;Signal]';

% Clear unwanted variable
clear('B','C','M','Mag','N','Ph','t','FSignal','FWeighted','Fpulse', 'Signal', ...
        'WeightFcn','a','chirp_sum','chirp_var','df','dt','fmin','fmax', ...
        'fo','Frequency','fs','k','m','n','pulse','tao','to','w','T','SinModGauspulse', ...
        'f_cen','mue','sigma','phaseshift','timeshift','tpeak','frFFT','band', ...
        'frequency','frFFT','amplitude','TSARpulse','Sxx_Imag','Sxx_Real', ...
        'SEMCADpulse','Fs','Freq_Index','FreqStop','FreqStart','FpulseFFT','Energy_t', ...
        'Energy_ChirpZ','Energy_FFT','Data')
%     
%         
% % TS0_ts=T0_t;
% % TS0_ts(:,2)=TS0_ts(:,2)-((A0_t(:,2)+A0_t(:,2))/2);
% 
% 
% % % Plot Reflection Signal
% % figure('Color',[1 1 1]);
% % axes('XGrid','on','YGrid','on','FontSize',14,'FontName','Times New Roman')
% % box on
% % title('A0_ Reflected Signal','FontSize',14);
% % xlabel('Time [s]','FontSize',14,'FontName','Times New Roman','FontWeight','bold');
% % ylabel('V','FontSize',14,'FontName','Times New Roman','FontWeight','bold');
% % plot (T0_ts(:,1),TS0_ts(:,2),'LineWidth',2)