function []=pgui()

%% PURPOSE: THIS IS THE FUNCTION THAT IS CALLED AT THE COMMAND LINE TO OPEN THE GUI FOR IMPORTING/PROCESSING/PLOTTING DATA
% THIS FUNCTION CREATES ALL COMPONENTS, AND CONTAINS THE CALLBACKS FOR ALL COMPONENTS IN THE GUI.

% WRITTEN BY: MITCHELL TILLMAN, 11/06/2021
% IN HONOR OF DOUGLAS ERIC TILLMAN, 10/29/1961-07/05/2021

% Assumes that the app is being run from within the 'Everything App' folder and that the rest of the files & folders are untouched.
addpath(genpath(fileparts(mfilename('fullpath')))); % Add all subfolders to the path so that app creation & management is unencumbered.

% Check if Mac or PC
if ispc==1
    slash='\';
elseif ismac==1
    slash='/';
end

%% Create figure & store its attributes
fig=uifigure('Visible','on','Resize','On','AutoResizeChildren','off','SizeChangedFcn',@appResize); % Create the figure window for the app
fig.Name='pgui'; % Name the window
defaultPos=get(0,'defaultfigureposition'); % Get the default figure position
set(fig,'Position',defaultPos); % Set the figure to be at that position (redundant, I know, but should be clear)
figSize=get(fig,'Position'); % Get the figure's position.
figSize=figSize(3:4); % Width & height of the figure upon creation. Size syntax: left offset, bottom offset, width, height (pixels)

%% Initialize app data
setappdata(fig,'everythingPath',[fileparts(mfilename('fullpath')) slash]); % Path to the 'Everything App' folder.
setappdata(fig,'projectName',''); % projectName always begins empty.
setappdata(fig,'logsheetPath',''); % logsheetPath always begins empty.
setappdata(fig,'dataPath',''); % dataPath always begins empty.
setappdata(fig,'codePath',''); % codePath always begins empty.
setappdata(fig,'rootSavePlotPath',''); % rootSavePlotPath always begins empty.

