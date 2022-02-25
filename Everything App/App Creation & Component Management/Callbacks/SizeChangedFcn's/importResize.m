function [fontSizeRelToHeight]=importResize(src, event)

%% PURPOSE: RESIZE THE COMPONENTS WITHIN THE IMPORT TAB

data=src.UserData; % Get UserData to access components.

if isempty(data)
    return; % Called on uifigure creation
end

% Set components to be invisible

% Modify component location
figSize=src.Position(3:4); % Width x height

% Identify the ratio of font size to figure height (will likely be different for each computer). Used to scale the font size.
fig=ancestor(src,'figure','toplevel');
ancSize=fig.Position(3:4);
defaultPos=get(0,'defaultfigureposition');
if isequal(ancSize,defaultPos(3:4)) % If currently in default figure size
    if ~isempty(getappdata(fig,'fontSizeRelToHeight')) % If the figure has been restored to default size after previously being resized.
        fontSizeRelToHeight=getappdata(fig,'fontSizeRelToHeight'); % Get the original ratio.
    else % Figure initialized as default size
        initFontSize=get(data.LogsheetPathField,'FontSize'); % Get the initial font size
        fontSizeRelToHeight=initFontSize/ancSize(2); % Font size relative to figure height.
        setappdata(fig,'fontSizeRelToHeight',fontSizeRelToHeight); % Store the font size relative to figure height.
    end    
else
    fontSizeRelToHeight=getappdata(fig,'fontSizeRelToHeight');
end

% Set new font size
newFontSize=round(fontSizeRelToHeight*ancSize(2)); % Multiply relative font size by the figure's height

if newFontSize>20
    newFontSize=20; % Cap the font size (and therefore the text box/button sizes too)
end

%% Positions specified as relative to tab width & height
% All positions here are specified as relative positions
projectNameLabelRelPos=[0.02 0.9];
logsheetNameButtonRelPos=[0.02 0.85];
dataPathButtonRelPos=[0.02 0.8];
codePathButtonRelPos=[0.02 0.75];
% projectNameEditFieldRelPos=[0.2 0.9]; % Width (relative) by height (relative)
logsheetNameEditFieldRelPos=[0.2 0.85];
dataPathEditFieldRelPos=[0.2 0.8];
codePathEditFieldRelPos=[0.2 0.75];
openImportMetadataButtonRelPos=[0.65 0.7];
openSpecifyTrialsButtonRelPos=[0.08 0.65];
projectDropDownRelPos=[0.2 0.9];
runImportButtonRelPos=[0.75 0.2];
redoImportCheckboxRelPos=[0.7 0.85];
dataTypeImportSettingsDropDownRelPos=[0.65 0.75];
logsheetLabelRelPos=[0.5 0.6];
numHeaderRowsLabelRelPos=[0.5 0.55];
numHeaderRowsFieldRelPos=[0.7 0.55];
subjectIDColHeaderLabelRelPos=[0.5 0.5];
subjectIDColHeaderFieldRelPos=[0.7 0.5];
trialIDColHeaderDataTypeLabelRelPos=[0.5 0.45];
trialIDColHeaderDataTypeFieldRelPos=[0.7 0.45];
targetTrialIDColHeaderLabelRelPos=[0.5 0.35];
targetTrialIDColHeaderFieldRelPos=[0.7 0.35];
% saveAllButtonRelPos=[0.75 0.25];
selectDataPanelRelPos=[0.05 0.05];
dataTypeImportMethodFieldRelPos=[0.93 0.75];
addDataTypeButtonRelPos=[0.65 0.8];
openImportFcnButtonRelPos=[0.65 0.65];
addProjectButtonRelPos=[0.55 0.9];
openLogsheetButtonRelPos=[0.55 0.85];
openDataPathButtonRelPos=[0.55 0.8];
openCodePathButtonRelPos=[0.55 0.75];
% openLogsheet2StructButtonRelPos=[0.65 0.9];
loadLabelRelPos=[0.07 0.5];
offloadLabelRelPos=[0.13 0.5];
dataLabelRelPos=[0.25 0.5];
dataPanelUpArrowButtonRelPos=[0.4 0.49];
dataPanelDownArrowButtonRelPos=[0.4 0.05];
specifyTrialsNumberFieldRelPos=[0.5 0.65];
    
