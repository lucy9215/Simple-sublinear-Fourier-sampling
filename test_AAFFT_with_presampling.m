% test AAFFT with pre-sampling; i.e., don't take the IFFT to generate 
% the signal explicitly + sample, just sample from the sparse signal.
%
% Anna C. Gilbert

clear all

% set up the parameters
N = 2^15;  % N = signal length, must be a power of 2
m = 2;     % number of total tones
nu = 0.01; % TOTAL norm of the additive white noise added to sparse signal

% generate the data structure that contains signal information
x = generate_signal(N,m,nu);    % 设置了一些x的属性，结构体

% reps1 = # repetitions in the main loop of AAFFT (in fourier_sampling.m)
% reps2 = # repetitions in identification of frequencies
% reps3 = # repetitions in estimation of coefficients
% width = width of Dirchlet kernel filter
% typical values are 
% reps1 = 5
% reps2 = 5
% reps3 = 5

reps1 = 3;   %
reps2 = 5;   % identification
reps3 = 11;    %estimation
width = 15;    %滤波器宽度

% ats1 = frequency identification => reps1 * reps2 pairs of random seeds t,s 
%        (reps2 independent seeds for s and reps1*reps2 seeds for t)
% ats2 = coefficient estimation => reps1 * reps3 pairs of random seeds t,s (all independent)
% to visualize where the sampling set is:
% samp1 = all the sampling points for identification
% samp2 = all the sampling points for estimation
% ats1, ats2都是t-s对,x*2两维数组 分别为identification和estimation准备的

[ats1, ats2] = generate_tspairs(N,reps1,reps2,reps3);

[xs1, xs2, samp1, samp2] = generate_sample_set(x, N, m, ats1, ats2, width);

xxx=samp1(1,:,1);%[1,2,3];%
yyy=abs(xs1(1,:,1));%[1,1,1];%
plot(xxx,'.');




Lambda = fourier_sampling( xs1, xs2, m, ats1, ats2, reps1, reps2, reps3, N, width ); % 频率和幅度

% Lambda contains two columns: the first is the frequencies found and the second contains
% the estimated coefficients for each frequency.
% Calculate the relative l^2 error of the returned representation.

[~,recov_freq, orig_freq] = intersect(Lambda(:,1), x.inds); % 理论和结果得出的频率位置求交集以及交集的坐标，这里~是交集，recov_freq是恢复的频率在Lamda的坐标，orig_freq是在x.inds中的坐标
if ~isempty(recov_freq)   % 如果恢复的频率中有理论信号频率
    err_recov = norm(Lambda(recov_freq, 2).' - x.spx(orig_freq)); % 频率的幅值做差求l2范数
else
    err_recov = 0;   % 如果恢复的频率中没有理论信号频率，这里误差先为0
end
[~, recov_freq] = setdiff(Lambda(:,1), x.inds); % 恢复频率与理论值不同的频率成分（属于Lambda不属于x.inds)
[~, orig_freq] = setdiff(x.inds, Lambda(:,1));  % 属于x.inds,不属于Lambda
err_unrecov = norm(Lambda(recov_freq,2)) + norm(x.spx(orig_freq)); % 不同部分的幅值的l2 norm
total_err = err_recov + err_unrecov;  % 总误差
fprintf('total rel. error = %f \n', total_err/norm(x.spx));



