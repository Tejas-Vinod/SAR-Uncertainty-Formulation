function helperUpdatePlotRawIQ(hRaw,raw)
% Update the raw SAR IQ plot
% Copyright 2021-2024 The MathWorks, Inc.

hRaw.CData = real(raw.'); 
clim([-0.06 0.06]);
drawnow
pause(0.25)
end
