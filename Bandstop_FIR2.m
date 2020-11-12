f_samp = 260e3;

%Band Edge speifications
fs1 = 32.7e3;
fp1 = 36.7e3;
fp2 = 56.7e3;
fs2 = 60.7e3;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

Wn = [(fs1+fp1)/2 (fs2+fp2)/2]*2/f_samp;        %average value of the two paramters
N_min = ceil((A-7.95) / (2.285*0.031*pi))       %empirical formula for N_min

%Window length for Kaiser Window
n=N_min + 17;

%Ideal bandstop impulse response of length "n"

bs_ideal =  ideal_lp(pi,n) -ideal_lp(0.452*pi,n) + ideal_lp(0.265*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandStop = bs_ideal .* kaiser_win;
fvtool(FIR_BandStop);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandStop,1,1024, f_samp);
plot(f,abs(H))
yline(0.15, "b-")
yline(0.85, "b-")
yline(1.15, "b-")
xline(fp1, "g--")
xline(fs1, "r--")
xline(fs2, "r--")
xline(fp2, "g--")
grid
