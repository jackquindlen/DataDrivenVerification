function isafe = bounds_class(V,gam,L)
% Authors: Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu
% Case Studies in Data-Driven Verification of Dynamical Systems
% January 2016

%Classification function to determine whether run is safe or not
%   V   = training_points(1,:)
%   gam = training_points(2,:)
%   L   = training_points(9,:)

isafe = zeros(size(V));

P1 = (-2094.4).*V + (176000).*gam + (30.7208).*L + 362472;
P2 = (349).*V - (176000).*gam - (39.9344).*L + 208894.4;
P3 = V - 88;
P4 = -V + 176;

isafe( find(P1 > 0 & P2 > 0 & P3 > 0 & P4 > 0) ) = 1;