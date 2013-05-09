%% simulate and plot

plot(rand(100))

x = rand(1024,1);
z=mscohere(sin(x),cos(x))
mean(z)
z=mscohere(sin(2*pi*x),cos(2*pi*x))
hist(z,[1000])
hist(x,[100])

plot(cos(2*pi*x),sin(2*pi*x))
plot(cos(x),sin(x))
axis equal

plot(cos((x-mean(x))/std(x)))

plot(sin([0:0.001:1]))
plot([0:0.001:1])
plot(sin([0:0.01:3]))
plot(sin([0:0.01:4]))

xs=sin(2*pi*x)+sin(2*pi*4*x)+sin(2*pi*8*x)+sin(2*pi*12*x)+sin(2*pi*24*x)
xc=cos(2*pi*x)+cos(2*pi*4*x)+cos(2*pi*8*x)+cos(2*pi*12*x)+cos(2*pi*24*x)
corr(abs(fft(xs)),abs(fft(xc)))

mscohere(xs,xc)
mscohere(xs,xc,hanning(24),12,24)
z=mscohere(xs,xc)

plot(x)
plot(xc)
plot(xs)
plot(xs,xc,'r.')
plot(xcorr(x,x))
plot(xcorr(xs,xc))

%% epileptogenicity index

[c,lag] = xcorr(xc,xs);
plot(lag,c,'r'); 
[~,I] = max(abs(c));
timeDiff = lag(I)/size(x,1)

[P1,f1] = periodogram(xs);
[P2,f2] = periodogram(xc);
plot(f2,P2)
plot(f1,P1)

[Cxy,f] = mscohere(xc,xs);
Pxy     = cpsd(xc,xs);
phase   = -angle(Pxy)/pi*180;
[pks,locs] = findpeaks(Cxy,'MinPeakHeight',0.3)
plot(f,Cxy); 
plot(f,phase); 


maxlags = numel(xs)*0.5;
[xcv,lag] = xcov(xs,maxlags);
[~,df] = findpeaks(xcv,'MinPeakHeight',0.3)
plot(lag,xcv)


%http://www.mathworks.com/help/signal/examples/measuring-signal-similarities.html