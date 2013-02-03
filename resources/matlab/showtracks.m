function showtracks(images, tracks)
%SHOWTRACKS displays tracks for an image sequence
%   SHOWTRACKS(IMAGES, TRACKS) takes a cell array of images, as returned by
%   TEACHIMAGE('traffic', i), and a cell array of tracks, as specified for
%   the second part of the 2008 Computer Vision assignment, and produces a
%   suitable display.

% sort tracks and check data
nims = length(images);
ntracks = length(tracks);
starts = zeros(1, ntracks);
for i = 1:ntracks
    track = tracks{i};
    s = track(1,1);
    e = track(2,1);
    if s < 1 || e < 1 || s > nims || e > nims || s > e
        error(['Invalid start/end value ' num2str(s) ' ' num2str(e)]);
    end
    if ~isequal(size(track), [2 e-s+2])
        error(['Incorrect size of track matrix ' num2str(i)]);
    end
    starts(i) = s;
end
[starts, i] = sort(starts);
tracks = tracks(i);
    
% Display tracks
active = {};
for i = 1:nims
    h = imshow(images{i});
    set(get(get(h, 'Parent'), 'Parent'), 'Name', ['Image' num2str(i)]);
    hold on
    
    % delete old active tracks
    newactive = {};
    for j = 1:length(active)
        track = active{j};
        if track(2,1) >= i
            newactive = [{track} newactive];
        end
    end
    active = newactive;
    
    % get new tracks
    while ~isempty(starts) && starts(1) == i
        active = [tracks(1) active];
        tracks = tracks(2:end);
        starts = starts(2:end);
    end
    
    % plot active tracks
    for j = 1:length(active)
        track = active{j};
        s = track(1,1);
        x = track(1, 2:i-s+2);
        y = track(2, 2:i-s+2);
        plot(x, y, 'g-');
    end
    
    pause(0.5);
    hold off
end
end
