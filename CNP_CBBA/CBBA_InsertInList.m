
% Insert value into list at location specified by index
%---------------------------------------------------------------------%

function newList = CBBA_InsertInList(oldList, value, index)

newList = -ones(1,length(oldList));

newList(1,1:index-1)   = oldList(1,1:index-1);

newList(1,index)       = value;

newList(1,index+1:end) = oldList(1,index:end-1);

end