function [fontSizeRelToHeight]=importResize(src, event)

%% PURPOSE: RESIZE THE COMPONENTS WITHIN THE IMPORT TAB

data=src.UserData; % Get UserData to access components.
if isempty(data)
    return; % Called on uifigure creation
end

% Modify component location
figSize=src.Position(3:4); % Width x height

% Identify the ratio of font size to figure height (will likely be different for each computer). Used to scale the font size.
fig=ancestor(src,'figure','toplevel');
ancSize=fig.Position(3:4);
defaultPos=get(0,'defaultfigureposition');
if isequal(ancSize,[defaultPos(3)*2 defaultPos(4)]) % If currently in default figure size
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
newFontSize=round(fontSizeRelToHeight*ancSize(2)); % Multiply relative font size by the figures height
if newFontSize>20
    newFontSize=20; % Cap the font size (and therefore the text box/button sizes too)
end

%% Positions specified as relative to tab width & height
% All positions here are specified as relative positions
ProjectNameLabelRelPos=[0.01 0.95];
LogsheetPathButtonRelPos=[0.01 0.9];
DataPathButtonRelPos=[0.01 0.85];
CodePathButtonRelPos=[0.01 0.8];
AddProjectButtonRelPos=[0.37 0.95];
LogsheetPathFieldRelPos=[0.17 0.9];
DataPathFieldRelPos=[0.17 0.85];
CodePathFieldRelPos=[0.17 0.8];
OpenSpecifyTrialsButtonRelPos=[0.53 0.02];
SwitchProjectsDropDownRelPos=[0.17 0.95];
RunImportButtonRelPos=[0.75 0.02];
LogsheetLabelRelPos=[0.5 0.95];
NumHeaderRowsLabelRelPos=[0.6 0.95];
NumHeaderRowsFieldRelPos=[0.76 0.95];
SubjectIDColHeaderLabelRelPos=[0.5 0.9];
SubjectIDColHeaderFieldRelPos=[0.76 0.9];
TrialIDColHeaderDataTypeLabelRelPos=[0.5 0.85];
TrialIDColHeaderDataTypeFieldRelPos=[0.76 0.85];
TargetTrialIDColHeaderLabelRelPos=[0.5 0.8];
TargetTrialIDColHeaderFieldRelPos=[0.76 0.8];
ArchiveImportFcnButtonRelPos=[0.01 0.15];
NewImportFcnButtonRelPos=[0.01 0.65];
OpenLogsheetButtonRelPos=[0.37 0.9];
OpenDataPathButtonRelPos=[0.37 0.85];
OpenCodePathButtonRelPos=[0.37 0.8];
ArchiveProjectButtonRelPos=[0.43 0.95];
FunctionsUITreeLabelRelPos=[0.12 0.75];
ArgumentsUITreeLabelRelPos=[0.34 0.75];
FunctionsSearchBarEditFieldRelPos=[0.07 0.7];
ArgumentsSearchBarEditFieldRelPos=[0.3 0.7];
FunctionsUITreeRelPos=[0.07 0.02];
ArgumentsUITreeRelPos=[0.3 0.02];
GroupFunctionDescriptionTextAreaLabelRelPos=[0.55 0.75];
GroupFunctionDescriptionTextAreaRelPos=[0.55 0.45];
UnarchiveImportFcnButtonRelPos=[0.01 0.1];
ArgumentDescriptionTextAreaLabelRelPos=[0.55 0.4];
ArgumentDescriptionTextAreaRelPos=[0.55 0.1];
UnarchiveProjectButtonRelPos=[0.43 0.9];

%% Component width specified relative to tab width, height is in absolute units (constant).
% All component dimensions here are specified as absolute sizes (pixels)
compHeight=round(1.67*newFontSize); % Set the component heights that involve single lines of text}
ProjectNameLabelSize=[0.15 compHeight];
LogsheetPathButtonSize=[0.15 compHeight];
DataPathButtonSize=[0.15 compHeight];
CodePathButtonSize=[0.15 compHeight];
AddProjectButtonSize=[0.05 compHeight];
LogsheetPathFieldSize=[0.2 compHeight];
DataPathFieldSize=[0.2 compHeight];
CodePathFieldSize=[0.2 compHeight];
OpenSpecifyTrialsButtonSize=[0.2 compHeight];
SwitchProjectsDropDownSize=[0.2 compHeight];
RunImportButtonSize=[0.2 compHeight];
LogsheetLabelSize=[0.2 compHeight];
NumHeaderRowsLabelSize=[0.2 compHeight];
NumHeaderRowsFieldSize=[0.08 compHeight];
SubjectIDColHeaderLabelSize=[0.25 compHeight];
SubjectIDColHeaderFieldSize=[0.2 compHeight];
TrialIDColHeaderDataTypeLabelSize=[0.25 compHeight];
TrialIDColHeaderDataTypeFieldSize=[0.2 compHeight];
TargetTrialIDColHeaderLabelSize=[0.25 compHeight];
TargetTrialIDColHeaderFieldSize=[0.2 compHeight];
ArchiveImportFcnButtonSize=[0.06 compHeight];
NewImportFcnButtonSize=[0.06 compHeight];
OpenLogsheetButtonSize=[0.05 compHeight];
OpenDataPathButtonSize=[0.05 compHeight];
OpenCodePathButtonSize=[0.05 compHeight];
ArchiveProjectButtonSize=[0.06 compHeight];
FunctionsUITreeLabelSize=[0.2 compHeight];
ArgumentsUITreeLabelSize=[0.2 compHeight];
FunctionsSearchBarEditFieldSize=[0.2 compHeight];
ArgumentsSearchBarEditFieldSize=[0.2 compHeight];
FunctionsUITreeSize=[0.2 0.68*figSize(2)];
ArgumentsUITreeSize=[0.2 0.68*figSize(2)];
GroupFunctionDescriptionTextAreaLabelSize=[0.3 compHeight];
GroupFunctionDescriptionTextAreaSize=[0.4 0.3*figSize(2)];
UnarchiveImportFcnButtonSize=[0.06 compHeight];
ArgumentDescriptionTextAreaLabelSize=[0.3 compHeight];
ArgumentDescriptionTextAreaSize=[0.4 0.3*figSize(2)];
UnarchiveProjectButtonSize=[0.06 compHeight];

