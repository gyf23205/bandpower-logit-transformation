%% Clear
clc
clear



%% Info
data_path = 'D:\matlab\projects\sleep\data\raw_eeg\';
data_dir = dir([data_path,'*PSG.edf']);
PARTICIPANT_NUM = 10;
START_NUM=1;
for i =START_NUM:START_NUM+PARTICIPANT_NUM-1
    ata(i-START_NUM+1).data= edfread([data_path data_dir(i).name]);
end


for j = 1:PARTICIPANT_NUM
    Data(j).signal = zeros(3000,height(ata(j).data));
    for k = 1:height(ata(j).data)
        Data(j).signal(:,k) = ata(j).data.(2){k};
    end
    Data(j).samples = width(Data(j).signal);
end
clear ata



% Info
for i =1:PARTICIPANT_NUM
    Data(i).info= edfinfo([data_path data_dir(i).name]);
end


for j = 1:PARTICIPANT_NUM
    Data(j).Fs = Data(j).info.NumSamples(2)/seconds(Data(j).info.DataRecordDuration);
end




% asdfasdf assfaascvacsf 
label_dir = dir([data_path,'*Hypnogram.edf']);
for i =1:PARTICIPANT_NUM
    Data(i).hyp= edfinfo([data_path label_dir(i).name]).Annotations;
end


%% Normalization
% mean centered samples and mean
% for j = 1:PARTICIPANT_NUM
%     Data(j).mean = zeros(Data(j).samples, 1);
%     for i = 1:Data(j).samples
%         Data(j).mean(i) = sum(Data(j).signal(:,i)) /length(Data(j).signal(:,i));
%         Data(j).signal(:,i) = Data(j).signal(:,i) - Data(j).mean(i);
%     end
% end
% 
% % z-standard and variance
% for j = 1:PARTICIPANT_NUM
%     Data(j).var = zeros(Data(j).samples, 1);
%     for i = 1:Data(j).samples
%         Data(j).var(i) = sum(Data(j).signal(:,i).^2) / length(Data(j).signal(:,i));
%         Data(j).signal(:,i) = Data(j).signal(:,i) / sqrt(Data(j).var(i));
%     end
% 
% end
% Data = rmfield(Data, "mean");
% Data = rmfield(Data, "var");
%% Get labels
sample_duration = 30;
for i = 1:PARTICIPANT_NUM
    Data(i).label = zeros(1, Data(i).samples);
    start = 1;
    for j = 1:length(Data(i).hyp.Annotations)
        len = seconds(Data(i).hyp.Duration(j)/sample_duration);
        state = Data(i).hyp.Annotations{j}(end);
        switch state
            case 'W'
                state = 0;
            case '1'
                state = 1;
            case '2'
                state = 2;
            case '3'
                state = 3;
            case '4'
                state = 3;
            case 'R'
                state = 4;
            otherwise
                state = -1;
        end    
            Data(i).label(start:start+len-1) = state;
            start = start + len;
    end
    % Remove annotations that are longer than the recorded signals
    Data(i).label = Data(i).label(1:Data(i).samples);
    % Remove movements and unknowns
    remove_idx = find(Data(i).label==-1);
    Data(i).signal(:, remove_idx) = [];
    Data(i).label(remove_idx) = [];
    Data(i).samples = Data(i).samples - length(remove_idx);
end
save('Data', "Data");