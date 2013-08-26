function Dlabelme = LOADINDEX;
% 
% load index from the toolbox folder
toolboxfolder = strrep(which('UPDATEINDEX.m'), 'UPDATEINDEX.m', '');
load(fullfile(toolboxfolder, 'Dlabelme'));

disp(lastupdate)
