function OUT = bezier(PTS, SAM)
%BEZIER Given control points, and sampling size outputs the bezier curve
%   Don't provide sample point number to get a function handle that will
%   plot the bezier curve itself.

N = size(PTS, 1);
D = size(PTS, 2);
X = linspace(0, 1, SAM)';
OUT = zeros(SAM, D);
for n = 1:N
    OUT = OUT + PTS(n, :) .* ...
        nchoosek(N-1, n-1) .* ( ((1-X).^(N-n)) .* ((X).^(n-1)) );
end

end

