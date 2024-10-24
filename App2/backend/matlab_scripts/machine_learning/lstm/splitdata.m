function [X_train, X_test, Y_train, Y_test] = splitdata(X, Y, test_ratio)
    n = size(X, 1);
    idx = randperm(n);
    train_size = round((1 - test_ratio) * n);
    X_train = X(idx(1:train_size), :);
    X_test = X(idx(train_size+1:end), :);
    Y_train = Y(idx(1:train_size));
    Y_test = Y(idx(train_size+1:end));
end