function [Y_pred] = BoostedModel(X_train, X_test, Y_train, Y_test) 

% Ustawienie maksymalnej liczby podziałów
numSamples = size(X_train, 1);
maxNumSplits = floor(sqrt(numSamples));

% Użycie tego parametru przy tworzeniu szablonu dla wzmocnionego drzewa
t = templateTree('MaxNumSplits', maxNumSplits);

model_boosted = fitrensemble(X_train, Y_train, 'Method', 'LSBoost', 'Learners', t);

% Obliczanie i wyświetlanie MSE
Y_pred = predict(model_boosted, X_test);

% Ocena modelu na zbiorze treningowym
Y_train_pred = predict(model_boosted, X_train);


end