function [] = renderGraph(src, G, markerSize, color, edgeID)

%% PURPOSE: RENDER THE DIGRAPH IN THE UI AXES

fig=ancestor(src,'figure','toplevel');
handles=getappdata(fig,'handles');

if nargin==1 || isempty(G)
    G = getappdata(fig,'digraph');
%     nodeMatrix = getappdata(fig,'nodeMatrix');
%     edges = getappdata(fig,'edges');
end
if exist('markerSize','var')~=1 || isempty(markerSize)
    markerSize = getappdata(fig,'markerSize');
    if isempty(markerSize)
        markerSize = 4;
    end
end
defaultColor = [0 0.447 0.741];
if ~exist('color','var') || isempty(color)
%     color = getappdata(fig,'color');
    color = repmat(defaultColor,length(markerSize),1); % Default blue color
    if any(markerSize~=4)
        color(markerSize~=4,:) = [0 0 0];
    end
end

% Reset the axes.
ax = handles.Process.digraphAxes;
delete(ax.Children);
set(ax,'ColorOrderIndex', 1);

h  = plot(ax,G,'NodeLabel',G.Nodes.PrettyName,'Interpreter','none','PickableParts','none','HitTest','on');

h.MarkerSize = markerSize;

h.NodeColor = color;
h.EdgeColor = defaultColor;
h.LineWidth = 0.5;

% If a node is selected, highlight its in and out edges.
if ~isscalar(markerSize)
    idx = ismember(markerSize, 8);
    ins = inedges(G, G.Nodes.Name(idx));
    highlight(h, 'Edges',ins, 'EdgeColor',rgb('grass green'),'LineWidth',2);
    labeledge(h, ins, G.Edges.Name(ins));
    outs = outedges(G, G.Nodes.Name(idx));
    highlight(h, 'Edges', outs, 'EdgeColor',rgb('brick red'),'LineWidth',2);
    labeledge(h, outs, G.Edges.Name(outs));
    if exist('edgeID','var') && ~isempty(edgeID)
        edgeIdx = ismember(G.Edges.Name, edgeID);
        highlight(h, 'Edges', edgeIdx, 'EdgeColor', rgb('orange'),'LineWidth',2);
    end
end

setappdata(fig,'digraph',G);
% setappdata(fig,'nodeMatrix',nodeMatrix);
% setappdata(fig,'edges',edges);
setappdata(fig,'markerSize',markerSize);
% setappdata(fig,'color',color);