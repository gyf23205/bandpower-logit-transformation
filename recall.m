function recall = recall(pred, Y)
    classes = unique(Y);
    recalls = zeros(length(classes),1);
    for i=1:length(classes)
        in_pred = pred == classes(i);
        in_ture = Y == classes(i);
        recalls(i)=sum(in_ture&in_pred)/sum(in_ture);
    end
    recall = mean(recalls);
end