%% Multiply the relative positions by the figure size to get the actual position.}
ProjectNameLabelPos=round([ProjectNameLabelRelPos.*figSize ProjectNameLabelSize(1)*figSize(1) ProjectNameLabelSize(2)]);
LogsheetPathButtonPos=round([LogsheetPathButtonRelPos.*figSize LogsheetPathButtonSize(1)*figSize(1) LogsheetPathButtonSize(2)]);
DataPathButtonPos=round([DataPathButtonRelPos.*figSize DataPathButtonSize(1)*figSize(1) DataPathButtonSize(2)]);
CodePathButtonPos=round([CodePathButtonRelPos.*figSize CodePathButtonSize(1)*figSize(1) CodePathButtonSize(2)]);
AddProjectButtonPos=round([AddProjectButtonRelPos.*figSize AddProjectButtonSize(1)*figSize(1) AddProjectButtonSize(2)]);
LogsheetPathFieldPos=round([LogsheetPathFieldRelPos.*figSize LogsheetPathFieldSize(1)*figSize(1) LogsheetPathFieldSize(2)]);
DataPathFieldPos=round([DataPathFieldRelPos.*figSize DataPathFieldSize(1)*figSize(1) DataPathFieldSize(2)]);
CodePathFieldPos=round([CodePathFieldRelPos.*figSize CodePathFieldSize(1)*figSize(1) CodePathFieldSize(2)]);
OpenSpecifyTrialsButtonPos=round([OpenSpecifyTrialsButtonRelPos.*figSize OpenSpecifyTrialsButtonSize(1)*figSize(1) OpenSpecifyTrialsButtonSize(2)]);
SwitchProjectsDropDownPos=round([SwitchProjectsDropDownRelPos.*figSize SwitchProjectsDropDownSize(1)*figSize(1) SwitchProjectsDropDownSize(2)]);
RunImportButtonPos=round([RunImportButtonRelPos.*figSize RunImportButtonSize(1)*figSize(1) RunImportButtonSize(2)]);
LogsheetLabelPos=round([LogsheetLabelRelPos.*figSize LogsheetLabelSize(1)*figSize(1) LogsheetLabelSize(2)]);
NumHeaderRowsLabelPos=round([NumHeaderRowsLabelRelPos.*figSize NumHeaderRowsLabelSize(1)*figSize(1) NumHeaderRowsLabelSize(2)]);
NumHeaderRowsFieldPos=round([NumHeaderRowsFieldRelPos.*figSize NumHeaderRowsFieldSize(1)*figSize(1) NumHeaderRowsFieldSize(2)]);
SubjectIDColHeaderLabelPos=round([SubjectIDColHeaderLabelRelPos.*figSize SubjectIDColHeaderLabelSize(1)*figSize(1) SubjectIDColHeaderLabelSize(2)]);
SubjectIDColHeaderFieldPos=round([SubjectIDColHeaderFieldRelPos.*figSize SubjectIDColHeaderFieldSize(1)*figSize(1) SubjectIDColHeaderFieldSize(2)]);
TrialIDColHeaderDataTypeLabelPos=round([TrialIDColHeaderDataTypeLabelRelPos.*figSize TrialIDColHeaderDataTypeLabelSize(1)*figSize(1) TrialIDColHeaderDataTypeLabelSize(2)]);
TrialIDColHeaderDataTypeFieldPos=round([TrialIDColHeaderDataTypeFieldRelPos.*figSize TrialIDColHeaderDataTypeFieldSize(1)*figSize(1) TrialIDColHeaderDataTypeFieldSize(2)]);
TargetTrialIDColHeaderLabelPos=round([TargetTrialIDColHeaderLabelRelPos.*figSize TargetTrialIDColHeaderLabelSize(1)*figSize(1) TargetTrialIDColHeaderLabelSize(2)]);
TargetTrialIDColHeaderFieldPos=round([TargetTrialIDColHeaderFieldRelPos.*figSize TargetTrialIDColHeaderFieldSize(1)*figSize(1) TargetTrialIDColHeaderFieldSize(2)]);
ArchiveImportFcnButtonPos=round([ArchiveImportFcnButtonRelPos.*figSize ArchiveImportFcnButtonSize(1)*figSize(1) ArchiveImportFcnButtonSize(2)]);
NewImportFcnButtonPos=round([NewImportFcnButtonRelPos.*figSize NewImportFcnButtonSize(1)*figSize(1) NewImportFcnButtonSize(2)]);
OpenLogsheetButtonPos=round([OpenLogsheetButtonRelPos.*figSize OpenLogsheetButtonSize(1)*figSize(1) OpenLogsheetButtonSize(2)]);
OpenDataPathButtonPos=round([OpenDataPathButtonRelPos.*figSize OpenDataPathButtonSize(1)*figSize(1) OpenDataPathButtonSize(2)]);
OpenCodePathButtonPos=round([OpenCodePathButtonRelPos.*figSize OpenCodePathButtonSize(1)*figSize(1) OpenCodePathButtonSize(2)]);
ArchiveProjectButtonPos=round([ArchiveProjectButtonRelPos.*figSize ArchiveProjectButtonSize(1)*figSize(1) ArchiveProjectButtonSize(2)]);
FunctionsUITreeLabelPos=round([FunctionsUITreeLabelRelPos.*figSize FunctionsUITreeLabelSize(1)*figSize(1) FunctionsUITreeLabelSize(2)]);
ArgumentsUITreeLabelPos=round([ArgumentsUITreeLabelRelPos.*figSize ArgumentsUITreeLabelSize(1)*figSize(1) ArgumentsUITreeLabelSize(2)]);
FunctionsSearchBarEditFieldPos=round([FunctionsSearchBarEditFieldRelPos.*figSize FunctionsSearchBarEditFieldSize(1)*figSize(1) FunctionsSearchBarEditFieldSize(2)]);
ArgumentsSearchBarEditFieldPos=round([ArgumentsSearchBarEditFieldRelPos.*figSize ArgumentsSearchBarEditFieldSize(1)*figSize(1) ArgumentsSearchBarEditFieldSize(2)]);
FunctionsUITreePos=round([FunctionsUITreeRelPos.*figSize FunctionsUITreeSize(1)*figSize(1) FunctionsUITreeSize(2)]);
ArgumentsUITreePos=round([ArgumentsUITreeRelPos.*figSize ArgumentsUITreeSize(1)*figSize(1) ArgumentsUITreeSize(2)]);
GroupFunctionDescriptionTextAreaLabelPos=round([GroupFunctionDescriptionTextAreaLabelRelPos.*figSize GroupFunctionDescriptionTextAreaLabelSize(1)*figSize(1) GroupFunctionDescriptionTextAreaLabelSize(2)]);
GroupFunctionDescriptionTextAreaPos=round([GroupFunctionDescriptionTextAreaRelPos.*figSize GroupFunctionDescriptionTextAreaSize(1)*figSize(1) GroupFunctionDescriptionTextAreaSize(2)]);
UnarchiveImportFcnButtonPos=round([UnarchiveImportFcnButtonRelPos.*figSize UnarchiveImportFcnButtonSize(1)*figSize(1) UnarchiveImportFcnButtonSize(2)]);
ArgumentDescriptionTextAreaLabelPos=round([ArgumentDescriptionTextAreaLabelRelPos.*figSize ArgumentDescriptionTextAreaLabelSize(1)*figSize(1) ArgumentDescriptionTextAreaLabelSize(2)]);
ArgumentDescriptionTextAreaPos=round([ArgumentDescriptionTextAreaRelPos.*figSize ArgumentDescriptionTextAreaSize(1)*figSize(1) ArgumentDescriptionTextAreaSize(2)]);
UnarchiveProjectButtonPos=round([UnarchiveProjectButtonRelPos.*figSize UnarchiveProjectButtonSize(1)*figSize(1) UnarchiveProjectButtonSize(2)]);

