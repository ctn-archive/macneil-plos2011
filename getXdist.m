% get distribution of points in D dimensions
function x = getXdist(domain, D, dx)

num = ceil((domain(2) - domain(1))/(dx));
if D == 1
    x = domain(1):dx:domain(2);
else
    % get random points
    x = (domain(1) + (domain(2)-domain(1)).*rand(D, num));
    magnitude = sqrt(sum(x.^2,1));
    length = (domain(1) + (domain(2)-domain(1)).*rand(1,num));
    
    % normalize
    x = x./(ones(D,1)*(magnitude./length));
end