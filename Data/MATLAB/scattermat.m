function H = scattermat(M, varargin)
%SCATTER3M Wrapper to create a scatter plot immediately from a matrix
%   scattermat(M, ...) is a shorthand for invoking 
%   scatter(M(:, 1), M(:, 2), ...) or
%   scatter3(M(:,1), M(:, 2), M(:, 3), ...)

if ismatrix(M) && isnumeric(M)
    switch size(M, 2)
        case 2
            H = scatter(M(:, 1), M(:, 2), varargin{:});
        case 3
            H = scatter3(M(:, 1), M(:, 2), M(:, 3), varargin{:});
        otherwise
            error('Input must be a numeric array of size N by {2, 3}');
    end
else
    error('Input must be a numeric array');
end
end