%% Component width specified relative to tab width, height is in absolute units (constant).
% All component dimensions here are specified as absolute sizes (pixels)
compHeight=round(1.67*newFontSize); % Set the component heights that involve single lines of text
projectNameLabelSize=[0.18 compHeight];
logsheetNameButtonSize=[0.17 compHeight];
dataPathButtonSize=[0.15 compHeight];
codePathButtonSize=[0.15 compHeight];
% projectNameEditFieldSize=[0.25 compHeight]; % Width (relative) by height (absolute)
logsheetNameEditFieldSize=[0.35 compHeight];
dataPathEditFieldSize=[0.35 compHeight];
codePathEditFieldSize=[0.35 compHeight];
openImportMetadataButtonSize=[0.2 compHeight];
openSpecifyTrialsButtonSize=[0.4 compHeight];
projectDropDownSize=[0.35 compHeight];
runImportButtonSize=[0.2 compHeight];
redoImportCheckboxSize=[0.3 compHeight];
dataTypeImportSettingsDropDownSize=[0.25 compHeight];
logsheetLabelSize=[0.2 compHeight];
numHeaderRowsLabelSize=[0.2 compHeight];
numHeaderRowsFieldSize=[0.1 compHeight];
subjectIDColHeaderLabelSize=[0.2 compHeight];
subjectIDColHeaderFieldSize=[0.2 compHeight];
trialIDColHeaderDataTypeLabelSize=[0.2 compHeight];
trialIDColHeaderDataTypeFieldSize=[0.2 compHeight];
targetTrialIDColHeaderLabelSize=[0.2 compHeight];
targetTrialIDColHeaderFieldSize=[0.2 compHeight];
% saveAllButtonSize=[0.2 compHeight];
selectDataPanelSize=[0.4 0.55*figSize(2)];
dataTypeImportMethodFieldSize=[0.05 compHeight];
addDataTypeButtonSize=[0.2 compHeight];
openImportFcnButtonSize=[0.2 compHeight];
addProjectButtonSize=[0.05 compHeight];
openLogsheetButtonSize=[0.05 compHeight];
openDataPathButtonSize=[0.05 compHeight];
openCodePathButtonSize=[0.05 compHeight];
% openLogsheet2StructButtonSize=[0.3 compHeight];
loadLabelSize=[0.05 compHeight];
offloadLabelSize=[0.1 compHeight];
dataLabelSize=[0.05 compHeight];
dataPanelUpArrowButtonSize=[0.05 compHeight*1.67];
dataPanelDownArrowButtonSize=[0.05 compHeight*1.67];
specifyTrialsNumberFieldSize=[0.05 compHeight];

