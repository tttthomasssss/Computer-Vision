function [c, means] = k_means(d, k)
% K_MEANS Segments data using the k-means algorithm
%     [C, MEANS] = K_MEANS(D, K) expects an MxN matrix D in which each
%     column represents the coordinates of one of the N data points, and K,
%     the number of clusters to produce.
%     
%     The result C is a 1xN vector containing integers from 1 to K, giving
%     the cluster to which each point has been assigned. The result MEANS
%     is an MxK matrix in which the R'th column contains the mean of the
%     pixels in cluster R (i.e. the cluster centre).
%     
%     An empty cluster is restarted by assigning a single point chosen at
%     random to it.
%     
%     See also KMEANS (the system version with more options)

[m, n] = size(d);

cold = [];
c = ceil(rand(1, n) * k);   % initial random allocation
means = zeros(m, k);
distsq = zeros(k, n);

while 1

    % Partition I, get mean and compute squared distances
    for kk = 1:k
        part = d(:, c == kk);
        if isempty(part)     % allocate random data point as new centre
            part = d(:, ceil(rand * n));
        end
        mean = sum(part, 2) / size(part, 2);
        means(:, kk) = mean;
        diff = d - repmat(mean, 1, n);
        distsq(kk, :) = sum(diff .* diff, 1);
    end

    % Reassign to centres
    [mindist, c] = min(distsq, [], 1); %#ok<ASGLU>

    if isequal(c, cold)     % no change to clusters
        break
    end
    cold = c;

end

end
