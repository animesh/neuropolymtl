%% simulate and plot

plot(rand(1000))

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
hist(z)

plot(x)
plot(xc)
plot(xs)
plot(xs,xc,'r.')
plot(xcorr(x,x))
plot(xcorr(xs,xc))

%% fft 

Y=fft(xs)
n=length(Y);
power = abs(Y(1:floor(n/2))).^2;
nyquist = 1/2;
freq = (1:n/2)/(n/2)*nyquist;
plot(freq,power)

period=1./freq;
plot(period,power);

hold on;
index=find(power==max(power));
mainPeriodStr=num2str(period(index));
plot(period(index),power(index),'r.', 'MarkerSize',25);
text(period(index)+2,power(index),['Period = ',mainPeriodStr]);
hold off;



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

%% source
%http://www.mathworks.com/help/matlab/examples/using-fft.html
%http://www.mathworks.com/help/signal/examples/measuring-signal-similarities.html