%% Multiply the relative positions by the figure size to get the actual position.
projectNameLabelPos=round([projectNameLabelRelPos.*figSize projectNameLabelSize(1)*figSize(1) projectNameLabelSize(2)]);
logsheetNameButtonPos=round([logsheetNameButtonRelPos.*figSize logsheetNameButtonSize(1)*figSize(1) logsheetNameButtonSize(2)]);
dataPathButtonPos=round([dataPathButtonRelPos.*figSize dataPathButtonSize(1)*figSize(1) dataPathButtonSize(2)]);
codePathButtonPos=round([codePathButtonRelPos.*figSize codePathButtonSize(1)*figSize(1) codePathButtonSize(2)]);
logsheetNameEditFieldPos=round([logsheetNameEditFieldRelPos.*figSize logsheetNameEditFieldSize(1)*figSize(1) logsheetNameEditFieldSize(2)]);
dataPathEditFieldPos=round([dataPathEditFieldRelPos.*figSize dataPathEditFieldSize(1)*figSize(1) dataPathEditFieldSize(2)]);
codePathEditFieldPos=round([codePathEditFieldRelPos.*figSize codePathEditFieldSize(1)*figSize(1) codePathEditFieldSize(2)]);
openImportMetadataButtonPos=round([openImportMetadataButtonRelPos.*figSize openImportMetadataButtonSize(1)*figSize(1) openImportMetadataButtonSize(2)]);
openSpecifyTrialsButtonPos=round([openSpecifyTrialsButtonRelPos.*figSize openSpecifyTrialsButtonSize(1)*figSize(1) openSpecifyTrialsButtonSize(2)]);
projectDropDownPos=round([projectDropDownRelPos.*figSize projectDropDownSize(1)*figSize(1) projectDropDownSize(2)]);
runImportButtonPos=round([runImportButtonRelPos.*figSize runImportButtonSize(1)*figSize(1) runImportButtonSize(2)]);
redoImportCheckboxPos=round([redoImportCheckboxRelPos.*figSize redoImportCheckboxSize(1)*figSize(1) redoImportCheckboxSize(2)]);
dataTypeImportSettingsDropDownPos=round([dataTypeImportSettingsDropDownRelPos.*figSize dataTypeImportSettingsDropDownSize(1)*figSize(1) dataTypeImportSettingsDropDownSize(2)]);
logsheetLabelPos=round([logsheetLabelRelPos.*figSize logsheetLabelSize(1)*figSize(1) logsheetLabelSize(2)]);
numHeaderRowsLabelPos=round([numHeaderRowsLabelRelPos.*figSize numHeaderRowsLabelSize(1)*figSize(1) numHeaderRowsLabelSize(2)]);
numHeaderRowsFieldPos=round([numHeaderRowsFieldRelPos.*figSize numHeaderRowsFieldSize(1)*figSize(1) numHeaderRowsFieldSize(2)]);
subjectIDColHeaderLabelPos=round([subjectIDColHeaderLabelRelPos.*figSize subjectIDColHeaderLabelSize(1)*figSize(1) subjectIDColHeaderLabelSize(2)]);
subjectIDColHeaderFieldPos=round([subjectIDColHeaderFieldRelPos.*figSize subjectIDColHeaderFieldSize(1)*figSize(1) subjectIDColHeaderFieldSize(2)]);
trialIDColHeaderDataTypeLabelPos=round([trialIDColHeaderDataTypeLabelRelPos.*figSize trialIDColHeaderDataTypeLabelSize(1)*figSize(1) trialIDColHeaderDataTypeLabelSize(2)]);
trialIDColHeaderDataTypeFieldPos=round([trialIDColHeaderDataTypeFieldRelPos.*figSize trialIDColHeaderDataTypeFieldSize(1)*figSize(1) trialIDColHeaderDataTypeFieldSize(2)]);
targetTrialIDColHeaderLabelPos=round([targetTrialIDColHeaderLabelRelPos.*figSize targetTrialIDColHeaderLabelSize(1)*figSize(1) targetTrialIDColHeaderLabelSize(2)]);
targetTrialIDColHeaderFieldPos=round([targetTrialIDColHeaderFieldRelPos.*figSize targetTrialIDColHeaderFieldSize(1)*figSize(1) targetTrialIDColHeaderFieldSize(2)]);
% saveAllButtonPos=round([saveAllButtonRelPos.*figSize saveAllButtonSize(1)*figSize(1) saveAllButtonSize(2)]);
selectDataPanelPos=round([selectDataPanelRelPos.*figSize selectDataPanelSize(1)*figSize(1) selectDataPanelSize(2)]);
dataTypeImportMethodFieldPos=round([dataTypeImportMethodFieldRelPos.*figSize dataTypeImportMethodFieldSize(1)*figSize(1) dataTypeImportMethodFieldSize(2)]);
addDataTypeButtonPos=round([addDataTypeButtonRelPos.*figSize addDataTypeButtonSize(1)*figSize(1) addDataTypeButtonSize(2)]);
openImportFcnButtonPos=round([openImportFcnButtonRelPos.*figSize openImportFcnButtonSize(1)*figSize(1) openImportFcnButtonSize(2)]);
addProjectButtonPos=round([addProjectButtonRelPos.*figSize addProjectButtonSize(1)*figSize(1) addProjectButtonSize(2)]);
openLogsheetButtonPos=round([openLogsheetButtonRelPos.*figSize openLogsheetButtonSize(1)*figSize(1) openLogsheetButtonSize(2)]);
openDataPathButtonPos=round([openDataPathButtonRelPos.*figSize openDataPathButtonSize(1)*figSize(1) openDataPathButtonSize(2)]);
openCodePathButtonPos=round([openCodePathButtonRelPos.*figSize openCodePathButtonSize(1)*figSize(1) openCodePathButtonSize(2)]);
% openLogsheet2StructButtonPos=round([openLogsheet2StructButtonRelPos.*figSize openLogsheet2StructButtonSize(1)*figSize(1) openLogsheet2StructButtonSize(2)]);
loadLabelPos=round([loadLabelRelPos.*figSize loadLabelSize(1)*figSize(1) loadLabelSize(2)]);
offloadLabelPos=round([offloadLabelRelPos.*figSize offloadLabelSize(1)*figSize(1) offloadLabelSize(2)]);
dataLabelPos=round([dataLabelRelPos.*figSize dataLabelSize(1)*figSize(1) dataLabelSize(2)]);
dataPanelUpArrowButtonPos=round([dataPanelUpArrowButtonRelPos.*figSize dataPanelUpArrowButtonSize(1)*figSize(1) dataPanelUpArrowButtonSize(2)]);
dataPanelDownArrowButtonPos=round([dataPanelDownArrowButtonRelPos.*figSize dataPanelDownArrowButtonSize(1)*figSize(1) dataPanelDownArrowButtonSize(2)]);
specifyTrialsNumberFieldPos=round([specifyTrialsNumberFieldRelPos.*figSize specifyTrialsNumberFieldSize(1)*figSize(1) specifyTrialsNumberFieldSize(2)]);