data.ProjectNameLabel.Position=ProjectNameLabelPos;
data.LogsheetPathButton.Position=LogsheetPathButtonPos;
data.DataPathButton.Position=DataPathButtonPos;
data.CodePathButton.Position=CodePathButtonPos;
data.AddProjectButton.Position=AddProjectButtonPos;
data.LogsheetPathField.Position=LogsheetPathFieldPos;
data.DataPathField.Position=DataPathFieldPos;
data.CodePathField.Position=CodePathFieldPos;
data.OpenSpecifyTrialsButton.Position=OpenSpecifyTrialsButtonPos;
data.SwitchProjectsDropDown.Position=SwitchProjectsDropDownPos;
data.RunImportButton.Position=RunImportButtonPos;
data.LogsheetLabel.Position=LogsheetLabelPos;
data.NumHeaderRowsLabel.Position=NumHeaderRowsLabelPos;
data.NumHeaderRowsField.Position=NumHeaderRowsFieldPos;
data.SubjectIDColHeaderLabel.Position=SubjectIDColHeaderLabelPos;
data.SubjectIDColHeaderField.Position=SubjectIDColHeaderFieldPos;
data.TrialIDColHeaderDataTypeLabel.Position=TrialIDColHeaderDataTypeLabelPos;
data.TrialIDColHeaderDataTypeField.Position=TrialIDColHeaderDataTypeFieldPos;
data.TargetTrialIDColHeaderLabel.Position=TargetTrialIDColHeaderLabelPos;
data.TargetTrialIDColHeaderField.Position=TargetTrialIDColHeaderFieldPos;
data.ArchiveImportFcnButton.Position=ArchiveImportFcnButtonPos;
data.NewImportFcnButton.Position=NewImportFcnButtonPos;
data.OpenLogsheetButton.Position=OpenLogsheetButtonPos;
data.OpenDataPathButton.Position=OpenDataPathButtonPos;
data.OpenCodePathButton.Position=OpenCodePathButtonPos;
data.ArchiveProjectButton.Position=ArchiveProjectButtonPos;
data.FunctionsUITreeLabel.Position=FunctionsUITreeLabelPos;
data.ArgumentsUITreeLabel.Position=ArgumentsUITreeLabelPos;
data.FunctionsSearchBarEditField.Position=FunctionsSearchBarEditFieldPos;
data.ArgumentsSearchBarEditField.Position=ArgumentsSearchBarEditFieldPos;
data.FunctionsUITree.Position=FunctionsUITreePos;
data.ArgumentsUITree.Position=ArgumentsUITreePos;
data.GroupFunctionDescriptionTextAreaLabel.Position=GroupFunctionDescriptionTextAreaLabelPos;
data.GroupFunctionDescriptionTextArea.Position=GroupFunctionDescriptionTextAreaPos;
data.UnarchiveImportFcnButton.Position=UnarchiveImportFcnButtonPos;
data.ArgumentDescriptionTextAreaLabel.Position=ArgumentDescriptionTextAreaLabelPos;
data.ArgumentDescriptionTextArea.Position=ArgumentDescriptionTextAreaPos;
data.UnarchiveProjectButton.Position=UnarchiveProjectButtonPos;

