function notify(msg,urg)
%NOTIFY Send message to dbus about matlab finishing execution

if ~exist('msg','var')
    msg = '''Notification from MATLAB''';
elseif ~ischar(msg)
    error( 'Needs character array for message' )
else
    msg = [ '''', msg, '''' ];
end

if ~exist('urg','var')
    urg = 'low';
end
switch urg
    case 'low'
        urg = '''low''';
    case 'normal'
        urg = '''normal''';
    case 'critical'
        urg = '''critical''';
    otherwise
        error( 'Urgency must be [low,normal,critical]' );
end

system(['notify-send -i ''apps/matlab'' --urgency=',urg,' ''MATLAB'' ',msg]);

end