%% Set the actual positions for each component
data.ProjectNameLabel.Position=projectNameLabelPos;
data.LogsheetPathButton.Position=logsheetNameButtonPos;
data.DataPathButton.Position=dataPathButtonPos;
data.CodePathButton.Position=codePathButtonPos;
data.LogsheetPathField.Position=logsheetNameEditFieldPos;
data.DataPathField.Position=dataPathEditFieldPos;
data.CodePathField.Position=codePathEditFieldPos;
data.OpenImportMetadataButton.Position=openImportMetadataButtonPos;
data.OpenSpecifyTrialsButton.Position=openSpecifyTrialsButtonPos;
data.SwitchProjectsDropDown.Position=projectDropDownPos;
data.RunImportButton.Position=runImportButtonPos;
data.RedoImportCheckBox.Position=redoImportCheckboxPos;
data.DataTypeImportSettingsDropDown.Position=dataTypeImportSettingsDropDownPos;
data.LogsheetLabel.Position=logsheetLabelPos;
data.NumHeaderRowsLabel.Position=numHeaderRowsLabelPos;
data.NumHeaderRowsField.Position=numHeaderRowsFieldPos;
data.SubjectIDColHeaderLabel.Position=subjectIDColHeaderLabelPos;
data.SubjectIDColHeaderField.Position=subjectIDColHeaderFieldPos;
data.TrialIDColHeaderDataTypeLabel.Position=trialIDColHeaderDataTypeLabelPos;
data.TrialIDColHeaderDataTypeField.Position=trialIDColHeaderDataTypeFieldPos;
data.TargetTrialIDColHeaderLabel.Position=targetTrialIDColHeaderLabelPos;
data.TargetTrialIDColHeaderField.Position=targetTrialIDColHeaderFieldPos;
% data.SaveAllButton.Position=saveAllButtonPos;
data.SelectDataPanel.Position=selectDataPanelPos;
data.DataTypeImportMethodField.Position=dataTypeImportMethodFieldPos;
data.AddDataTypeButton.Position=addDataTypeButtonPos;
data.OpenImportFcnButton.Position=openImportFcnButtonPos;
data.AddProjectButton.Position=addProjectButtonPos;
data.OpenLogsheetButton.Position=openLogsheetButtonPos;
data.OpenDataPathButton.Position=openDataPathButtonPos;
data.OpenCodePathButton.Position=openCodePathButtonPos;
% data.OpenLogsheet2StructButton.Position=openLogsheet2StructButtonPos;
data.LoadLabel.Position=loadLabelPos;
data.OffloadLabel.Position=offloadLabelPos;
data.DataLabel.Position=dataLabelPos;
data.DataPanelUpArrowButton.Position=dataPanelUpArrowButtonPos;
data.DataPanelDownArrowButton.Position=dataPanelDownArrowButtonPos;
data.SpecifyTrialsNumberField.Position=specifyTrialsNumberFieldPos;

