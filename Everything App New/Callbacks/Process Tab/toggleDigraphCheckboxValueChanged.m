function []=toggleDigraphCheckboxValueChanged(src,event)

%% PURPOSE: HIDE OR SHOW THE DIGRAPH & ASSOCIATED COMPONENTS

fig=ancestor(src,'figure','toplevel');
handles=getappdata(fig,'handles');

val = src.Value;

%% Change visibility
% Change digraph visibility
handles.Process.digraphAxes.Visible = val;

% Change queue & specify trials visibility
handles.Process.queueLabel.Visible = ~val;
handles.Process.queueUITree.Visible = ~val;
handles.Process.addSpecifyTrialsButton.Visible = ~val;
handles.Process.removeSpecifyTrialsButton.Visible = ~val;
handles.Process.editSpecifyTrialsButton.Visible = ~val;
handles.Process.allSpecifyTrialsUITree.Visible = ~val;
handles.Process.runButton.Visible = ~val;

%% Fill in the digraph. Placeholder for this, should probably happen elsewhere.
if ~val
    return; % Don't fill in the digraph if it's not visible!
end

[Gall, nodesAll, edgesAll] = linkageToDigraph('all'); % A graph containing all analyses. Need to find the subset of functions in the current analysis.
[G, nodes, edges] = linkageToDigraph('PR');
Current_Analysis = getCurrent('Current_Analysis');
G = getSubset(nodes, Current_Analysis); % The graph of just this analysis.
renderGraph(fig, G); % Show the graph.