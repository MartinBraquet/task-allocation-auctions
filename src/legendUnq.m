function unqLegHands = legendUnq(h, sortType)
% unqLegHands = legendUnq(h, sortType)
%   Run this function just before running 'legend()' to avoid representing duplicate or missing
% DisplayNames within the legend. This solves the problem of having a cluttered legend with 
% duplicate or generic values such as "data1" assigned by matalab's legend() function.  This 
% also makes is incredibly easy to assign one legend to a figure with multiple subplots. 
% Use the 'DisplayName' property in your plots and input the axis handle or the figure handle 
% so this code can search for all potential legend elements, find duplicate DisplayName strings, 
% and remove redundent components by setting their IconDisplayStyle to 'off'.  Then call 
% legend(unqLegHands) to display unique legend components. 
% INTPUT
%       h: (optional) either a handle to a figure, an axis, or a vector of axis handles. The code 
%           will search for plot elements in all axes belonging to h.  If h is missing, gca is used.
%       sort: (optional) can be one of the following strings that will sort the unqLeghands.
%           'alpha': alphabetical order. 
% OUTPUT
%       unqLegHands: a list of handles that have unique DisplayNames; class 'matlab.graphics.chart.primitive.Line'.
%           ie: unqLegHands = legendUnq(figHandle); legend(unqLegHands)
% EXAMPLE 1: 
%         figure; axis; hold on
%         for i=1:10
%             plot(i,rand(), 'ko', 'DisplayName', 'randVal1');        % included in legend
%             plot(i+.33, rand(), 'ro', 'DisplayName', 'randVal2');   % included in legend       
%         end
%         plot(rand(1,10), 'b-'); 	% no DisplayName so it is absent from legend
%         legend(legendUnq())
% EXAMPLE 2: 
%         fh = figure; subplot(2,2,1); hold on
%         plot(1:10, rand(1,10), 'b-o', 'DisplayName', 'plot1 val1')
%         plot(1:2:10, rand(1,5), 'r-*', 'DisplayName', 'plot1 val2')
%         subplot(2,2,2); hold on
%         plot(1:10, rand(1,10), 'm-o', 'DisplayName', 'plot2 val1')
%         plot(1:2:10, rand(1,5), 'g-*', 'DisplayName', 'plot2 val2')
%         subplot(2,2,3); hold on
%         plot(1:10, rand(1,10), 'c-o', 'DisplayName', 'plot3 val1')
%         plot(1:2:10, rand(1,5), 'k-*', 'DisplayName', 'plot3 val2')
%         lh = legend(legendUnq(fh)); 
%         lh.Position = [.6 .2 .17 .21];
%
% Danz 180515

% Change history
% 180912 fixed error when plot is empty
% 180913 adapted use of undocumented function for matlab 2018b

persistent useOldMethod

% If handle isn't specified, choose current axes
if nargin == 0
    h = gca; 
end

% If user entered a figure handle, replace with a list of children axes; preserve order of axes
if strcmp(get(h, 'type'), 'figure')
    h = flipud(findall(h, 'type', 'Axes')); 
end

% set flag to use old method of obtaining legend children
% In 2018b matlab changed an undocumented function that obtains legend handles. 
useOldMethod = verLessThan('matlab', '9.5.0'); 

% Set the correct undocumented function 
if useOldMethod
    getLegendChildren = @(x) graph2dhelper('get_legendable_children', x);
else
    getLegendChildren = @(x) matlab.graphics.illustration.internal.getLegendableChildren(x);
end

% Get all objects that will be assigned to legend.
% This uses an undocumented function that the legend() func uses to get legend componenets.
legChildren = matlab.graphics.chart.primitive.Line; %initializing class (unsure of a better way)
for i = 1:length(h)
    temp = getLegendChildren(h(i));
    if ~isempty(temp)
        legChildren(end+1:end+length(temp),1) = temp; 
    end
end
legChildren(1) = [];
% Get display names
dispNames = get(legChildren, 'DisplayName');
if isempty(dispNames)
    dispNames = {''}; 
end
if ~iscell(dispNames)
    dispNames = {dispNames}; 
end
% Find the first occurance of each name 
[~, firstIdx] = unique(dispNames, 'first'); 
% Create an index of legend items that will be hidden from legend
legRmIdx = true(size(legChildren)); 
legRmIdx(firstIdx) = false; 
% Add any elements that have no displayName to removal index (legend would assign them 'dataX')
legRmIdx = legRmIdx | cellfun(@isempty,dispNames);
% get all annotations
annot = get(legChildren, 'Annotation'); 
% Loop through all items to be hidden and turn off IconDisplayStyle
for i = 1:length(annot)
    if legRmIdx(i)
        set(get(annot{i}, 'LegendInformation'), 'IconDisplayStyle', 'off');
    end
end
% Output remaining, handles to unique legend entries
unqLegHands = legChildren(~legRmIdx); 

% Sort, if user requested
if nargin > 1 && ~isempty(sortType) && length(unqLegHands)>1
    [~, sortIdx] = sort(get(unqLegHands, 'DisplayName'));
    unqLegHands = unqLegHands(sortIdx); 
end
