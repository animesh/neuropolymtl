function [ccf,pst] = spm_csd2ccf(csd,Hz)
% Converts cross spectral density to cross covariance function
% FORMAT [ccf,pst] = spm_csd2ccf(csd,Hz)
%
% csd  (n,:,:)          - cross spectral density (cf, mar.P)
% Hz   (n x 1)          - vector of frequencies (Hz)
%
% ccf                   - cross covariance functions
% pst  (N,1)            - vector of lags for evaluation (seconds)
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: spm_csd2ccf.m 5287 2013-02-28 14:18:46Z rosalyn $
 
% unpack cells
%--------------------------------------------------------------------------

if iscell(csd)
    for i = 1:length(csd)
       [ccfi,pst] = spm_csd2ccf(csd{i},Hz);
       ccf{i}     = ccfi;
    end
    return
end
 
% unpack time bins (for time-frequency responses)
%--------------------------------------------------------------------------
if ndims(csd) == 4
    for i = 1:size(csd,1)
       [ccfi,pst]   = spm_csd2ccf(squeeze(csd(i,:,:,:)),Hz);
       ccf(i,:,:,:) = ccfi;
    end
    return
end


% Nyquist
%--------------------------------------------------------------------------
N     = 256;
g     = zeros(N,1);
Hz    = round(Hz);
 
% Fourier transform cross-spectral density
%==========================================================================
for i = 1:size(csd,2)
    if ndims(csd) == 2
        g(Hz)      = csd(:,i);
        f          = ifft([0; g; flipud(conj(g))]);
        ccf(:,i) = real(fftshift(f))*N;
    else
        for j = 1:size(csd,3)
            g(Hz)      = csd(:,i,j);
            f          = ifft([0; g; flipud(conj(g))]);
            ccf(:,i,j) = real(fftshift(f))*N;
        end
    end
end
 
% Compute time bins
%--------------------------------------------------------------------------
pst = (-N:N)/N/2;
