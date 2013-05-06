function D = spm_eeg_inv_forward_ui(varargin)
% Forward Solution user interface
% FORMAT D = spm_eeg_inv_forward_ui(D,val)
% D        - input data struct (optional)
% val      - model of interest (optional)
%
% D        - same data struct including the forward solution
%__________________________________________________________________________
%
% Call the forward computation for either EEG or MEG data using various
% types of solutions using FieldTrip.
%__________________________________________________________________________
% Copyright (C) 2008-2012 Wellcome Trust Centre for Neuroimaging

% Jeremie Mattout & Christophe Phillips
% $Id: spm_eeg_inv_forward_ui.m 4701 2012-03-22 16:47:05Z guillaume $

%-Initialisation
%--------------------------------------------------------------------------
[D, val] = spm_eeg_inv_check(varargin{:});

D.inv{val}.forward = struct([]);

for i = 1:numel(D.inv{val}.datareg)
    switch D.inv{val}.datareg(i).modality
        case 'EEG'
            models = {'EEG BEM', '3-Shell Sphere (experimental)'};
        case 'MEG'
            models = {'Single Sphere', 'MEG Local Spheres', 'Single Shell'};
        otherwise
            error('Unsupported modality');
    end
    str = sprintf('%s|', models{:});
    str = str(1:(end-1));

    D.inv{val}.forward(i).voltype = spm_input(sprintf('Which %s head model?', ...
        D.inv{val}.datareg(i).modality), 1, 'm', str, char(models));
end

%-Compute forward model
%--------------------------------------------------------------------------
D = spm_eeg_inv_forward(D);

if ~spm('CmdLine')
    spm_eeg_inv_checkforward(D, val);
end

fprintf('Foward model complete - thank you\n');                         %-#
