function samples = randsample_noreplace(bias, sample_no, trial_no)
%RANDSAMPLE_NOREPLACE Sample a population without replacement, with weights
% USAGE:
%   samples = randsample_noreplace(bias, sample_no, trial_no)
% INPUTS
%   bias:       The weights of the population
%   sample_no:  Number of units to sample from the population
%   trial_no:   (Optional, defaults to 1) Do it this many times
% OUTPUTS
%   samples:    Matrix. Each row is an individual sample. Each column is
%               the index corresponding to the member of population with
%               the given weight. The index are sorted according to the
%               weights.

% Check if bias is vectorial
if isvector(bias) && isnumeric(bias)
    if any(bias < 0)
        error('Weights must be non-negative');
    end
    if isrow(bias)
        bias = bias';
    end
    pop_num = size(bias, 1);
    if (~isscalar(sample_no)) || (sample_no < 1) || rem(sample_no, 1)
        error('Number of samples must be non-negative integer');
    end
    if pop_num < sample_no
        error('Sample (w/out replacement) more than the population size.');
    end
else
    error('Weights must be in the form of a numeric vector');
end

% Check if number of trials were given
if ~exist('trial_no', 'var')
    trial_no = 1;
else
    if (~isscalar(trial_no)) || (trial_no < 1) || rem(trial_no, 1)
        error('Number of trials must be non-negative integer');
    end
end

% Given weights as x, sample one unit from the population n times
get_sm = @(n, x) sum(rand(n, 1) > (cumsum([0; x(1:(end-1))] ./ sum(x))'), 2);

% Sample the first element with the given bias
samples = zeros(trial_no, sample_no);
samples(:, 1) = get_sm(trial_no, bias);

% Run for each different sample
for t = 1:trial_no
    tBias = bias;
    for s = 2:sample_no
        % Remove the sampling rate of the already picked unit
        tBias(samples(t, s-1)) = 0;
        % Sample from the unsampled population
        samples(t, s) = get_sm(1, tBias);
    end
    samples(t, :) = sort(samples(t, :));
end

samples = sortrows(samples);

end