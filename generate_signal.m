function x = generate_signal(sigsize, sparsity, noise)
%
% generate_signal: randomly choose non-zero frequencies and give them
%          frequencies that are Gaussian random variables
%
% inputs:  sigsize: size (frequency bandwidth) of signal.
%          sparsity: number of non-zero frequencies
%          noise: the variance of the AWGN in the signal
% 
% outputs:  x: physical-space signal
%           x.inds : location of non-zero frequencies (assuming we start with 1)
%           x.spx : fourier-space signal
%           x.nu : variance of the AWGN in signal
% 
% Anna C. Gilbert

	a = randperm(sigsize);  % permute frequencies  %randpern 随机打乱一个数字序列，这里是将1:sigsize的数随机打乱排序
 	x.inds = a(1:sparsity);   % 非零频率的位置
 	x.spx = randn(1,sparsity);   % Gaussian random coefficients % m个频率的幅值 1*m的数组
 	x.nu = noise;              % 噪声的l2-norm 
    