data.ProjectNameLabel.FontSize=newFontSize;
data.LogsheetPathButton.FontSize=newFontSize;
data.DataPathButton.FontSize=newFontSize;
data.CodePathButton.FontSize=newFontSize;
data.AddProjectButton.FontSize=newFontSize;
data.LogsheetPathField.FontSize=newFontSize;
data.DataPathField.FontSize=newFontSize;
data.CodePathField.FontSize=newFontSize;
data.OpenSpecifyTrialsButton.FontSize=newFontSize;
data.SwitchProjectsDropDown.FontSize=newFontSize;
data.RunImportButton.FontSize=newFontSize;
data.LogsheetLabel.FontSize=newFontSize;
data.NumHeaderRowsLabel.FontSize=newFontSize;
data.NumHeaderRowsField.FontSize=newFontSize;
data.SubjectIDColHeaderLabel.FontSize=newFontSize;
data.SubjectIDColHeaderField.FontSize=newFontSize;
data.TrialIDColHeaderDataTypeLabel.FontSize=newFontSize;
data.TrialIDColHeaderDataTypeField.FontSize=newFontSize;
data.TargetTrialIDColHeaderLabel.FontSize=newFontSize;
data.TargetTrialIDColHeaderField.FontSize=newFontSize;
data.ArchiveImportFcnButton.FontSize=newFontSize;
data.NewImportFcnButton.FontSize=newFontSize;
data.OpenLogsheetButton.FontSize=newFontSize;
data.OpenDataPathButton.FontSize=newFontSize;
data.OpenCodePathButton.FontSize=newFontSize;
data.ArchiveProjectButton.FontSize=newFontSize;
data.FunctionsUITreeLabel.FontSize=newFontSize;
data.ArgumentsUITreeLabel.FontSize=newFontSize;
data.FunctionsSearchBarEditField.FontSize=newFontSize;
data.ArgumentsSearchBarEditField.FontSize=newFontSize;
data.FunctionsUITree.FontSize=newFontSize;
data.ArgumentsUITree.FontSize=newFontSize;
data.GroupFunctionDescriptionTextAreaLabel.FontSize=newFontSize;
data.GroupFunctionDescriptionTextArea.FontSize=newFontSize;
data.UnarchiveImportFcnButton.FontSize=newFontSize;
data.ArgumentDescriptionTextAreaLabel.FontSize=newFontSize;
data.ArgumentDescriptionTextArea.FontSize=newFontSize;
data.UnarchiveProjectButton.FontSize=newFontSize;

