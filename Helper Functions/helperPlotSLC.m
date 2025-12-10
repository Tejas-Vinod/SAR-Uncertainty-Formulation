function helperPlotSLC(slcimg,minSample,fs,v,prf,rdrpos1,targetpos, ...
    xvec,yvec,A)
% Plot magnitude of focused SAR image alongside reflectivity map
% Copyright 2021-2024 The MathWorks, Inc.

% Cross-range y-vector (m)
numPulses = size(slcimg,2); 
du = v*1/prf; % Cross-range sample spacing (m) 
dky = 2*pi/(numPulses*du); % ku domain sample spacing (rad/m)
dy = 2*pi/(numPulses*dky); % y-domain sample spacing (rad/m)
y = dy*(0:(numPulses - 1)) + rdrpos1(2); % Cross-range y-vector (m) 

% Range vector (m)
c = physconst('LightSpeed'); 
numSamples = size(slcimg,1); 
samples = minSample:(numSamples + minSample - 1);
sampleTime = samples*1/fs; 
rngVec = time2range(sampleTime(1:end),c); 

% Initialize figure
f = figure('Position',[264 250 1411 535]);
movegui(f,'center')
tiledlayout(1,2,'TileSpacing','Compact');

% Ground Truth
nexttile;
hS = surf(xvec,yvec,A);
hS.EdgeColor = 'none';
hold on;
plot3(targetpos(:,1),targetpos(:,2),targetpos(:,3), ...
    'o','MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor','k');
landmap = landColormap(64);
colormap(landmap); 
hC = colorbar('southoutside');
hC.Label.String = 'Elevation (m)';
view([-1 75])
xlabel('Range (m)')
ylabel('Cross-range (m)')
title('Ground Truth')
axis equal
xlim([950 1100])
ylim([0 100])

% SAR Image
nexttile; 
slcimg = abs(slcimg).';
hProc = pcolor(rngVec,y,slcimg);
hProc.EdgeColor = 'none'; 
colormap(hProc.Parent,parula)
hC = colorbar('southoutside');
hC.Label.String = 'Magnitude';
xlabel('Slant Range (m)')
ylabel('Cross-range (m)')
title('SAR Image')
axis equal
xlim([1250 1420])
ylim([0 100])

drawnow
pause(0.25)
end

%% Helper FUnctions
function cmap = landColormap(n)
%landColormap Colormap for land surfaces
% cmap = landColormap(n)
%
% Inputs: 
%    - n     = Number of samples in colormap
%
% Output: 
%    - cmap  = n-by-3 colormap

c = hsv2rgb([5/12 1 0.4; 0.25 0.2 1; 5/72 1 0.4]);
cmap = zeros(n,3);
cmap(:,1) = interp1(1:3,c(:,1),linspace(1,3,n)); 
cmap(:,2) = interp1(1:3,c(:,2),linspace(1,3,n));
cmap(:,3) = interp1(1:3,c(:,3),linspace(1,3,n)); 
colormap(cmap);
end