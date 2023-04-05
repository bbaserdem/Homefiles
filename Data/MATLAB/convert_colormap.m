function newmap = convert_colormap(map, hand)
%CONVERT_COLORMAP Rescale an existing colormap

LEN = size(map, 1);
OLD = ((1:LEN)') / LEN;

% Get new scaling
if ischar(hand)
    hand = str2func(hand);
    NEW = hand(OLD);
elseif isnumeric(hand)
    if all((hand >= 0) && (hand <= 1), 'all') && isvector(hand)
        NEW = hand;
    else
        error('Invalid scaling type');
    end
elseif isa(hand, 'function_handle')
    NEW = hand(OLD);
else
    error('Invalid scaling type');
end

% Do interpolation
newmap = interp1(OLD, map, NEW);

end

