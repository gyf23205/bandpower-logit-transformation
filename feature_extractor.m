function [p_beta, p_alpha,p_theta, p_delta] = feature_extractor(signal)
    Fs = 100;
    window_size = 30;
    winsize_samples = Fs*window_size;
    freq_resolution = 0.5;
    time_bandwidth = window_size*freq_resolution/2;
    num_tapers = floor(2*time_bandwidth)-1;
    %Generate DPSS tapers (STEP 1)
    [DPSS_tapers, DPSS_eigen] = dpss(winsize_samples, time_bandwidth, num_tapers);
    %Multiply the data by the tapers (STEP 2)
    tapered_data = repmat(signal,1,num_tapers) .* DPSS_tapers;
    %Compute the FFT (STEP 3)
    nfft=winsize_samples;
    fft_data = fft(tapered_data, nfft);
    two_side_spect = abs(fft_data/nfft);
    two_side_spect = mean(two_side_spect,2);
    power = two_side_spect(1:nfft/2+1);

%     beta2_range = [18.5, 25];
%     beta1_range = [12.5, 18.5];
    beta_range = [12.5, 25];
%     alpha2_range = [9.5, 12.5];
%     alpha1_range = [7.5, 9.5];
    alpha_range = [7.5, 12.5];
    theta_range = [3.5, 7.5];
    delta_range = [1.5, 3.5];

    freq_step = Fs/nfft;
%     beta2_index = floor(beta2_range./freq_step);
%     beta1_index = floor(beta1_range./freq_step);
    beta_index = floor(beta_range./freq_step);
%     alpha2_index = floor(alpha2_range./freq_step);
%      alpha1_index = floor(alpha1_range./freq_step);
    alpha_index = floor(alpha_range./freq_step);
    theta_index = floor(theta_range./freq_step);
    delta_index = floor(delta_range./freq_step);

%     p_beta2 = sum(power(beta2_index(1):beta2_index(2)-1));
%     p_beta1 = sum(power(beta1_index(1):beta1_index(2)-1));
    p_beta = sum(power(beta_index(1):beta_index(2)-1));
%     p_alpha2 = sum(power(alpha2_index(1):alpha2_index(2)-1));
%     p_alpha1 = sum(power(alpha1_index(1):alpha1_index(2)-1));
    p_alpha = sum(power(alpha_index(1):alpha_index(2)-1));
    p_theta = sum(power(theta_index(1):theta_index(2)-1));
    p_delta = sum(power(delta_index(1):delta_index(2)-1));

    
    

