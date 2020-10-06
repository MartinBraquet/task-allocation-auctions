%% function setRFIDTag takes in a usarsim object, the ID of the tag you
%  want to set, and the string you want to be stored in the tag. Note that
%  only underscores, letters, and numbers are allowed in the string. ID
%  must be an integer.
function setRFIDTag(rob,ID,data)
rob.setRFIDData(rob.getRFID.Name,ID,data);

end