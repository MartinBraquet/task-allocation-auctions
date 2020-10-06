%% function getGroundTruth returns a structure containing true position and
%  orientation, to 2 decimal places.

function truth = getGroundTruth(rob)
a = rob.getSENGroundTruth();
truth = struct('Position',a.pos, ...
			   'TimeStamp', a.TimeStamp,...
			   'Orientation',a.orient);

end