% data=src.UserData; % Get UserData to access components.
% 
% if isempty(data)
%     return; % Called on uifigure creation
% end
% 
% % Modify component location
% figSize=src.Position(3:4); % Width x height
% 
% % Identify the ratio of font size to figure height (will likely be different for each computer). Used to scale the font size.
% fig=ancestor(src,'figure','toplevel');
% ancSize=fig.Position(3:4);
% defaultPos=get(0,'defaultfigureposition');
% if isequal(ancSize,defaultPos(3:4)) % If currently in default figure size
%     if ~isempty(getappdata(fig,'fontSizeRelToHeight')) % If the figure has been restored to default size after previously being resized.
%         fontSizeRelToHeight=getappdata(fig,'fontSizeRelToHeight'); % Get the original ratio.
%     else % Figure initialized as default size
%         initFontSize=get(data.LogsheetPathField,'FontSize'); % Get the initial font size
%         fontSizeRelToHeight=initFontSize/ancSize(2); % Font size relative to figure height.
%         setappdata(fig,'fontSizeRelToHeight',fontSizeRelToHeight); % Store the font size relative to figure height.
%     end    
% else
%     fontSizeRelToHeight=getappdata(fig,'fontSizeRelToHeight');
% end
% 
% % Set new font size
% newFontSize=round(fontSizeRelToHeight*ancSize(2)); % Multiply relative font size by the figure's height
% 
% if newFontSize>20
%     newFontSize=20; % Cap the font size (and therefore the text box/button sizes too)
% end
% 
% %% Positions specified as relative to tab width & height
% % All positions here are specified as relative positions
% projectNameLabelRelPos=[0.02 0.9]; % 1
% logsheetNameButtonRelPos=[0.02 0.85]; % 2
% dataPathButtonRelPos=[0.02 0.8]; % 3
% codePathButtonRelPos=[0.02 0.75]; % 4
% logsheetNameEditFieldRelPos=[0.2 0.85]; % 5
% dataPathEditFieldRelPos=[0.2 0.8]; % 6
% codePathEditFieldRelPos=[0.2 0.75]; % 7
% openSpecifyTrialsButtonRelPos=[0.08 0.65]; % 8
% projectDropDownRelPos=[0.2 0.9]; % 10
% runImportButtonRelPos=[0.75 0.2]; % 9
% logsheetLabelRelPos=[0.5 0.6]; % 11
% numHeaderRowsLabelRelPos=[0.5 0.55]; % 12
% numHeaderRowsFieldRelPos=[0.7 0.55]; % 13
% subjectIDColHeaderLabelRelPos=[0.5 0.5]; % 14
% subjectIDColHeaderFieldRelPos=[0.7 0.5]; % 15
% trialIDColHeaderDataTypeLabelRelPos=[0.5 0.45]; % 16
% trialIDColHeaderDataTypeFieldRelPos=[0.7 0.45]; % 17
% targetTrialIDColHeaderLabelRelPos=[0.5 0.35]; % 18
% targetTrialIDColHeaderFieldRelPos=[0.7 0.35]; % 19
% newImportFcnButtonRelPos=[0.5 0.5]; % 21
% archiveImportFcnButtonRelPos=[0.5 0.5]; % 22
% addProjectButtonRelPos=[0.55 0.9]; % 23
% archiveProjectButtonRelPos=[0.5 0.5]; % 24
% openLogsheetButtonRelPos=[0.55 0.85]; % 25
% openDataPathButtonRelPos=[0.55 0.8]; % 26
% openCodePathButtonRelPos=[0.55 0.75]; % 27
% functionsUITreeLabelRelPos=[0.5 0.5]; % 28
% argumentsUITreeLabelRelPos=[0.5 0.5]; % 29
% functionsUITreeSearchBarTextBoxRelPos=[0.5 0.5]; % 30
% argumentsUITreeSearchBarTextBoxRelPos=[0.5 0.5]; % 31
% functionsUITreeRelPos=[0.5 0.5]; % 32
% argumentsUITreeRelPos=[0.5 0.5]; % 33
% groupFunctionDescriptionTextAreaLabelRelPos=[0.5 0.5]; % 34
% groupFunctionDescriptionTextAreaRelPos=[0.5 0.5]; % 35
% unarchiveImportFcnButtonRelPos=[0.5 0.5]; % 36
% argumentDescriptionTextAreaLabelRelPos=[0.5 0.5]; % 37
% argumentDescriptionTextAreaRelPos=[0.5 0.5]; % 38
%     
% %% Component width specified relative to tab width, height is in absolute units (constant).
% % All component dimensions here are specified as absolute sizes (pixels)
% compHeight=round(1.67*newFontSize); % Set the component heights that involve single lines of text
% projectNameLabelSize=[0.18 compHeight];
% logsheetNameButtonSize=[0.17 compHeight];
% dataPathButtonSize=[0.15 compHeight];
% codePathButtonSize=[0.15 compHeight];
% % projectNameEditFieldSize=[0.25 compHeight]; % Width (relative) by height (absolute)
% logsheetNameEditFieldSize=[0.35 compHeight];
% dataPathEditFieldSize=[0.35 compHeight];
% codePathEditFieldSize=[0.35 compHeight];
% openImportMetadataButtonSize=[0.2 compHeight];
% openSpecifyTrialsButtonSize=[0.4 compHeight];
% projectDropDownSize=[0.35 compHeight];
% runImportButtonSize=[0.2 compHeight];
% redoImportCheckboxSize=[0.3 compHeight];
% dataTypeImportSettingsDropDownSize=[0.25 compHeight];
% logsheetLabelSize=[0.2 compHeight];
% numHeaderRowsLabelSize=[0.2 compHeight];
% numHeaderRowsFieldSize=[0.1 compHeight];
% subjectIDColHeaderLabelSize=[0.2 compHeight];
% subjectIDColHeaderFieldSize=[0.2 compHeight];
% trialIDColHeaderDataTypeLabelSize=[0.2 compHeight];
% trialIDColHeaderDataTypeFieldSize=[0.2 compHeight];
% targetTrialIDColHeaderLabelSize=[0.2 compHeight];
% targetTrialIDColHeaderFieldSize=[0.2 compHeight];
% % saveAllButtonSize=[0.2 compHeight];
% selectDataPanelSize=[0.4 0.55*figSize(2)];
% dataTypeImportMethodFieldSize=[0.05 compHeight];
% addDataTypeButtonSize=[0.2 compHeight];
% openImportFcnButtonSize=[0.2 compHeight];
% addProjectButtonSize=[0.05 compHeight];
% openLogsheetButtonSize=[0.05 compHeight];
% openDataPathButtonSize=[0.05 compHeight];
% openCodePathButtonSize=[0.05 compHeight];
% % openLogsheet2StructButtonSize=[0.3 compHeight];
% loadLabelSize=[0.05 compHeight];
% offloadLabelSize=[0.1 compHeight];
% dataLabelSize=[0.05 compHeight];
% dataPanelUpArrowButtonSize=[0.05 compHeight*1.67];
% dataPanelDownArrowButtonSize=[0.05 compHeight*1.67];
% specifyTrialsNumberFieldSize=[0.05 compHeight];
% 
% %% Multiply the relative positions by the figure size to get the actual position.
% projectNameLabelPos=round([projectNameLabelRelPos.*figSize projectNameLabelSize(1)*figSize(1) projectNameLabelSize(2)]);
% logsheetNameButtonPos=round([logsheetNameButtonRelPos.*figSize logsheetNameButtonSize(1)*figSize(1) logsheetNameButtonSize(2)]);
% dataPathButtonPos=round([dataPathButtonRelPos.*figSize dataPathButtonSize(1)*figSize(1) dataPathButtonSize(2)]);
% codePathButtonPos=round([codePathButtonRelPos.*figSize codePathButtonSize(1)*figSize(1) codePathButtonSize(2)]);
% logsheetNameEditFieldPos=round([logsheetNameEditFieldRelPos.*figSize logsheetNameEditFieldSize(1)*figSize(1) logsheetNameEditFieldSize(2)]);
% dataPathEditFieldPos=round([dataPathEditFieldRelPos.*figSize dataPathEditFieldSize(1)*figSize(1) dataPathEditFieldSize(2)]);
% codePathEditFieldPos=round([codePathEditFieldRelPos.*figSize codePathEditFieldSize(1)*figSize(1) codePathEditFieldSize(2)]);
% % openImportMetadataButtonPos=round([openImportMetadataButtonRelPos.*figSize openImportMetadataButtonSize(1)*figSize(1) openImportMetadataButtonSize(2)]);
% openSpecifyTrialsButtonPos=round([openSpecifyTrialsButtonRelPos.*figSize openSpecifyTrialsButtonSize(1)*figSize(1) openSpecifyTrialsButtonSize(2)]);
% projectDropDownPos=round([projectDropDownRelPos.*figSize projectDropDownSize(1)*figSize(1) projectDropDownSize(2)]);
% runImportButtonPos=round([runImportButtonRelPos.*figSize runImportButtonSize(1)*figSize(1) runImportButtonSize(2)]);
% redoImportCheckboxPos=round([redoImportCheckboxRelPos.*figSize redoImportCheckboxSize(1)*figSize(1) redoImportCheckboxSize(2)]);
% dataTypeImportSettingsDropDownPos=round([dataTypeImportSettingsDropDownRelPos.*figSize dataTypeImportSettingsDropDownSize(1)*figSize(1) dataTypeImportSettingsDropDownSize(2)]);
% logsheetLabelPos=round([logsheetLabelRelPos.*figSize logsheetLabelSize(1)*figSize(1) logsheetLabelSize(2)]);
% numHeaderRowsLabelPos=round([numHeaderRowsLabelRelPos.*figSize numHeaderRowsLabelSize(1)*figSize(1) numHeaderRowsLabelSize(2)]);
% numHeaderRowsFieldPos=round([numHeaderRowsFieldRelPos.*figSize numHeaderRowsFieldSize(1)*figSize(1) numHeaderRowsFieldSize(2)]);
% subjectIDColHeaderLabelPos=round([subjectIDColHeaderLabelRelPos.*figSize subjectIDColHeaderLabelSize(1)*figSize(1) subjectIDColHeaderLabelSize(2)]);
% subjectIDColHeaderFieldPos=round([subjectIDColHeaderFieldRelPos.*figSize subjectIDColHeaderFieldSize(1)*figSize(1) subjectIDColHeaderFieldSize(2)]);
% trialIDColHeaderDataTypeLabelPos=round([trialIDColHeaderDataTypeLabelRelPos.*figSize trialIDColHeaderDataTypeLabelSize(1)*figSize(1) trialIDColHeaderDataTypeLabelSize(2)]);
% trialIDColHeaderDataTypeFieldPos=round([trialIDColHeaderDataTypeFieldRelPos.*figSize trialIDColHeaderDataTypeFieldSize(1)*figSize(1) trialIDColHeaderDataTypeFieldSize(2)]);
% targetTrialIDColHeaderLabelPos=round([targetTrialIDColHeaderLabelRelPos.*figSize targetTrialIDColHeaderLabelSize(1)*figSize(1) targetTrialIDColHeaderLabelSize(2)]);
% targetTrialIDColHeaderFieldPos=round([targetTrialIDColHeaderFieldRelPos.*figSize targetTrialIDColHeaderFieldSize(1)*figSize(1) targetTrialIDColHeaderFieldSize(2)]);
% % saveAllButtonPos=round([saveAllButtonRelPos.*figSize saveAllButtonSize(1)*figSize(1) saveAllButtonSize(2)]);
% selectDataPanelPos=round([selectDataPanelRelPos.*figSize selectDataPanelSize(1)*figSize(1) selectDataPanelSize(2)]);
% dataTypeImportMethodFieldPos=round([dataTypeImportMethodFieldRelPos.*figSize dataTypeImportMethodFieldSize(1)*figSize(1) dataTypeImportMethodFieldSize(2)]);
% addDataTypeButtonPos=round([addDataTypeButtonRelPos.*figSize addDataTypeButtonSize(1)*figSize(1) addDataTypeButtonSize(2)]);
% openImportFcnButtonPos=round([openImportFcnButtonRelPos.*figSize openImportFcnButtonSize(1)*figSize(1) openImportFcnButtonSize(2)]);
% addProjectButtonPos=round([addProjectButtonRelPos.*figSize addProjectButtonSize(1)*figSize(1) addProjectButtonSize(2)]);
% openLogsheetButtonPos=round([openLogsheetButtonRelPos.*figSize openLogsheetButtonSize(1)*figSize(1) openLogsheetButtonSize(2)]);
% openDataPathButtonPos=round([openDataPathButtonRelPos.*figSize openDataPathButtonSize(1)*figSize(1) openDataPathButtonSize(2)]);
% openCodePathButtonPos=round([openCodePathButtonRelPos.*figSize openCodePathButtonSize(1)*figSize(1) openCodePathButtonSize(2)]);
% % openLogsheet2StructButtonPos=round([openLogsheet2StructButtonRelPos.*figSize openLogsheet2StructButtonSize(1)*figSize(1) openLogsheet2StructButtonSize(2)]);
% loadLabelPos=round([loadLabelRelPos.*figSize loadLabelSize(1)*figSize(1) loadLabelSize(2)]);
% offloadLabelPos=round([offloadLabelRelPos.*figSize offloadLabelSize(1)*figSize(1) offloadLabelSize(2)]);
% dataLabelPos=round([dataLabelRelPos.*figSize dataLabelSize(1)*figSize(1) dataLabelSize(2)]);
% dataPanelUpArrowButtonPos=round([dataPanelUpArrowButtonRelPos.*figSize dataPanelUpArrowButtonSize(1)*figSize(1) dataPanelUpArrowButtonSize(2)]);
% dataPanelDownArrowButtonPos=round([dataPanelDownArrowButtonRelPos.*figSize dataPanelDownArrowButtonSize(1)*figSize(1) dataPanelDownArrowButtonSize(2)]);
% specifyTrialsNumberFieldPos=round([specifyTrialsNumberFieldRelPos.*figSize specifyTrialsNumberFieldSize(1)*figSize(1) specifyTrialsNumberFieldSize(2)]);
% 
% %% Set the actual positions for each component
% data.ProjectNameLabel.Position=projectNameLabelPos;
% data.LogsheetPathButton.Position=logsheetNameButtonPos;
% data.DataPathButton.Position=dataPathButtonPos;
% data.CodePathButton.Position=codePathButtonPos;
% data.LogsheetPathField.Position=logsheetNameEditFieldPos;
% data.DataPathField.Position=dataPathEditFieldPos;
% data.CodePathField.Position=codePathEditFieldPos;
% data.OpenImportMetadataButton.Position=openImportMetadataButtonPos;
% data.OpenSpecifyTrialsButton.Position=openSpecifyTrialsButtonPos;
% data.SwitchProjectsDropDown.Position=projectDropDownPos;
% data.RunImportButton.Position=runImportButtonPos;
% data.RedoImportCheckBox.Position=redoImportCheckboxPos;
% data.DataTypeImportSettingsDropDown.Position=dataTypeImportSettingsDropDownPos;
% data.LogsheetLabel.Position=logsheetLabelPos;
% data.NumHeaderRowsLabel.Position=numHeaderRowsLabelPos;
% data.NumHeaderRowsField.Position=numHeaderRowsFieldPos;
% data.SubjectIDColHeaderLabel.Position=subjectIDColHeaderLabelPos;
% data.SubjectIDColHeaderField.Position=subjectIDColHeaderFieldPos;
% data.TrialIDColHeaderDataTypeLabel.Position=trialIDColHeaderDataTypeLabelPos;
% data.TrialIDColHeaderDataTypeField.Position=trialIDColHeaderDataTypeFieldPos;
% data.TargetTrialIDColHeaderLabel.Position=targetTrialIDColHeaderLabelPos;
% data.TargetTrialIDColHeaderField.Position=targetTrialIDColHeaderFieldPos;
% % data.SaveAllButton.Position=saveAllButtonPos;
% data.SelectDataPanel.Position=selectDataPanelPos;
% data.DataTypeImportMethodField.Position=dataTypeImportMethodFieldPos;
% data.AddDataTypeButton.Position=addDataTypeButtonPos;
% data.OpenImportFcnButton.Position=openImportFcnButtonPos;
% data.AddProjectButton.Position=addProjectButtonPos;
% data.OpenLogsheetButton.Position=openLogsheetButtonPos;
% data.OpenDataPathButton.Position=openDataPathButtonPos;
% data.OpenCodePathButton.Position=openCodePathButtonPos;
% % data.OpenLogsheet2StructButton.Position=openLogsheet2StructButtonPos;
% data.LoadLabel.Position=loadLabelPos;
% data.OffloadLabel.Position=offloadLabelPos;
% data.DataLabel.Position=dataLabelPos;
% data.DataPanelUpArrowButton.Position=dataPanelUpArrowButtonPos;
% data.DataPanelDownArrowButton.Position=dataPanelDownArrowButtonPos;
% data.SpecifyTrialsNumberField.Position=specifyTrialsNumberFieldPos;
% 
% %% Set the font sizes for all components that use text
% data.ProjectNameLabel.FontSize=newFontSize;
% data.LogsheetPathButton.FontSize=newFontSize;
% data.DataPathButton.FontSize=newFontSize;
% data.CodePathButton.FontSize=newFontSize;
% data.LogsheetPathField.FontSize=newFontSize;
% data.DataPathField.FontSize=newFontSize;
% data.CodePathField.FontSize=newFontSize;
% data.OpenImportMetadataButton.FontSize=newFontSize;
% data.OpenSpecifyTrialsButton.FontSize=newFontSize;
% data.SwitchProjectsDropDown.FontSize=newFontSize;
% data.RunImportButton.FontSize=newFontSize;
% data.RedoImportCheckBox.FontSize=newFontSize;
% data.DataTypeImportSettingsDropDown.FontSize=newFontSize;
% data.LogsheetLabel.FontSize=newFontSize;
% data.NumHeaderRowsLabel.FontSize=newFontSize;
% data.NumHeaderRowsField.FontSize=newFontSize;
% data.SubjectIDColHeaderLabel.FontSize=newFontSize;
% data.SubjectIDColHeaderField.FontSize=newFontSize;
% data.TrialIDColHeaderDataTypeLabel.FontSize=newFontSize;
% data.TrialIDColHeaderDataTypeField.FontSize=newFontSize;
% data.TargetTrialIDColHeaderLabel.FontSize=newFontSize;
% data.TargetTrialIDColHeaderField.FontSize=newFontSize;
% % data.SaveAllButton.FontSize=newFontSize;
% data.SelectDataPanel.FontSize=newFontSize;
% data.DataTypeImportMethodField.FontSize=newFontSize;
% data.AddDataTypeButton.FontSize=newFontSize;
% data.OpenImportFcnButton.FontSize=newFontSize;
% data.AddProjectButton.FontSize=newFontSize;
% data.OpenLogsheetButton.FontSize=newFontSize;
% data.OpenDataPathButton.FontSize=newFontSize;
% data.OpenCodePathButton.FontSize=newFontSize;
% % data.OpenLogsheet2StructButton.FontSize=newFontSize;
% data.LoadLabel.FontSize=newFontSize;
% data.OffloadLabel.FontSize=newFontSize;
% data.DataLabel.FontSize=newFontSize;
% data.DataPanelUpArrowButton.FontSize=newFontSize;
% data.DataPanelDownArrowButton.FontSize=newFontSize;
% data.SpecifyTrialsNumberField.FontSize=newFontSize;
% 
% % Restore component visibility