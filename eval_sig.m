function s = eval_sig(x, pts, N)

	p = length(pts); % 需要采样点的坐标宽度，相比N可以代表时间吧
	s = zeros(1,p);  % 初始化采样坐标宽度相同的空间

	for j = 1:p
		s(j) = 0;  % 再次赋值0初始化
		for l = 1:length(x.inds) %非零频率的位置x.inds 频率的幅值x.spx
			s(j) = s(j) + x.spx(l) * exp( 2*pi*i*pts(j)*(x.inds(l)-1)/N ); % 得出信号幅值
        end
        % to get total l^2 norm = nu, scale random variable by 1/sqrt(N)
		s(j) = 1/sqrt(N) * (s(j) + x.nu * randn(1)); % 加上噪声
	end
