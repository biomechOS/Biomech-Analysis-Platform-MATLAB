function []=runProcessFunctions(groupName,fig)

%% PURPOSE: CALLED IMMEDIATELY AFTER PRESSING THE "RUN GROUP" OR "RUN ALL" BUTTONS
% Inputs:
% groupName: Specifies which group to run. If "Run All" was pressed, it loops over all groups in the callback function. (char)
% fig: The figure variable (handle)

% Outputs:
% None. The data are assigned to the base workspace, and saved to the file.

if ismac==1
    slash='/';
elseif ispc==1
    slash='\';
end

codePath=getappdata(fig,'codePath');
% dataPath=getappdata(fig,'dataPath');
projectName=getappdata(fig,'projectName');

% Check for existence of projectStruct
if evalin('base','exist(''projectStruct'',''var'')==1')==0
    beep;
    warning('Load the data into the projectStruct first!');
    return;
end

% Check for existence of logsheet variable in workspace. If not present, load it. If .mat file not present, throw error.
logPath=getappdata(fig,'logsheetPath');
lastPrdIdx=strfind(logPath,'.');
lastPrdIdx=lastPrdIdx(end);
logVarPath=[logPath(1:lastPrdIdx) 'mat'];
if evalin('base','exist(''logVar'',''var'')==1')==1
    logVar=evalin('base','logVar;'); % Load the logsheet variable
elseif exist(logVarPath,'file')==2
    logVar=load(logVarPath);
    fldName=fieldnames(logVar);
    assert(length(fldName)==1);
    logVar=logVar.(fldName{1});
else
    beep;
    warning(['Missing logsheet .mat file! Should be at: ' logVarPath]);
    return;
end

%% Get the status of every processing function (i.e. whether to run it or not, whether to use its specify trials or the group level)
% Get the processing function names
text=readFcnNames(getappdata(fig,'fcnNamesFilePath'));
[groupNames,lineNums]=getGroupNames(text);
idx=ismember(groupNames,groupName);
lineNum=lineNums(idx); % The line number in the text file of the current group

groupSpecifyTrialsName=[groupName '_Process_SpecifyTrials'];
groupArgsName=[groupName '_Process_Args'];

fcnCount=0;
for i=lineNum+1:length(text)
    
    if isempty(text{i})
        break; % Finished with this group
    end
    
    
    a=strsplit(text{i},':');
    runAndSpecifyTrialsCell=strsplit(strtrim(a{2}),' ');
    if isequal(runAndSpecifyTrialsCell{1}(end),'0')
        continue;
    end

    fcnCount=fcnCount+1;
    fcnNameCell=strsplit(a{1},' ');
    number=fcnNameCell{2}(~isletter(fcnNameCell{2}));
    letter=fcnNameCell{2}(isletter(fcnNameCell{2}));
    fcnNames{fcnCount}=[fcnNameCell{1} '_Process' number]; % All the function names, in order
    if isequal(runAndSpecifyTrialsCell{3}(end),'1') % if using function-specific argument function
        argsNames{fcnCount}=[fcnNameCell{1} '_Process' number letter]; % All the argument function names, in order
    else % if using group level argument function
        argsNames{fcnCount}=groupArgsName;
    end
    
    runFuncs(fcnCount)=str2double(runAndSpecifyTrialsCell{1}(end));
    funcSpecifyTrials(fcnCount)=str2double(runAndSpecifyTrialsCell{2}(end));
    funcArgs(fcnCount)=str2double(runAndSpecifyTrialsCell{3}(end));

    if isequal(runAndSpecifyTrialsCell{2}(end),'1')
        funcSpecifyTrialsName{fcnCount}=[fcnNameCell{1} '_Process' number letter '_SpecifyTrials'];
    else
        funcSpecifyTrialsName{fcnCount}=groupSpecifyTrialsName;
    end
    
    % Get the full path name of the fcnNames (i.e. if in User-Created Functions or Existing Functions folder)
    userFolder=[codePath 'Process_' projectName slash 'User-Created Functions'];
    existFolder=[codePath 'Process_' projectName slash 'Existing Functions'];
    if exist(userFolder,'file')==2 && exist(existFolder,'file')==2
        beep;
        warning(['Function is replicated in ''User-Created Functions'' and ''Existing Functions'' folders: ' fcnNames{fcnCount}]);
        return;
    end
    
    if exist([userFolder slash fcnNames{fcnCount} '.m'],'file')==2
        fcnFolder{fcnCount}=userFolder;
    elseif exist([existFolder slash fcnNames{fcnCount} '.m'],'file')==2
        fcnFolder{fcnCount}=existFolder;
    end
    
end

%% Check existence of all input arguments functions, and identify their highest processing level.
argsFolderFcn=[codePath 'Process_' projectName slash 'Arguments' slash 'Per Function' slash];
argsFolderGroup=[codePath 'Process_' projectName slash 'Arguments' slash 'Per Group' slash];
currDir=cd([codePath 'Process_' projectName slash 'Arguments']);

if ~exist('fcnNames','var')
    return;
end

