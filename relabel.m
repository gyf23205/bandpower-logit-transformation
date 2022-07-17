function labels=relabel(cluster_label, class_label, class_num)
    correspondance = zeros(class_num,class_num);
    for i =1:length(cluster_label)
        correspondance(cluster_label(i)+1, class_label(i)+1)=correspondance(cluster_label(i)+1, class_label(i)+1)+1;
    end
    names = zeros(class_num,1);
    for i=1:class_num
        temp=find(correspondance(i,:)==max(correspondance(i,:)))-1;
        if(length(temp)==1)
            names(i) = temp;
        else
            names(i)=temp(1); % in case max value appear more than once
        end
    end
    labels = zeros(1,length(class_label));
    for i = 1:length(class_label)
        labels(i)=names(cluster_label(i)+1);
    end
end