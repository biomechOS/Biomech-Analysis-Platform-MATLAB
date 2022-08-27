function []=addFunctionButtonPushed(src,event)

%% PURPOSE: CREATE A NEW FUNCTION FROM TEMPLATE AND SAVE IT TO FILE. DOES NOT ADD ANYTHING TO THE GUI FIGURE.

fig=ancestor(src,'figure','toplevel');
handles=getappdata(fig,'handles');

%% Make Process functions directory if it does not already exist
processFcnsDir=[getappdata(fig,'codePath') 'Processing Functions'];
if exist(processFcnsDir,'dir')~=7
    mkdir(processFcnsDir);
end

%% Get the function name from the user
while true

    fcnName=inputdlg('Enter Function Name','New Function');

    if isempty(fcnName)
        return;
    end

    if length(fcnName)>1
        disp('One line of text only!');
        continue;
    end

    fcnName=fcnName{1};

    if isequal(fcnName,'Logsheet')
        disp('Function cannot be named logsheet!');
        continue;
    end

    if isvarname(fcnName)
        break;
    end

    disp(['Entered function name is not valid: ' fcnName]);

end

%% Check if the function already exists
if ispc==1
    slash='\';
elseif ismac==1
    slash='/';
end

newFcnPath=[processFcnsDir slash fcnName '.m'];

if exist(newFcnPath,'file')==2
    disp(['Function already exists! ' fcnName]);
    return;
end

%% Get the desired level of the processing function from the user
opts={'Project','Subject','Trial'};
[idx,tf]=listdlg('PromptString','Select Function Level(s)','ListString',opts);
if ~tf
    return;
end
optsLetters={'P','S','T'};
levels=optsLetters(idx);

fcnLevel='';
for i=1:length(levels)
    fcnLevel=[fcnLevel levels{i}];
end

%% OPTIONAL: Specify the purpose of the function

%% Create the entry for this function in the FunctionNamesList variable in the projectSettingsMATPath

%% Create the function from template.
templatePath=[getappdata(fig,'everythingPath') 'App Creation & Component Management' slash 'Project-Independent Templates' slash 'Process_Template' fcnLevel '.m'];

createFileFromTemplate(templatePath,newFcnPath,fcnName);