clear all
f_samp = 330e3;

%Band Edge speifications
fs1 = 33.9e3;
fp1 = 37.9e3;
fp2 = 57.9e3;
fs2 = 61.9e3;

Wc1 = fp1*2*pi/f_samp;
Wc2  = fp2*2*pi/f_samp;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

N_min = ceil((A-7.95) / (2.285*0.024*pi))           %empirical formula for N_min

%Window length for Kaiser Window
n=N_min + 21;

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(0.362*pi,n) - ideal_lp(0.2150*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandPass,1,1024, f_samp);
plot(f,abs(H))
yline(0.15, "b-")
yline(0.85, "b-")
xline(fs1, "g--")
xline(fp1, "r--")
xline(fp2, "r--")
xline(fs2, "g--")
grid