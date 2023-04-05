function [varargout] = grabarg(n, fun_handle, varargin)
%GRABARG Wrapper to grab specific positional arguments of function handles.
%   Usage: [output_n1, output_n2, ...] = grabarg(n(:), @fun, <args>)
%   Inputs:
%       n:..........Vector containing which arguments to grab.
%                   (If the function output depends on the number of
%                   outputs defined, the output number that is requested of
%                   the function MUST appear in this vector.)
%       @fun:.......Function handle to call to grab arguments.
%                   For regular functions, this variable can be entered as
%                       @function
%                   Evaluation happens as 
%       <args>:.....Arguments for the function handle.
%   Outputs:
%       output_nX:..The X'th output corresponds to the n(X)'th output from
%                   callling the function passed.
%   Example usage:
%       M = [0, 0, 0; 0, 1, 0];
%       a = max(M, [], 'all', 'linear')
%           a =
%               1
%       [a, b] = max(M, [], 'all', 'linear')
%           a =
%               1
%           b =
%               4
%       a = grabarg(2, @max, M, [], 'all', 'linear');
%           a =
%               4
%       [a, b] = grabarg(1:-1:2, @max, M, [], 'all', 'linear');
%           a =
%               4
%           b =
%               1

% Check function handle
if ischar(fun_handle)
    fun_handle = str2func(fun_handle);
elseif ~isa(fun_handle, 'function_handle')
    error('Invalid input for function. Input name as string or the handle');
end

% Check if positional arguments make sense
if any(n(:) <= 0) || any(round(n(:)) ~= n(:)) || (~(isvector(n)))
    error('Positional arguments must be non-negative integer vector!');
end
nmax = nargout(fun_handle);
if (nmax >= 0) && (max(n) > nmax)
    error('The function does not have such a positional argument');
end

nnum = max(n);
output = cell(nnum, 1);
[output{:}] = fun_handle(varargin{:});
varargout = cell(1, length(n));
for i = 1:length(n)
    varargout{i} = output{n(i)};
end

end

