function [xs1, xs2, samp1, samp2] = generate_sample_set(x, N, m, ats1, ats2, width)
	% generates sample set for identification and for estimation. 
	% generate_sample_set.m actually generates the indices at which we sample the signal. 
	% There are two different sampling sets, samp1 and samp2; one for identification and one for estimation. 
	% Note that they are structured differently. Also, if you want to visualize just what indices are sampled, you can plot these sets. 
	% The variables xs1 and xs2 contain the actual sample values. 
	% Note that we actually compute the signal at these sample points rather than sampling from a large vector (more space-efficient).
	K = width*m;
	
	[nr1, ~] = size(ats1);          % nr1是ats1的长度，总循环次数rep1*rep2
	samp1 = zeros(log2(N)+1,K,nr1); % 初始化samp1，分别是长度，tuple里频率个数，循环次数
	xs1 = zeros(log2(N)+1,K,nr1);   % 初始化samp1的x轴
	for j = 1:nr1,
			t = ats1(j,1); 
			s = ats1(j,2);
	    	final = t + s*(K-1);
	    	aprog = t:s:final;
			for b = 0:log2(N),
				geoprog = mod(aprog + (N/(2^b)),N);
				xs1(b+1,:,j) = eval_sig(x, geoprog, N);
	        	samp1(b+1,:,j) = geoprog;
	    	end
	end

	[nr2, ~] = size(ats2);          % nr2是ats2的长度，总循环次数rep1*rep3
	samp2 = zeros(nr2,K);           % 初始化samp2
	xs2 = zeros(nr2,K);             % samp2的x轴
	for j = 1:nr2,
	    t = ats2(j,1); 
		s = ats2(j,2);
		final = t + s*(K-1);
		aprog = t:s:final;
		xs2(j,:) = eval_sig(x, mod(aprog,N), N);
		samp2(j,:) = mod(aprog,N);
	end
	