%% Set the font sizes for all components that use text
data.ProjectNameLabel.FontSize=newFontSize;
data.LogsheetPathButton.FontSize=newFontSize;
data.DataPathButton.FontSize=newFontSize;
data.CodePathButton.FontSize=newFontSize;
data.LogsheetPathField.FontSize=newFontSize;
data.DataPathField.FontSize=newFontSize;
data.CodePathField.FontSize=newFontSize;
data.OpenImportMetadataButton.FontSize=newFontSize;
data.OpenSpecifyTrialsButton.FontSize=newFontSize;
data.SwitchProjectsDropDown.FontSize=newFontSize;
data.RunImportButton.FontSize=newFontSize;
data.RedoImportCheckBox.FontSize=newFontSize;
data.DataTypeImportSettingsDropDown.FontSize=newFontSize;
data.LogsheetLabel.FontSize=newFontSize;
data.NumHeaderRowsLabel.FontSize=newFontSize;
data.NumHeaderRowsField.FontSize=newFontSize;
data.SubjectIDColHeaderLabel.FontSize=newFontSize;
data.SubjectIDColHeaderField.FontSize=newFontSize;
data.TrialIDColHeaderDataTypeLabel.FontSize=newFontSize;
data.TrialIDColHeaderDataTypeField.FontSize=newFontSize;
data.TargetTrialIDColHeaderLabel.FontSize=newFontSize;
data.TargetTrialIDColHeaderField.FontSize=newFontSize;
% data.SaveAllButton.FontSize=newFontSize;
data.SelectDataPanel.FontSize=newFontSize;
data.DataTypeImportMethodField.FontSize=newFontSize;
data.AddDataTypeButton.FontSize=newFontSize;
data.OpenImportFcnButton.FontSize=newFontSize;
data.AddProjectButton.FontSize=newFontSize;
data.OpenLogsheetButton.FontSize=newFontSize;
data.OpenDataPathButton.FontSize=newFontSize;
data.OpenCodePathButton.FontSize=newFontSize;
% data.OpenLogsheet2StructButton.FontSize=newFontSize;
data.LoadLabel.FontSize=newFontSize;
data.OffloadLabel.FontSize=newFontSize;
data.DataLabel.FontSize=newFontSize;
data.DataPanelUpArrowButton.FontSize=newFontSize;
data.DataPanelDownArrowButton.FontSize=newFontSize;
data.SpecifyTrialsNumberField.FontSize=newFontSize;

% Restore component visibility