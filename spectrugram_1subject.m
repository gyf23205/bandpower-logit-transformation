      Fs=100; %Sampling Frequency
      frequency_range=[0 25]; %Limit frequencies from 0 to 25 Hz
      taper_params=[7.5 14]; %Time bandwidth and number of tapers
      window_params=[30 10]; %Window size is 4s with step size of 1s
      min_nfft=0; %No minimum nfft
      detrend_opt='constant'; %detrend each window by subtracting the average
      weighting='unity'; %weight each taper at 1
      plot_on=true; %plot spectrogram
      verbose=true; %print extra info
      data = zeros(size(Data(2).signal,1)*size(Data(2).signal,2),1);
      for i=1:size(Data(2).signal,1)*size(Data(2).signal,2)
          data(i)=Data(2).signal(i);
      end

      %Compute the multitaper spectrogram
      [spect,stimes,sfreqs] = multitaper_spectrogram(data,Fs,frequency_range, taper_params, window_params, min_nfft, detrend_opt, weighting, plot_on, verbose);
