% MATLAB startup options

% Make figures docked by default
set(0, 'DefaultFigureWindowStyle', 'docked');

% Include packages that are git directories
addpath([userpath, '/Base16']);
addpath([userpath, '/export_fig']);
addpath([userpath, '/shadedErrorBar']);

% Set darkmode
darkmode;

% Set display mode to compact
format('compact');

% Default colormap
set(0, 'DefaultFigureColormap', plasma);

% Default axis coloring, if needed
% colordef('black');
