function []=oopgui()

%% PURPOSE: IMPLEMENT THE PGUI IN AN OBJECT-ORIENTED FASHION
tic;

%% Ensure that there's max one figure open
a=evalin('base','whos;');
names={a.name};
if ismember('gui',names)
    beep; disp('GUI already open, two simultaneous PGUI windows is not supported');
    return;
end

%% Add all of the appropriate paths to MATLAB search path
currFolder=fileparts(mfilename('fullpath'));
addpath(genpath(currFolder));

%% Create the figure
fig=uifigure('Name','pgui','Visible','on',...
    'Resize','on','AutoResizeChildren','off','SizeChangedFcn',@appResize);
set(fig,'DeleteFcn',@(fig, event) saveGUIState(fig)); % Deletes the gui variable from the base workspace.

handles=initializeComponents(fig); % Put all of the components in their place
setappdata(fig,'handles',handles);
assignin('base','gui',fig); % Put the GUI object into the base workspace.

%% Initialize the class folders and the contents of the root settings file.
initializeClassFolders(); % Initialize all of the folders for all classes in the common path
initLinkedObjsFile_AN_PR(); % Must come before any projects are created (which occurs in initRootSettingsFile)
initRootSettingsFile(); % Initialize the root settings file.
initLinkedObjsFile_An_Objs(); % Must come after initRootSettingsFile, to manage the Project & Analysis that were created there.


%% Load the GUI object settings (i.e. selected nodes in UI trees, checkbox selections, projects to filter, etc.)
loadGUIState(fig);

drawnow;
elapsedTime=toc;
disp(['Elapsed time is ' num2str(round(elapsedTime,2)) ' seconds.']);