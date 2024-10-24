function [Y_pred] = TreeModel2(X_train, X_test, Y_train, Y_test)
    % Definiowanie hiperparametrów drzewa decyzyjnego
    minLeafSize = 5;  % Minimalna liczba próbek wymagana do bycia liściem
    maxNumSplits = floor(size(X_train, 1) / minLeafSize) - 1;  % Maksymalna liczba podziałów
    minParentSize = 10; % Minimalna liczba próbek wymagana do bycia węzłem rodzica
    predictorSelection = 'allsplits'; % Metoda wyboru podziału
    splitCriterion = 'mse'; % Kryterium podziału
    surrogate = 'off'; % Użycie surrogate splits

    % Trenowanie modelu drzewa decyzyjnego z określonymi hiperparametrami
    model_tree = fitrtree(X_train, Y_train, ...
                          'MinLeafSize', minLeafSize, ...
                          'MaxNumSplits', maxNumSplits, ...
                          'MinParentSize', minParentSize, ...
                          'PredictorSelection', predictorSelection, ...
                          'SplitCriterion', splitCriterion, ...
                          'Surrogate', surrogate);

    % Przewidywanie wartości na zbiorze testowym
    Y_pred = predict(model_tree, X_test);

    % Ocena modelu na zbiorze treningowym
    Y_train_pred = predict(model_tree, X_train);

end
