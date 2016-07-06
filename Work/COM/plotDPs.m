function plotDPs(f, epsEst, sigEst, xlimits)

e0 = 8.85e-12;

figure;
subplot(2,1,1)
plot(f, epsEst)
xlabel('Frequency (Hz)')
ylabel('Relative permittivity [ ]')
xlim(xlimits)


% subplot(3,1,2)
% plot(f, sigEst./(e0 * 2*pi.*f))
% xlabel('Frequency (Hz)')
% ylabel('Imaginary \epsilon '''' [ ]')
% xlim(xlimits)

subplot(2,1,2)
plot(f, sigEst)
xlabel('Frequency (Hz)')
ylabel('Conductivity [S/m]')
xlim(xlimits)



end