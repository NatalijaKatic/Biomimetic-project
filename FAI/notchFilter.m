function filtSig = notchFilter(sig,freq)
Fs=30000;
q = 35;
for frequency = freq
    fo = frequency;
    bw = (fo/(Fs/2))/q;
    [b,a] = iirnotch(frequency*2/Fs,bw);
%     [b,a]=butter(5, [fo-1 fo+1]./(Fs/2), 'stop');
    sig=filtfilt(b,a,double(sig));
end

filtSig = sig;
end