%% Create tab group with the four primary tabs
tabGroup1=uitabgroup(fig,'Position',[0 0 figSize],'AutoResizeChildren','off'); % Create the tab group for the four stages of data processing
fig.UserData=struct('TabGroup1',tabGroup1); % Store the components to the figure.
importTab=uitab(tabGroup1,'Title','Import','Tag','Import','AutoResizeChildren','off','SizeChangedFcn',@(importTab,event) importResize(importTab)); % Create the import tab
processTab=uitab(tabGroup1,'Title','Process','Tag','Process','AutoResizeChildren','off','SizeChangedFcn',@(processTab,event) processResize(processTab)); % Create the process tab
plotTab=uitab(tabGroup1,'Title','Plot','Tag','Plot','AutoResizeChildren','off'); % Create the plot tab
statsTab=uitab(tabGroup1,'Title','Stats','Tag','Stats','AutoResizeChildren','off'); % Create the stats tab
settingsTab=uitab(tabGroup1,'Title','Settings','Tag','Settings','AutoResizeChildren','off'); % Create the settings tab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize the import tab.
projectNameLabel=uilabel(importTab,'Text','Project Name');
logsheetPathButton=uibutton(importTab,'push','Text','Logsheet Path','Tag','LogsheetPathButton','ButtonPushedFcn',@(logsheetPathButton,event) logsheetPathButtonPushed(logsheetPathButton));
dataPathButton=uibutton(importTab,'push','Text','Data Path','Tag','DataPathButton','ButtonPushedFcn',@(dataPathButton,event) dataPathButtonPushed(dataPathButton));
codePathButton=uibutton(importTab,'push','Text','Code Path','Tag','CodePathButton','ButtonPushedFcn',@(codePathButton,event) codePathButtonPushed(codePathButton));
projectNameField=uieditfield(importTab,'text','Value','Project Name','Tag','ProjectNameField','ValueChangedFcn',@(projectNameField,event) projectNameFieldValueChanged(projectNameField)); % Project name edit field
logsheetPathField=uieditfield(importTab,'text','Value','Logsheet Path (ends in .xlsx)','Tag','LogsheetPathField','ValueChangedFcn',@(logsheetPathField,event) logsheetPathFieldValueChanged(logsheetPathField));
dataPathField=uieditfield(importTab,'text','Value','Data Path (contains ''Subject Data'' folder)','Tag','DataPathField','ValueChangedFcn',@(dataPathField,event) dataPathFieldValueChanged(dataPathField)); % Data path name edit field (to the folder containing 'Subject Data' folder)
codePathField=uieditfield(importTab,'text','Value','Path to Project Processing Code Folder','Tag','CodePathField','ValueChangedFcn',@(codePathField,event) codePathFieldValueChanged(codePathField)); % Code path name edit field (to the folder containing all code for this project).
% Button to open the project's importSettings file.
openImportSettingsButton=uibutton(importTab,'push','Text','Create importSettings.m','Tag','OpenImportSettingsButton','ButtonPushedFcn',@(openImportSettingsButton,event) openImportSettingsButtonPushed(openImportSettingsButton,projectNameField.Value));
% Button to open the project's specifyTrials to select which trials to load/import
openSpecifyTrialsButton=uibutton(importTab,'push','Text','Create specifyTrials.m','Tag','OpenSpecifyTrialsButton','ButtonPushedFcn',@(openSpecifyTrialsButton,event) openSpecifyTrialsButtonPushed(openSpecifyTrialsButton,projectNameField.Value));
% Checkbox to redo import (overwrites all existing data files)
redoImportCheckbox=uicheckbox(importTab,'Text','Redo (Overwrite) Import','Value',0,'Tag','RedoImportCheckbox','ValueChangedFcn',@(redoImportCheckbox,event) redoImportCheckboxValueChanged(redoImportCheckbox));
% Checkbox to add new data types to existing files
% addDataTypesCheckbox=uicheckbox(importTab,'Text','Add Data Types','Value',0,'Tag','AddDataTypesCheckbox','ValueChangedFcn',@(addDataTypesCheckbox,event) addDataTypesCheckboxValueChanged(addDataTypesCheckbox));
% Checkbox to update metadata only in existing files
updateMetadataCheckbox=uicheckbox(importTab,'Text','Update Metadata Only','Value',0','Tag','UpdateMetadataCheckbox','ValueChangedFcn',@(updateMetadataCheckbox,event) updateMetadataCheckboxValueChanged(updateMetadataCheckbox));
% Button to run the import/load procedure
runImportButton=uibutton(importTab,'push','Text','Run Import/Load','Tag','RunImportButton','ButtonPushedFcn',@(runImportButton,event) runImportButtonPushed(runImportButton));
% Drop down to switch between active projects.
switchProjectsDropDown=uidropdown(importTab,'Items',{'New Project'},'Editable','off','Tag','SwitchProjectsDropDown','ValueChangedFcn',@(switchProjectsDropDown,event) switchProjectsDropDownValueChanged(switchProjectsDropDown));
% Drop down to specify & open a new data type's importSettings
dataTypeImportSettingsDropDown=uidropdown(importTab,'Items',{'MOCAP','FP','EMG','IMU'},'Editable','on','Tag','DataTypeImportSettingsDropDown','ValueChangedFcn',@(dataTypeImportSettingsDropDown,event) dataTypeImportSettingsDropDownValueChanged(dataTypeImportSettingsDropDown));
% Logsheet label
logsheetLabel=uilabel(importTab,'Text','Logsheet:');
% Number of header rows label
numHeaderRowsLabel=uilabel(importTab,'Text','# of Header Rows','Tag','NumHeaderRowsLabel');
% Number of header rows text box
numHeaderRowsField=uieditfield(importTab,'numeric','Value',1,'Tag','NumHeaderRowsField');
% Subject ID column header label
subjIDColHeaderLabel=uilabel(importTab,'Text','Subject ID Column Header','Tag','SubjectIDColumnHeaderLabel');
% Subject ID column header text box
subjIDColHeaderField=uieditfield(importTab,'text','Value','Subject ID Column Header','Tag','SubjIDColumnHeaderField');
% Trial ID column header label
trialIDColHeaderLabel=uilabel(importTab,'Text','Trial ID Column Header');
% Trial ID column header text box
trialIDColHeaderField=uieditfield(importTab,'text','Value','Trial ID Column Header','Tag','TrialIDColumnHeaderField');
% Trial ID format label
trialIDFormatLabel=uilabel(importTab,'Text','Trial ID Format','Tag','TrialIDFormatLabel');
% Trial ID format field
trialIDFormatField=uieditfield(importTab,'text','Value','S T','Tag','TrialIDFormatField');
% Target Trial ID format label
targetTrialIDFormatLabel=uilabel(importTab,'Text','Target Trial ID Format','Tag','TargetTrialIDFormatLabel');
% Target Trial ID format field
targetTrialIDFormatField=uieditfield(importTab,'text','Value','T','Tag','TargetTrialIDFormatField');
% Save all trials button
saveAllButton=uibutton(importTab,'push','Text','Save Struct','Tag','SaveAllButton');
% Load which data label
selectDataPanel=uipanel(importTab,'Title','Select Groups'' Data to Load','Tag','SelectDataPanel');
% Need to read the groups text file to get group names. Create
% corresponding number of checkboxes & their labels.

importTab.UserData=struct('ProjectNameLabel',projectNameLabel,'LogsheetPathButton',logsheetPathButton,'DataPathButton',dataPathButton,'CodePathButton',codePathButton,...
    'ProjectNameField',projectNameField,'LogsheetPathField',logsheetPathField,'DataPathField',dataPathField,'CodePathField',codePathField,'DataTypeImportSettingsDropDown',dataTypeImportSettingsDropDown,...
    'OpenImportSettingsButton',openImportSettingsButton,'OpenSpecifyTrialsButton',openSpecifyTrialsButton,'SwitchProjectsDropDown',switchProjectsDropDown,'RedoImportCheckBox',redoImportCheckbox,...
    'UpdateMetadataCheckBox',updateMetadataCheckbox,'RunImportButton',runImportButton,'LogsheetLabel',logsheetLabel,'NumHeaderRowsLabel',numHeaderRowsLabel,'NumHeaderRowsField',numHeaderRowsField,...
    'SubjectIDColHeaderLabel',subjIDColHeaderLabel,'SubjectIDColHeaderField',subjIDColHeaderField,'TrialIDColHeaderLabel',trialIDColHeaderLabel,'TrialIDColHeaderField',trialIDColHeaderField,...
    'TrialIDFormatLabel',trialIDFormatLabel,'TrialIDFormatField',trialIDFormatField,'TargetTrialIDFormatLabel',targetTrialIDFormatLabel,'TargetTrialIDFormatField',targetTrialIDFormatField,...
    'SaveAllButton',saveAllButton,'SelectDataPanel',selectDataPanel);

importResize(importTab); % Run the importResize to set all components' positions to their correct positions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize the process tab.
tabGroupProcess=uitabgroup(processTab,'Tag','ProcessTabGroup','Position',[0 0 figSize],'AutoResizeChildren','off');
processTab.UserData=struct('ProcessTabGroup',tabGroupProcess);
processSetupTab=uitab(tabGroupProcess,'Title','Setup','Tag','Setup','AutoResizeChildren','off','SizeChangedFcn',@(processSetupTab,event) processSetupResize(processSetupTab)); % Create the process > setup tab
processRunTab=uitab(tabGroupProcess,'Title','Run','Tag','Run','AutoResizeChildren','off','SizeChangedFcn',@(processRunTab,event) processRunResize(processRunTab)); % Create the process > run tab

processTab.UserData=struct('ProcessSetupTab',processSetupTab,'ProcessRunTab',processRunTab); % Store the components to the process tab.
processResize(processTab);

% Create the Process > Setup tab
processSetupResize(processSetupTab); % Place the components in the Process > Setup tab.

% Create the Process > Run tab


processRunResize(processRunTab); % Place the components in the Process > Run tab.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize the plot tab
rootSavePlotPathField=uieditfield(plotTab,'text','Value','Root Folder to Save Plots');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AFTER COMPONENT INITIALIZATION
%% Read any existing projects' info (path names, etc.), store them, and display them.
[A,allProjectsTxt]=readAllProjects(getappdata(fig,'everythingPath')); % Return the text of the 'allProjects_ProjectNamesPaths.txt' file
setappdata(fig,'allProjectsTxtPath',allProjectsTxt); % Store the address of the 'allProjects_ProjectNamesPaths.txt' file
if iscell(A) % The file exists and has a pre-existing project in it.
    allProjectsList=getAllProjectNames(A);
else
    allProjectsList='';
end
setappdata(fig,'allProjectsList',allProjectsList);
if ~isempty(allProjectsList) % Ensure that there are project names present.
    numLines=length(A);
    mostRecentProjPrefix='Most Recent Project Name:';
    for i=numLines:-1:1 % Go backwards because this is always at the end of the file.
        if contains(A{i},mostRecentProjPrefix) % This is the line with the last used project name.
            mostRecentProjectName=A{i}(length(mostRecentProjPrefix)+2:length(A{i}));
        end
        break;
    end
    setappdata(fig,'projectName',mostRecentProjectName); % projectName always begins empty.
    projectNameField.Value=getappdata(fig,'projectName');
    projectNamePaths=isolateProjectNamesPaths(A,mostRecentProjectName); % Return the path names associated with the specified project name.
    
    % Set those path names into the figure's app data.
    if isfield(projectNamePaths,'LogsheetPath')
        setappdata(fig,'logsheetPath',projectNamePaths.LogsheetPath);
        logsheetPathField.Value=getappdata(fig,'logsheetPath');
    end
    if isfield(projectNamePaths,'DataPath')
        setappdata(fig,'dataPath',projectNamePaths.DataPath);
        dataPathField.Value=getappdata(fig,'dataPath');
    end
    if isfield(projectNamePaths,'CodePath')
        setappdata(fig,'codePath',projectNamePaths.CodePath);
        codePathField.Value=getappdata(fig,'codePath');
    end
    if isfield(projectNamePaths,'RootSavePlotPath')
        setappdata(fig,'rootSavePlotPath',projectNamePaths.RootSavePlotPath);
        rootSavePlotPathField.Value=getappdata(fig,'rootSavePlotPath');
    end
    
    % Display the project info in the text edit fields.
    switchProjectsDropDown.Items=allProjectsList;
    switchProjectsDropDown.Value=getappdata(fig,'projectName');
else % The file does not exist, or exists and has nothing in it.
    
end

% Make everything invisible until the project name is entered!
if isempty(getappdata(fig,'projectName'))
    h=findall(fig.Children.Children(1,1)); % The import tab and all of its components.
    for i=1:length(h)
        if i~=1 && i~=13 && i~=17 % Ignore the project name textbox and label.
            h(i).Visible='off';
        end
    end
end

% Change the text on the importSettings, specifyTrials, and specifyVars buttons  based on what paths/files are present.
% This will change their behavior.
codePath=getappdata(fig,'codePath');
projectName=getappdata(fig,'projectName');
importSettingsFile=0; % Initialize that the project-specific user customized importSettings is found.
specifyTrialsFile=0; % Initialize that the project-specific user customized specifyTrials is found.
if ~isempty(codePath) && ~isempty(projectName) % Code path and project name are both present, look for the project-specific templates.
    if isfolder([codePath 'Import_' projectName slash]) % Project-specific user customized files stored in Import subfolder of project-specific codePath
        listing=dir([codePath 'Import_' projectName slash]);
        for i=1:length(listing)
            if isequal(listing(i).name,['importSettings_' projectName '.m'])
                importSettingsFile=1;
            elseif isequal(listing(i).name,['specifyTrials_Import' projectName '.m'])
                specifyTrialsFile=1;
            end
        end
    end    
end

% 'Create' new project-specific templates.
% h=findobj(fig,'Type','uibutton');
if importSettingsFile==0 % Make the button function to create a new project-specific importSettings    
    h=findobj(fig,'Type','uibutton','Tag','OpenImportSettingsButton');
    h.Text=['Create importSettings_' projectName '.m'];
end
if specifyTrialsFile==0 % Make the button function to create a new project-specific specifyTrials
    h=findobj(fig,'Type','uibutton','Tag','OpenSpecifyTrialsButton');
    h.Text=['Create specifyTrials_Import' projectName '.m'];   
end

% 'Open' the project-specific files.
if importSettingsFile==1
    h=findobj(fig,'Type','uibutton','Tag','OpenImportSettingsButton');
    h.Text=['Open importSettings_' projectName '.m'];
end
if specifyTrialsFile==1
    h=findobj(fig,'Type','uibutton','Tag','OpenSpecifyTrialsButton');
    h.Text=['Open specifyTrials_Import' projectName '.m'];
end

assignin('base','gui',fig); % Store the GUI variable to the base workspace so that it can be manipulated/inspected