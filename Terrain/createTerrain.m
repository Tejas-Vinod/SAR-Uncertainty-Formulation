function [xvec, yvec, A, xLimits, yLimits, resMapX, resMapY] = createTerrain(dat_choice)
%CREATETERRAIN Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    dat_choice
end

arguments (Output)
    xvec
    yvec
    A
    xLimits
    yLimits
    resMapX
    resMapY
end

switch dat_choice
    case 1
        rng(2021)
        % Create terrain
        xLimits         = [900 1200]; % x-axis limits of terrain (m)
        yLimits         = [-200 200]; % y-axis limits of terrain (m)
        roughnessFactor = 1.75;       % Roughness factor
        initialHgt      = 0;          % Initial height (m)
        initialPerturb  = 200;        % Overall height of map (m) 
        numIter         = 8;          % Number of iterations
        [x,y,A] = helperRandomTerrainGenerator(roughnessFactor,initialHgt, ....
            initialPerturb,xLimits(1),xLimits(2), ...
            yLimits(1),yLimits(2),numIter);
        A(A < 0) = 0; % Fill-in areas below 0
        xvec = x(1,:); 
        yvec = y(:,1);
        resMapX = mean(diff(xvec));
        resMapY = mean(diff(yvec));
    case 2
        load("GEBCO_arcmin.mat");
        xvec = long_vec;
        yvec = lat_vec;
        A = arcmin_dat;
        xLimits = [0,length(xvec)];
        yLimits = [0,length(yvec)];
    case 3
        load("GEBCO_50.mat");
        xvec = long_vec;
        yvec = lat_vec;
        A = Grid50_dat;
        xLimits = [0,length(xvec)];
        yLimits = [0,length(yvec)];
    case 4
        load("GEBCO_200.mat");
        xvec = long_vec;
        yvec = lat_vec;
        A = Grid200_dat;
        A = fliplr(fliplr(A).');
        A = rot90(A,2);
        xLimits = [0,length(xvec)];
        yLimits = [0,length(yvec)];
end
end


% Helper Functions
function [x,y,terrain] = helperRandomTerrainGenerator(f,initialHeight, ...
    initialPerturb,minX,maxX,minY,maxY,numIter)
%randTerrainGenerator Generate random terrain
% [x,y,terrain] = helperRandomTerrainGenerator(f,initialHeight, ...
%    initialPerturb,minX,maxX,minY,maxY,seaLevel,numIter)
%
% Inputs: 
%   - f                   = A roughness parameter.  A factor of 2 is a
%                           typical default. Lower values result in a 
%                           rougher terrain; higher values result in a 
%                           smoother surface.
%   - initialHeight       = Sets the initial height of the lattice before 
%                           the perturbations.
%   - initialPerturb      = Initial perturbation amount. This sets the 
%                           overall height of the landscape.
%   - minX,maxX,minY,maxY = Initial points. Provides some degree of control
%                           over the macro appearance of the landscape.
%   - numIter             = Number of iterations that affects the density 
%                           of the mesh that results from the iteration
%                           process.
%
% Output: 
%    - x                  = X-dimension mesh grid
%    - y                  = Y-dimension mesh grid
%    - terrain            = Two-dimensional array in which each value 
%                           represents the height of the terrain at that 
%                           point/mesh-cell

% Generate random terrain
dX = (maxX-minX)/2;
dY = (maxY-minY)/2;
[x,y] = meshgrid(minX:dX:maxX,minY:dY:maxY);
terrain = ones(3,3)*initialHeight;
perturb = initialPerturb;
for ii = 2:numIter
    perturb = perturb/f;
    oldX = x;
    oldY = y;
    dX = (maxX-minX)/2^ii;
    dY = (maxY-minY)/2^ii;
    [x,y] = meshgrid(minX:dX:maxX,minY:dY:maxY);
    terrain = griddata(oldX,oldY,terrain,x,y);
    terrain = terrain + perturb*randn(1+2^ii,1+2^ii);
    terrain(terrain < 0) = 0; 
end
end