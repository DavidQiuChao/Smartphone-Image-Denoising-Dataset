%% This script calculate the defective pixels' location
%% via fit the distribution of the mean black image.
%% All pixels outside the confidential interval of the distibution
%% is considered as detective pixels


NUM_WORKERS = 16;
prepare_parallel_pool(NUM_WORKERS);

path = fullfile(pwd,'meanBlack.mat');
blackMean = load(path);
blackMean = blackMean.x;

%% transpose the matrix cased by python lib h5py
blackMean = blackMean';

[H,W] = size(blackMean);
mask = zeros(size(blackMean));
%% vectorize the matirx to fit the WLS algorithm
xs = blackMean(:);
fprintf('estimate ditribution')
[mu,sigma] = FitNormWLS_my(xs);
fprintf('estimate done');
parfor i = 1:H
    for j = 1:W
        tmp = gaussmf(blackMean(i,j),[sigma,mu]);
        if tmp<0.0005 || tmp>0.9995
            mask(i,j) = 1
        end
    end
end

parsave(fullfile(pwd,'badPixel.mat'),mask);
fprintf('done')


function [ mu, sig ] = FitNormWLS_my( x )
%Fitting a normal distribution using weighted least squares (WLS)
N=numel(x);
%empirical cumulative distribution function
p = (1:N) - .5;
p = p' / N;
x = sort(x);
%mask = x>0.0 & x<1203.0;
%x = x( mask );
%p = p(mask);
wgt = 1 ./ sqrt(p.*(1-p));
normObjCen = @(params) sum(wgt.*(normcdf(x,(params(1)),(params(2))) - p).^2);
options = optimset('Display','off');
[paramHatCen, fval, exitflag] = ...
    fminsearch(normObjCen, [double(mean(x)),double(std(x))], options);
if exitflag < 1
    mu = median(x);
    sig = std(x);
else
    mu = paramHatCen(1);
    sig = paramHatCen(2);
end
end
