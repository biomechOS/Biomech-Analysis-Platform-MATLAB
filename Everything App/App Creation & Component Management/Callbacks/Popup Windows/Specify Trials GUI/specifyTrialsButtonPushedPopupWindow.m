function []=specifyTrialsButtonPushedPopupWindow(src,pubTableButton)

%% PURPOSE: CREATE GUI TO FACILITATE SPECIFY TRIALS SELECTION.
% Inputs:
% src: The figure object (handle)
% guiLocation: Where in the GUI the specify trials is being called from (char)
% Possible values:
% 'Import': The Import tab
% 'Process Group groupName': The Process > Run tab, for the group groupName
% 'Process Fcn fcnName': The Process > Run tab, for the function fcnName
% 'Plot fcnName': The Plot tab, for the function fcnName

% slash=filesep;

fig=ancestor(src,'figure','toplevel');
assignin('base','gui',fig); % Send the fig handle to the base workspace.
handles=getappdata(fig,'handles');

codePath=getappdata(fig,'codePath');
if isempty(codePath) || exist(codePath,'dir')~=7
    disp('Must enter the code path first!')
    return;
end

allHandles=findall(0,'Type','Figure');
for i=1:length(allHandles)

    if isprop(allHandles(i),'Name') && isequal(allHandles(i).Name,'Specify Trials')
        warning(['Close the open specify trials window before opening a new one!']);
        return;
    end

end

% Check which function is selected in the fcnArgsUITree
% projectSettingsMATPath=getappdata(fig,'projectSettingsMATPath');
% varNames=whos('-file',projectSettingsMATPath);
% varNames={varNames.name};
% assert(all(ismember({'Digraph'},varNames)));

% load(projectSettingsMATPath,'Digraph');
Digraph=getappdata(fig,'Digraph');

tabName=handles.Tabs.tabGroup1.SelectedTab.Title;

nodeRow=1;
if isequal(tabName,'Process')
    if isempty(handles.Process.fcnArgsUITree.SelectedNodes)
        handles.Process.fcnDescriptionTextArea.Value='Enter Fcn Description Here';
        beep;
        disp('Need to select a fcn in the UI tree first!');
        return;
    end

    nodeNum=handles.Process.fcnArgsUITree.SelectedNodes.NodeData;
    a=handles.Process.fcnArgsUITree.SelectedNodes;
    for i=1:2
        if ~isempty(nodeNum)
            break;
        end
        a=a.Parent;
        nodeNum=a.NodeData;
    end

    assert(~isempty(nodeNum));

    nodeRow=find(ismember(Digraph.Nodes.NodeNumber,nodeNum)==1);
end

if isequal(tabName,'Plot')



end

if isequal(tabName,'Stats')



end

%% Initialize GUI
% clc;
Q=uifigure('Visible','on','Resize','On','AutoResizeChildren','off','SizeChangedFcn',@specifyTrialsResize);
Q.Name='Specify Trials'; % Name the window
defaultPos=get(0,'defaultfigureposition'); % Get the default figure position
set(Q,'Position',defaultPos); % Set the figure to be at that position (redundant, I know, but should be clear)
% setappdata(Q,'guiLocation',guiLocation);
% figSize=get(Q,'Position'); % Get the figure's position.
% figSize=figSize(3:4); % Width & height of the figure upon creation. Size syntax: left offset, bottom offset, width, height (pixels)

newHandles.Top.specifyTrialsLabel=uilabel(Q,'Text','Specify Trials Version','Tag','SpecifyTrialsLabel');
newHandles.Top.specifyTrialsDropDown=uidropdown(Q,'Items',{'Add Specify Trials Version'},'Tooltip','Select Which Specify Trials to Use, or Add New','Editable','off','Tag','SpecifyTrialsDropDown','ValueChangedFcn',@(specifyTrialsDropDown, event) specifyTrialsVersionDropDownValueChanged(specifyTrialsDropDown));
newHandles.Top.specifyTrialsDropDownAdd=uibutton(Q,'push','Tooltip','Add New Specify Trials Version','Text','+','Tag','SpecifyTrialsDropDownAdd','ButtonPushedFcn',@(specifyTrialsDropDown,event) specifyTrialsDropDownAddButtonPushed(specifyTrialsDropDown));
newHandles.Top.specifyTrialsDropDownRemove=uibutton(Q,'push','Tooltip','Remove Specify Trials Version','Text','-','Tag','SpecifyTrialsDropDownRemove','ButtonPushedFcn',@(specifyTrialsDropDown,event) specifyTrialsDropDownRemoveButtonPushed(specifyTrialsDropDown));
% Create the tab group for inclusion vs. exclusion criteria.
newHandles.Top.includeExcludeTabGroup=uitabgroup(Q,'AutoResizeChildren','off'); % Full width, 85% height
newHandles.Top.includeTab=uitab(newHandles.Top.includeExcludeTabGroup,'Title','Include','AutoResizeChildren','off','SizeChangedFcn',@specifyTrialsResize);
newHandles.Top.excludeTab=uitab(newHandles.Top.includeExcludeTabGroup,'Title','Exclude','AutoResizeChildren','off','SizeChangedFcn',@specifyTrialsResize);

