function [X_train, X_test, y_train, y_test] = splitdata(X, y, test_ratio)
    n = size(X, 1);
    idx = randperm(n);
    
    train_size = round((1 - test_ratio) * n);
    
    X_train = X(idx(1:train_size), :);
    X_test = X(idx(train_size+1:end), :);
    
    y_train = y(idx(1:train_size));
    y_test = y(idx(train_size+1:end));
end