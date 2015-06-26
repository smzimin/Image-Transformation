%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Load DICOM pixels, applying intercept and slope values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Img = OM_DICOMPixels(fname) 

Img = [];

% Read dicom image and info
Img = double(dicomread(fname));
info = dicominfo(fname);

% Do we have rescaling data in this file?
if(~isfield(info, 'RescaleIntercept') || ~isfield(info, 'RescaleSlope'))
    return;
end;

% Rescale
a = double(info.RescaleSlope);
b = double(info.RescaleIntercept);
Img = a*Img+b;

return;