newHandles.Include.conditionLabel=uilabel(newHandles.Top.includeTab,'Text','Condition Name','Tag','IncludeConditionLabel');
newHandles.Include.conditionDropDown=uidropdown(newHandles.Top.includeTab,'Items',{'Add Condition Name'},'Tag','IncludeConditionDropDown','ValueChangedFcn',@(includeConditionDropDown,event) conditionNameDropDownValueChanged(includeConditionDropDown));
newHandles.Include.addConditionButton=uibutton(newHandles.Top.includeTab,'Text','+','Tag','IncludeAddConditionButton','Tooltip','Add New Inclusion Condition','ButtonPushedFcn',@(includeAddConditionButton,event) addConditionNameButtonPushed(includeAddConditionButton));
newHandles.Include.removeConditionButton=uibutton(newHandles.Top.includeTab,'Text','-','Tag','IncludeRemoveConditionButton','Tooltip','Remove Inclusion Condition','ButtonPushedFcn',@(includeRemoveConditionButton,event) removeConditionNameButtonPushed(includeRemoveConditionButton));
newHandles.Include.logStructTabGroup=uitabgroup(newHandles.Top.includeTab,'AutoResizeChildren','off');
newHandles.Include.LogTab=uitab(newHandles.Include.logStructTabGroup,'Title','Logsheet','Tag','IncludeLogsheetTab','AutoResizeChildren','off','SizeChangedFcn',@specifyTrialsResize);
newHandles.Include.StructTab=uitab(newHandles.Include.logStructTabGroup,'Title','Structure','AutoResizeChildren','off','Tag','IncludeStructTab','SizeChangedFcn',@specifyTrialsResize);
newHandles.Include.UpArrowButton=uibutton(newHandles.Top.includeTab,'push','Text',{'/\';'||'},'Tag','IncludeUpArrowButton','ButtonPushedFcn',@(includeUpArrowButton,event) includeUpArrowButtonPushed(includeUpArrowButton));
newHandles.Include.DownArrowButton=uibutton(newHandles.Top.includeTab,'push','Text',{'||';'\/'},'Tag','IncludeDownArrowButton','ButtonPushedFcn',@(includeDownArrowButton,event) includeDownArrowButtonPushed(includeDownArrowButton));

newHandles.Exclude.conditionLabel=uilabel(newHandles.Top.excludeTab,'Text','Condition Name','Tag','ExcludeConditionLabel');
newHandles.Exclude.conditionDropDown=uidropdown(newHandles.Top.excludeTab,'Items',{'Add Condition Name'},'Tag','ExcludeConditionDropDown','ValueChangedFcn',@(excludeConditionDropDown,event) conditionNameDropDownValueChanged(excludeConditionDropDown));
newHandles.Exclude.addConditionButton=uibutton(newHandles.Top.excludeTab,'Text','+','Tag','ExcludeAddConditionButton','Tooltip','Add New Exclusion Condition','ButtonPushedFcn',@(excludeAddConditionButton,event) addConditionNameButtonPushed(excludeAddConditionButton));
newHandles.Exclude.removeConditionButton=uibutton(newHandles.Top.excludeTab,'Text','-','Tag','ExcludeRemoveConditionButton','Tooltip','Remove Exclusion Condition','ButtonPushedFcn',@(excludeRemoveConditionButton,event) removeConditionNameButtonPushed(excludeRemoveConditionButton));
newHandles.Exclude.logStructTabGroup=uitabgroup(newHandles.Top.excludeTab,'AutoResizeChildren','off');
newHandles.Exclude.LogTab=uitab(newHandles.Exclude.logStructTabGroup,'Title','Logsheet','AutoResizeChildren','off','Tag','ExcludeLogsheetTab','SizeChangedFcn',@specifyTrialsResize);
newHandles.Exclude.StructTab=uitab(newHandles.Exclude.logStructTabGroup,'Title','Structure','AutoResizeChildren','off','Tag','ExcludeStructTab','SizeChangedFcn',@specifyTrialsResize);
newHandles.Exclude.UpArrowButton=uibutton(newHandles.Top.excludeTab,'push','Text',{'/\';'||'},'Tag','ExcludeUpArrowButton','ButtonPushedFcn',@(excludeUpArrowButton,event) excludeUpArrowButtonPushed(excludeUpArrowButton));
newHandles.Exclude.DownArrowButton=uibutton(newHandles.Top.excludeTab,'push','Text',{'||';'\/'},'Tag','ExcludeDownArrowButton','ButtonPushedFcn',@(excludeDownArrowButton,event) excludeDownArrowButtonPushed(excludeDownArrowButton));

Q.UserData=struct('IncludeExcludeTabGroup',newHandles.Top.includeExcludeTabGroup,'SpecifyTrialsLabel',newHandles.Top.specifyTrialsLabel,'SpecifyTrialsDropDown',newHandles.Top.specifyTrialsDropDown,'SpecifyTrialsDropDownAdd',newHandles.Top.specifyTrialsDropDownAdd,'SpecifyTrialsDropDownRemove',newHandles.Top.specifyTrialsDropDownRemove,...
    'IncludeConditionLabel',newHandles.Include.conditionLabel,'IncludeConditionDropDown',newHandles.Include.conditionDropDown,'IncludeAddConditionButton',newHandles.Include.addConditionButton,'IncludeRemoveConditionButton',newHandles.Include.removeConditionButton,'IncludeLogStructTabGroup',newHandles.Include.logStructTabGroup,...
    'ExcludeConditionLabel',newHandles.Exclude.conditionLabel,'ExcludeConditionDropDown',newHandles.Exclude.conditionDropDown,'ExcludeAddConditionButton',newHandles.Exclude.addConditionButton,'ExcludeRemoveConditionButton',newHandles.Exclude.removeConditionButton,'ExcludeLogStructTabGroup',newHandles.Exclude.logStructTabGroup,...
    'IncludeUpArrowButton',newHandles.Include.UpArrowButton,'IncludeDownArrowButton',newHandles.Include.DownArrowButton,'ExcludeUpArrowButton',newHandles.Exclude.UpArrowButton,'ExcludeDownArrowButton',newHandles.Exclude.DownArrowButton);

specifyTrialsResize(Q); % Initialize all components' positions.

specifyTrialsNames=dir([getappdata(fig,'codePath') 'SpecifyTrials']);
specifyTrialsNames={specifyTrialsNames.name};

if isequal(tabName,'Process')
    specifyTrialsName=Digraph.Nodes.SpecifyTrials{nodeRow};
elseif isequal(tabName,'Plot')
    Plotting=getappdata(fig,'Plotting');
    if isempty(handles.Plot.plotFcnUITree.SelectedNodes)
        close(Q);
        disp('Select a plot!');
        return;
    end
    plotName=handles.Plot.plotFcnUITree.SelectedNodes.Text;
    if ~isfield(Plotting.Plots.(plotName),'SpecifyTrials')
        specifyTrialsName=specifyTrialsNames{1};
    else
        specifyTrialsName=Plotting.Plots.(plotName).SpecifyTrials;
    end
elseif isequal(tabName,'Import')
    specifyTrialsName=Digraph.Nodes.SpecifyTrials{1};
elseif isequal(tabName,'Stats')
    % HERE I NEED TO DISTINGUISH BETWEEN STATS TABLES AND PUBLICATION TABLES TO STORE & RETRIEVE THE PROPER SPECIFY TRIALS.
    pubTableFig=findall(0,'Type','Figure','Name','Edit Pub Table');
    Stats=getappdata(fig,'Stats');
    if isempty(pubTableFig)        
        if isempty(handles.Stats.tablesUITree.SelectedNodes)
            close(Q);
            disp('Select a table!');
            return;
        end
        tableName=handles.Stats.tablesUITree.SelectedNodes.Text;
        if ~isfield(Stats.Tables.(tableName),'SpecifyTrials')
            specifyTrialsName=specifyTrialsNames{1};
        else
            specifyTrialsName=Stats.Tables.(tableName).SpecifyTrials;
        end
    else
        coords=pubTableButton.Parent.Tag(2:end-1);
        coordsSplit=strsplit(coords,',');
        r=str2double(coordsSplit{1});
        c=str2double(coordsSplit{2});
        if isempty(handles.Stats.pubTablesUITree.SelectedNodes)
            close(Q);
            disp('Select a pub table!');
            return;
        end
        pubTableName=handles.Stats.pubTablesUITree.SelectedNodes.Text;
        if isempty(Stats.PubTables.(pubTableName).Cells(r,c).SpecifyTrials)
            specifyTrialsName=specifyTrialsNames{1};
        else
            specifyTrialsName=Stats.PubTables.(pubTableName).Cells(r,c).SpecifyTrials;
        end
        setappdata(Q,'rowNum',r);
        setappdata(Q,'colNum',c);
    end
end

varNamesIdx=false(length(specifyTrialsNames),1);
for i=1:length(specifyTrialsNames)
    varNamesIdx(i)=isvarname(specifyTrialsNames{i}(1:end-2));
end
for i=1:length(specifyTrialsNames)
    specifyTrialsNames{i}=specifyTrialsNames{i}(1:end-2);
end
specifyTrialsNames=specifyTrialsNames(varNamesIdx);

null=false;
if all(cellfun(@isempty,specifyTrialsNames))
    specifyTrialsName='Add Specify Trials Version';
    specifyTrialsNames={'Add Specify Trials Version'};
    null=true;
elseif isempty(specifyTrialsName)
    specifyTrialsName=specifyTrialsNames{1};
end

if ~ismember(specifyTrialsName,specifyTrialsNames)
    disp('Specify trials file deleted! Defaulting to the first item in the list');
    specifyTrialsName=specifyTrialsNames{1};
%     return;
end

newHandles.Top.specifyTrialsDropDown.Items=specifyTrialsNames;
newHandles.Top.specifyTrialsDropDown.Value=specifyTrialsName;

setappdata(Q,'handles',newHandles);
setappdata(Q,'nodeRow',nodeRow);

if ~null
    specifyTrialsVersionDropDownValueChanged(Q);
end
