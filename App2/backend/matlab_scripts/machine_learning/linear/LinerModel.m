function [Y_pred] = LinerModel(X_train, Y_train, X_test, Y_test)
    % Trenowanie modelu
    model = fitlm(X_train, Y_train);
    
    % Przewidywanie wartości na zbiorze testowym
    Y_pred = predict(model, X_test);

    % Ocena modelu na zbiorze treningowym
    Y_train_pred = predict(model, X_train);

    % Wywołanie funkcji oceniającej model
    %EvaluateModel(Y_train, Y_train_pred, Y_test, Y_pred);

end