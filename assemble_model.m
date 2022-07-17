function pred=assemble_model(classifiers, X)
    pred = zeros(1,size(X,1));
    for i = 1:size(X,1)
        labels = [predict(classifiers{1}, X(i,1)),predict(classifiers{2}, X(i,2)),predict(classifiers{3}, X(i,3)),predict(classifiers{4}, X(i,4))];
        pred(i) = mode(labels);
    end
end
