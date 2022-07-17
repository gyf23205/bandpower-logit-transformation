clc;
clear;
load("Data.mat")
PARTICIPANTS = 10;
for i =1:PARTICIPANTS
    disp(i);
    awake = [Data(i).label == 0];
    n1 = [Data(i).label == 1];
    n2 = [Data(i).label == 2];
    n3 = [Data(i).label == 3];
    rem = [Data(i).label == 4];
    
    % Data(i).features=zeros(6,Data(i).samples);
    % for j=1:Data(i).samples
    %     [p_beta2,p_beta1,p_alpha2,p_alpha1, p_theta, p_delta]=feature_extractor(Data(i).signal(:,j));
    %     power =  [p_beta2,p_beta1,p_alpha2,p_alpha1, p_theta, p_delta];
    %     total_power = sum(power);
    %     reltative_power=power/total_power;
    %     transf = @(x)log(x/(1-x));
    %     Data(i).features(:,j) = [transf(reltative_power(1)),transf(reltative_power(2)),transf(reltative_power(3)),transf(reltative_power(4)),transf(reltative_power(5)),transf(reltative_power(6))];
    % end
    
    Data(i).features=zeros(4,Data(i).samples);
    for j=1:Data(i).samples
        [p_beta,p_alpha, p_theta, p_delta]=feature_extractor(Data(i).signal(:,j));
        power =  [p_beta,p_alpha, p_theta, p_delta];
        total_power = sum(power);
        reltative_power=power/total_power;
        Data(i).features(:,j) = [reltative_power(1),reltative_power(2),reltative_power(3),reltative_power(4)];
    end
    for j=1:4
        Data(i).features(j,:) = Data(i).features(j,:) + min(Data(i).features(j,:))+0.001;
        [temp,~] = boxcox(Data(i).features(j,:).');
        Data(i).features(j,:) = temp.';
    end
end


