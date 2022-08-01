function []=windowButtonDownFcn(src,event)

%% PURPOSE: RECORD WHEN THE MOUSE BUTTON IS CLICKED (DOWN). ONLY ACTIVATES IF THE CLICK WAS ON THE UIAXES OBJECT

fig=ancestor(src,'figure','toplevel');
handles=getappdata(fig,'handles');

xlims=handles.Process.mapFigure.XLim;
ylims=handles.Process.mapFigure.YLim;

currPoint=handles.Process.mapFigure.CurrentPoint;

% assert(isequal(currPoint(1,:),[currPoint(2,1:2) -1*currPoint(2,3)]));

currPoint=currPoint(1,1:2);

if currPoint(1)<xlims(1) || currPoint(1)>xlims(2) || currPoint(2)<ylims(1) || currPoint(2)>ylims(2)        
    if isequal(fig.CurrentObject,handles.Process.varsListbox)              
        varName=handles.Process.varsListbox.Value;
    elseif isprop(fig.CurrentObject,'NodeData') %isequal(fig.CurrentObject,handles.Process.fcnArgsUITree)
        varName=handles.Process.fcnArgsUITree.SelectedNodes.Text;
        a=handles.Process.fcnArgsUITree.SelectedNodes.Parent;
        if ~isprop(a,'Text') || ~ismember(a.Text,{'Inputs','Outputs'}) % Ensure this is a variable name
            return;
        end        
    else
        return;
    end

    projectSettingsMATPath=getappdata(fig,'projectSettingsMATPath');

    projectSettingsVars=whos('-file',projectSettingsMATPath);
    projectSettingsVarNames={projectSettingsVars.name};

    assert(ismember('VariableNamesList',projectSettingsVarNames));

    load(projectSettingsMATPath,'VariableNamesList');

    varIdx=ismember(VariableNamesList.GUINames,varName);
    defaultName=VariableNamesList.SaveNames{varIdx};

    handles.Process.argNameInCodeField.Value=defaultName;
    handles.Process.argDescriptionTextArea.Value=VariableNamesList.Descriptions{varIdx};

    return; % Clicked outside of the axes bounds
end

setappdata(fig,'currentPointDown',currPoint);