function [best_params, best_net, best_info, best_Y_pred_test] = LSTMBestParams(X_train, X_test, Y_train, Y_test)
    % Najlepsze znalezione hiperparametry
    numHiddenUnits = 100;
    learnRate = 0.001;
    dropoutRate = 0.3;
    maxEpochs = 200;
    miniBatchSize = 30;

    % Tworzenie modelu LSTM z najlepszymi hiperparametrami
    inputSize = size(X_train, 2);
    numResponses = 1;

    layers = [ ...
        sequenceInputLayer(inputSize)
        lstmLayer(numHiddenUnits, 'OutputMode', 'last')
        fullyConnectedLayer(25)
        dropoutLayer(dropoutRate)
        fullyConnectedLayer(numResponses)
        regressionLayer];

    options = trainingOptions('adam', ...
        'MaxEpochs', maxEpochs, ...
        'MiniBatchSize', miniBatchSize, ...
        'InitialLearnRate', learnRate, ...
        'GradientThreshold', 1, ...
        'Shuffle', 'once', ...
        'Verbose', 0);  % Usunięcie opcji 'Plots', 'training-progress'

    % Przekształcenie X_train i X_test do formatu sekwencji
    X_train_seq = arrayfun(@(i) X_train(i, :)', 1:size(X_train, 1), 'UniformOutput', false);
    X_test_seq = arrayfun(@(i) X_test(i, :)', 1:size(X_test, 1), 'UniformOutput', false);

    % Trenowanie modelu LSTM
    fprintf('Training LSTM with best params: HiddenUnits=%d, LearnRate=%f, DropoutRate=%f, MaxEpochs=%d, MiniBatchSize=%d\n', ...
        numHiddenUnits, learnRate, dropoutRate, maxEpochs, miniBatchSize);
    [best_net, best_info] = trainNetwork(X_train_seq, Y_train, layers, options);

    % Przewidywanie za pomocą modelu LSTM na zbiorze testowym
    best_Y_pred_test = predict(best_net, X_test_seq);

    % Obliczenie błędu MSE dla zbioru testowego
    best_mse = mean((Y_test - best_Y_pred_test).^2);
    fprintf('Best MSE: %f\n', best_mse);

    % Przewidywanie za pomocą modelu LSTM na zbiorze treningowym
    best_Y_pred_train = predict(best_net, X_train_seq);

    % Przypisanie najlepszych parametrów
    best_params.numHiddenUnits = numHiddenUnits;
    best_params.learnRate = learnRate;
    best_params.dropoutRate = dropoutRate;
    best_params.maxEpochs = maxEpochs;
    best_params.miniBatchSize = miniBatchSize;
end
