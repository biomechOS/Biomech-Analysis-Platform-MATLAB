function [objectType, abstractID, instanceID]=deText(uuid)

%% PURPOSE: BREAK DOWN THE "TEXT" FIELD INTO ITS CONSTITUENT COMPONENTS.
% Expected UUID format: AABBBBBB_CCC

objectType='';
abstractID='';
instanceID='';

if ~(ischar(uuid) || isstring(uuid))
    return;
end

if isempty(uuid)    
    return;
end

if length(uuid)<3
    return; % Not long enough (due to error) to parse the string
end

% Remove folder path prefix if it exists.
[path, uuid, ext] = fileparts(uuid);

% Remove file extension if it exists.
if contains(uuid,'.')
    dotIdx = strfind(uuid,'.');
    uuid = uuid(1:dotIdx-1);
end

objectType = uuid(1:2);
underscoreIdx = strfind(uuid,'_');

if ~isempty(underscoreIdx)
    abstractID = uuid(3:underscoreIdx-1);
    instanceID = uuid(underscoreIdx+1:end);
else
    abstractID = uuid(3:end-1);
    instanceID = '';
end