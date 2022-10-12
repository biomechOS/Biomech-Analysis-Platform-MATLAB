function []=createPlotFcn(filePath,level,compName)

%% PURPOSE: CREATE A PLOTTING FUNCTION BASED ON THE LEVEL OF THE PLOT
% Level can be any of: {'P', 'C', 'S', 'SC', 'T'}

switch level
    case 'P'
        text{1}=['function [h]=' compName '_P(ax,allTrialNames)'];
        text{2}='';
        text{3}='subNames=fieldnames(allTrialNames);';
        text{4}='for subNum=1:length(subNames)';
        text{5}='    subName=subNames{subNum};';
        text{6}='    currTrials=fieldnames(allTrialNames.(subName));';
        text{7}='';
        text{8}='    for trialNum=1:length(currTrials)';
        text{9}='        trialName=currTrials{trialNum};';
        text{10}='';
        text{11}='        for repNum=allTrialNames.(subName).(trialName)';
        text{12}='';
        text{13}='            [data]=getArg({''data''},subName,trialName,repNum);';
        text{14}='';
        text{15}='        end';
        text{16}='    end';
        text{17}='end';
    case 'PC'
        text{1}=['function [h]=' compName '_PC(ax,allTrialNames)'];
        text{2}='';
        text{3}='numConds=length(allTrialNames.Condition);';
        text{4}='for condNum=1:numConds';
        text{5}='    subNames=fieldnames(allTrialNames.Condition(condNum));';
        text{6}='    for subNum=1:length(subNames)';
        text{7}='        subName=subNames{subNum};';
        text{8}='';
        text{9}='        currTrials=fieldnames(allTrialNames.Condition(condNum).(subName));';
        text{10}='        for trialNum=1:length(currTrials)';
        text{11}='            trialName=currTrials{trialNum};';
        text{12}='';
        text{13}='            for repNum=allTrialNames.Condition(condNum).(subName).(trialName)';
        text{14}='';
        text{15}='                [data]=getArg({''data''},subName,trialName,repNum);';
        text{16}='';
        text{17}='            end';
        text{17}='        end';
        text{18}='    end';
        text{19}='end';
    case 'C'

    case 'S'

    case 'SC'

    case 'T'
        text{1}=['function [h]=' compName '_T(ax,subName,trialName,repNum)'];
        text{2}='';
        text{3}='[data]=getArg({''data''},subName,trialName,repNum);';
    otherwise
        disp('No plotting function created, what happened with the level here?')
        return;

end

fid=fopen(filePath,'w');
fprintf(fid,'%s\n',text{1:end-1});
fprintf(fid,'%s',text{end});
fclose(fid);
edit(filePath);