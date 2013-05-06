function spm_check_registration(images, captions, varargin)
% A visual check of image registration quality
% FORMAT spm_check_registration
% FORMAT spm_check_registration(images, captions)
% Orthogonal views of one or more images are displayed. Clicking in
% any image moves the centre of the orthogonal views. Images are
% shown in orientations relative to that of the first selected image.
% The first specified image is shown at the top-left, and the last at
% the bottom right. The fastest increment is in the left-to-right
% direction (the same as you are reading this).
%__________________________________________________________________________
% Copyright (C) 1997-2013 Wellcome Trust Centre for Neuroimaging

% John Ashburner
% $Id: spm_check_registration.m 5360 2013-03-27 13:59:27Z guillaume $


SVNid = '$Rev: 5360 $';

if ~nargin
    [images, sts] = spm_select([1 24],'image','Select images');
    if ~sts, return; end
end

if ischar(images), images = spm_vol(images); end

spm('FnBanner',mfilename,SVNid);                                        %-#
if desktop('-inuse')
    dispf = @(f) sprintf('<a href="matlab:spm_image(''display'',''%s'');">%s</a>',f,f);
else dispf = @(f) f;
end
for i=1:numel(images)
    if i==1, fprintf('Display '); else fprintf('        '); end         %-#
    fprintf('%s\n',dispf([images(i).fname ',' num2str(images(i).n(1))]));%-#
end

spm_figure('GetWin','Graphics');
spm_figure('Clear','Graphics');
spm_orthviews('Reset');

mn = length(images);
n  = round(mn^0.4);
m  = ceil(mn/n);
w  = 1/n;
h  = 1/m;
ds = (w+h)*0.02;
for ij=1:mn
    i = 1-h*(floor((ij-1)/n)+1);
    j = w*rem(ij-1,n);
    handle = spm_orthviews('Image', images(ij),...
        [j+ds/2 i+ds/2 w-ds h-ds]);
    if ij==1, spm_orthviews('Space'); end
    spm_orthviews('AddContext',handle);
    if nargin > 1 && ~isempty(captions)
        captions = cellstr(captions);
        mn = numel(captions);
        if ij <= mn
            spm_orthviews('Caption', ij, captions{ij}, varargin{:});
        end
    end
end
