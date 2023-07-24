function [G, nodeMatrix, edgeNames] = linkageToDigraph(types)

%% PURPOSE: CONVERT THE LINKAGE MATRIX TO A DIGRAPH (FUNCTIONS ONLY) SO THAT I CAN CHECK DEPENDENCIES.
% types: Indicates what types of objects to return in the digraph.
    % 'PR': Returns a digraph where the nodes are processing functions, and
    % the edges are the variables.
    % 'ALL': Returns all objects as a node, from variables to projects.
        % Allows for checking which objects are in which containers.

types = upper(types);

G = [];
nodeMatrix = [];
edgeNames = {};

slash = filesep;

linksFolder = [getCommonPath() slash 'Linkages'];
linksFile = [linksFolder slash 'Linkages.json'];

links = loadJSON(linksFile);

% Remove everything except for functions and variables.
if isequal(types,'PR')
    abbrevs = 'VR';
elseif isequal(types,'ALL')
    abbrevs = '';
end
idxAll = contains(links(:,1),abbrevs) | contains(links(:,2),abbrevs);
links = links(idxAll,:);

% Get all of the names of all objects
idx{1} = contains(links(:,1),abbrevs);
idx{2} = contains(links(:,2),abbrevs);
names = unique([links(idx{1},1); links(idx{2},2)],'stable');

if isempty(links)
    G = []; % No variables in the linkage matrix.
    return;
end

% Convert to vector of source and target nodes (each node is a processing function)
s = {}; t = {}; edgeNames = []; nodeMatrix = {'',''};
for i=1:length(names)

    name = names{i};

    firstColIdx = ismember(links(:,1),name); % Linking from
    secondColIdx = ismember(links(:,2),name); % Linking to

    % Only want variables that connect as inputs & output
    if isequal(types,'PR') 
        if ~(any(firstColIdx) && any(secondColIdx))
            continue; % No connection to be made.
        end        
    end

    %% TODO: NEED TO ITERATE OVER THE FIRSTCOLIDX AND SECONDCOLIDX IF THERE IS MORE THAN ONE ENTRY.
    if isequal(types,'PR')
        numIters = sum(firstColIdx);
        srcFcn = repmat(links(secondColIdx,1),numIters,1); % Replicate the first column N times
        trgFcn = links(firstColIdx,2);
    elseif isequal(types,'ALL')
        nodes = [links(firstColIdx,:); links(secondColIdx,:)];        
        rowIdx = ~(ismember(nodes(:,1),nodeMatrix(:,1)) & ismember(nodes(:,2),nodeMatrix(:,2)));
        nodes = nodes(rowIdx,:);
        numIters=size(nodes(:,1),1);
        srcFcn = nodes(:,1);
        trgFcn = nodes(:,2);

        if isempty(nodes)
            continue;
        end

    end

    if isequal(types,'PR')
        edgeNames = [edgeNames; repmat({name},numIters,1)];    
    end
    s = [s; srcFcn];
    t = [t; trgFcn];
    nodeMatrix = [s t];

end


if isequal(types,'ALL')

    % Convert to digraph
    G = digraph(s,t);

    % If there are output variables not connected to a function, change the
    % flow of those arrows so it seems like they are input variables. This
    % allows tracking which container they are in.
    for i=1:length(t)

        if ~(isequal(deText(t{i}),'VR') && isempty(outedges(G, t{i})))
            continue;
        end

        % Swap source and targets.
        tmpS = s(i);
        tmpT = t(i);
        s(i) = tmpT;
        t(i) = tmpS;

    end

end

G = digraph(s, t);

G.Nodes.UUID = G.Nodes.Name; % Copy the names to UUID (temporary) because the names should be human readable.