for i=1:length(fcnNames)

    if exist([argsNames{i} '.m'],'file')~=2
        beep;
        warning(['Input Argument Function Does Not Exist: ' argsNames{i}]);
        return;
    end

    if exist([argsFolderFcn argsNames{i} '.m'],'file')==2
        argPath{i}=[argsFolderFcn argsNames{i} '.m'];
    elseif exist([argsFolderGroup argsNames{i} '.m'],'file')==2
        argPath{i}=[argsFolderGroup argsNames{i} '.m'];
    end        

    [inputPaths{i},outputPaths{i},allPaths{i}]=readArgsFcn(argPath{i});
    if ~iscell(allPaths{i})
        return;
    end
    funcLevels{i}='';
    for j=1:length(allPaths{i})
        currPathSplit=strsplit(allPaths{i}{j},'.');        
        if length(currPathSplit)>=4 && isequal(currPathSplit{3}([1 end]),'()')
            funcLevels{i}=[funcLevels{i}; {'Trial'}];
        elseif length(currPathSplit)>=3 && isequal(currPathSplit{2}([1 end]),'()')
            funcLevels{i}=[funcLevels{i}; {'Subject'}]   ;        
        else
            funcLevels{i}=[funcLevels{i}; {'Project'}];
            break;
        end

    end

    funcLevels{i}=sort(unique(funcLevels{i}));
    
    
end
cd(currDir); % Go back to original directory.

%% Iterate over all processing functions in the group to run them.
for i=1:length(fcnNames)
    
    % Bring the projectStruct from the base workspace into this one. Doing this for each function incorporates results of any previously finished functions.
    projectStruct=evalin('base','projectStruct;');
    
    fcnName=fcnNames{i};
    argsName=argsNames{i};
    runFunc=runFuncs(i);
    specTrials=funcSpecifyTrials(fcnCount);
    currLevels=funcLevels{i};
    methodLetter=strsplit(argsName,'_Process');
    methodLetter=methodLetter{2}(isletter(methodLetter{2}));
    setappdata(fig,'methodLetter',methodLetter)
%     assignin('base','methodLetter',methodLetter); % Send the method letter to the base workspace
    
    if runFunc==0
        disp(['Skipping ' fcnName ' Because it was Unchecked in Group ' groupName ' in the GUI']);
        continue; % If this function shouldn't be run this time, skip it.
    end
    
    % Run the specify trials function, either function or group level.
    if specTrials==1 % Function-level specify trials
        specTrialsFolder=[codePath 'Process_' getappdata(fig,'projectName') slash 'Specify Trials' slash 'Per Function'];
        specTrialsName=funcSpecifyTrialsName{fcnCount};
    else % Group-level specify trials
        specTrialsFolder=[codePath 'Process_' getappdata(fig,'projectName') slash 'Specify Trials' slash 'Per Group'];
        specTrialsName=groupSpecifyTrialsName;
    end
    cd(specTrialsFolder); % Ensure that the wrong function is not accidentally used
    inclStruct=feval(specTrialsName); % No input arguments
    cd(currDir);
    
    % Run getTrialNames
    trialNames=getTrialNames(inclStruct,logVar,fig,0,evalin('base','projectStruct;'));
    subNames=fieldnames(trialNames);

    %% CHECK HERE (IN EACH SECTION) THAT THE PROJECTSTRUCT allPaths EXIST BEFORE CALLING THEM?

%     checkAllPaths(allPaths{i},projectStruct,trialNames);

    % 1. Check the process file and the args file to ensure that all argNames passed to getArg are found in the args function (replaces localfunctions
    % check)
    % 2. Check the contents of the projectStruct, at the project, subject, and/or trial level to ensure that the desired allPaths (specified in the args
    % function) are present using the existField function. If not, throw an error and don't run the function.
    processFile=[fcnFolder{i} slash fcnName '.m'];
    argsFile=argPath{i};
    if ~checkArgsMatch(processFile,argsFile) || ~checkAllPaths(inputPaths{i},projectStruct,trialNames,argsFile)
        % checkArgsMatch reads the two files for matching called args.
        % checkAllPaths uses existField on all allPaths at all levels to ensure that there won't be an error with getArg. If a field does not exist, throws an error.
        return;
    end

    % Run the processing function
    if ismember('Project',currLevels)

        disp(['Running ' fcnName]);

        if ismember('Trial',currLevels)            
            feval(fcnName,projectStruct,trialNames); % projectStruct is an input argument for convenience of viewing the data only    
        elseif ismember('Subject',currLevels)
            feval(fcnName,projectStruct,subNames);
        else
            feval(fcnName,projectStruct);
        end
        continue; % Don't iterate through subjects, that's done within the processing function if necessary
    end
    
    for sub=1:length(subNames)
        subName=subNames{sub};
        currTrials=fieldnames(trialNames.(subName)); % The list of trial names in the current subject
        
        if ismember('Subject',currLevels)

            disp(['Running ' fcnName ' Subject ' subName]);

            if ismember('Trial',currLevels)
                feval(fcnName,projectStruct,subName,currTrials); % projectStruct is an input argument for convenience of viewing the data only
            else
               feval(fcnName,projectStruct,subName); 
            end
            continue; % Don't iterate through trials, that's done within the processing function if necessary
        end
        
        for trialNum=1:length(currTrials)
            trialName=currTrials{trialNum};

            disp(['Running ' fcnName ' Subject ' subName ' Trial ' trialName]);

            for repNum=trialNames.(subName).(trialName)

                feval(fcnName,projectStruct,subName,trialName,repNum); % projectStruct is an input argument for convenience of viewing the data only       

            end
        end        
        
    end    
    
end