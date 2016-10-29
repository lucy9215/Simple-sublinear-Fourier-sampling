function [xs1, xs2, samp1, samp2] = generate_sample_set(x, N, m, ats1, ats2, width)
	% generates sample set for identification and for estimation. 
	
	% generate_sample_set.m actually generates the indices at which we sample the signal. 
	% There are two different sampling sets, samp1 and samp2; one for identification and one for estimation. 
	% Note that they are structured differently. Also, if you want to visualize just what indices are sampled, you can plot these sets. 
	% The variables xs1 and xs2 contain the actual sample values. 
	% Note that we actually compute the signal at these sample points rather than sampling from a large vector (more space-efficient).
	K = width*m;
	
	[nr1, ~] = size(ats1);          % nr1是ats1的长度，总循环次数rep1*rep2 15
	samp1 = zeros(log2(N)+1,K,nr1); % 初始化samp1，循环from LSB to MSB，tuple里频率个数，estimatiom循环次数
	xs1 = zeros(log2(N)+1,K,nr1);   % 初始化samp1的x轴
	for j = 1:nr1,
			t = ats1(j,1); % 随机数  [0,N-1]
			s = ats1(j,2); % 随机奇数[1,N-1]
	    	final = t + s*(K-1); % 最终的随机数，其实就是以t为起点，s为step生成一个宽度为K = width*m随机数组
	    	aprog = t:s:final;%  s作为step,从t到final生成ind 
			for b = 0:log2(N),    %循环from LSB to MSB
				geoprog = mod(aprog + (N/(2^b)),N);      % 通过aprog计算采样点的位置
				xs1(b+1,:,j) = eval_sig(x, geoprog, N);  % 采样点的幅值
	        	samp1(b+1,:,j) = geoprog;                % 采样点的位置
	    	end
	end

	[nr2, ~] = size(ats2);          % nr2是ats2的长度，总循环次数rep1*rep3  33                                                                                                
	samp2 = zeros(nr2,K);           % 初始化samp2 分别是identification循环次数，tuple里频率的个数
	xs2 = zeros(nr2,K);             % samp2的x轴
	for j = 1:nr2,
	    t = ats2(j,1); 
		s = ats2(j,2);
		final = t + s*(K-1);
		aprog = t:s:final;   % 用mod(aprog,N)作为采样点的位置
		xs2(j,:) = eval_sig(x, mod(aprog,N), N);        % 采样点的幅值
		samp2(j,:) = mod(aprog,N);                      % 采样点的位置
	end
	