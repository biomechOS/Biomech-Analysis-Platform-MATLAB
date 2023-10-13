function []=saveObj(classStruct, type)

%% PURPOSE: SAVE A CLASS INSTANCE TO A NEW ROW (USING INSERT STATEMENT)
global conn globalG;

if nargin==1
    type = 'INSERT';
end

assert(ismember(type,{'INSERT','UPDATE'}));

uuid = classStruct.UUID;
[abbrev,abstractID,instanceID]=deText(uuid);

if ~isempty(instanceID)
    suffix = 'Instances';
else
    suffix = 'Abstract';
end

class = className2Abbrev(abbrev);
classPlural = makeClassPlural(class);
tablename = [classPlural '_' suffix];

try
    sqlquery = struct2SQL(tablename, classStruct, type);
    execute(conn, sqlquery);
catch e

end

if isempty(instanceID) || isequal(type, 'UPDATE')
    return;
end

%% Insert the instance into the digraph.
Name = {classStruct.UUID};
OutOfDate = classStruct.OutOfDate;
nodeProps = table(Name, OutOfDate);    
try
    globalG = addnode(globalG, nodeProps);
catch e        
    if ~contains(e.message,'Node names must be unique.')
        error(e);
    end
end

