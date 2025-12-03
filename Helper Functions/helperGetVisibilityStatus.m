function helperGetVisibilityStatus(tgtNum,occ)
% Translate occlusion values to a visibility status
% Copyright 2021-2024 The MathWorks, Inc.

visibility = {'not','partially','fully'};
if all(occ)
    idx = 1;
elseif any(occ)
    idx = 2;
else
    idx = 3;
end
visString = visibility{idx};
pctCollect = sum(double(~occ))./numel(occ)*100;
fprintf('Target %d is %s visible during the scenario (visible %.0f%% of the data collection).\n', ...
    tgtNum,visString,pctCollect)
drawnow
pause(0.25)
end