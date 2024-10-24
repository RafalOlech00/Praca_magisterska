function result = Projekt_wyniki_15_g12_16_neural_network()
clc;
clear variables;


% Główny skrypt
% Zaawansowany kod MATLAB do predykcji parametru WeldTempPiro

% Krok 1: Wczytanie danych z pliku Excel
filename = 'wyniki_15_g12_16.xlsx';  
data = readtable(filename);


% Krok 2: Przygotowanie danych
inputVars = data.Properties.VariableNames;
inputVars(strcmp(inputVars, 'WeldTempPiro')) = []; % Usuwamy nazwę kolumny 'WeldTempPiro' z listy zmiennych wejściowych

X = data{:, inputVars}; % Zmienne wejściowe
Y = data.WeldTempPiro;  % Zmienna wyjściowa

% % Czyszczenie danych: usunięcie wartości odstających
% z_thresh = 3;
% z_scores = abs((X - mean(X)) ./ std(X));
% outlier_idx = any(z_scores > z_thresh, 2);
% X_clean = X(~outlier_idx, :);
% Y_clean = Y(~outlier_idx, :);


% Czyszczenie danych: usunięcie wartości odstających przy użyciu IQR
data_clean = data;
for i = 1:length(inputVars)
    Q1 = quantile(data_clean.(inputVars{i}), 0.25);
    Q3 = quantile(data_clean.(inputVars{i}), 0.75);
    IQR = Q3 - Q1;
    lower_bound = Q1 - 1.5 * IQR;
    upper_bound = Q3 + 1.5 * IQR;
    % Filtrowanie danych, zachowując tylko te w granicach
    data_clean = data_clean(data_clean.(inputVars{i}) >= lower_bound & data_clean.(inputVars{i}) <= upper_bound, :);
end

X_clean = data_clean{:, inputVars}; % Zmienne wejściowe po czyszczeniu
Y_clean = data_clean.WeldTempPiro;  % Zmienna wyjściowa po czyszczeniu


% Normalizacja danych 
mu = mean(X_clean);
sigma = std(X_clean);
X_clean = (X_clean - mu) ./ sigma;

% Krok 3: Podział danych na zbiór treningowy i testowy
cv = cvpartition(size(X_clean, 1), 'HoldOut', 0.1);
XTrain = X_clean(training(cv), :);
YTrain = Y_clean(training(cv), :);
XTest = X_clean(test(cv), :);
YTest = Y_clean(test(cv), :);

% Krok 4: Stworzenie i trenowanie sieci neuronowej z najlepszymi parametrami

% Najlepsze parametry
bestParams.HiddenLayerSize = 30;
bestParams.LearningRate = 0.01;
bestParams.MaxEpochs = 1500;
bestParams.TrainFunction = 'trainlm';

% Stworzenie sieci neuronowej z najlepszymi parametrami
net = fitnet(bestParams.HiddenLayerSize);

% Ustawienie parametrów treningu
net.trainFcn = bestParams.TrainFunction;
net.trainParam.lr = bestParams.LearningRate;
net.trainParam.epochs = bestParams.MaxEpochs;
net.performParam.regularization = 0.1;

% Wyłączenie wyświetlania okienka postępu treningu
net.trainParam.showWindow = false; % Wyłączenie wyświetlania okienka
net.trainParam.showCommandLine = false; % Wyłączenie wyświetlania informacji w command window

% Trening sieci neuronowej
[net, tr] = train(net, XTrain', YTrain');

% Krok 5: Ocena najlepszego modelu na zbiorze testowym
YPred = net(XTest');
mseError = mse(net, YTest', YPred);

% Predykcja na zbiorze treningowym
YTrainPred = net(XTrain');

% Konfiguracja okna figury
figure;
set(gcf, 'Position', [275, 100, 1000, 400]); % [left, bottom, width, height]

% Konfiguracja wykresu
h1 = plot(NaN, NaN, 'b'); 
hold on;
h2 = plot(NaN, NaN, 'r'); 
legend('Actual', 'Predicted');
title('Actual vs Predicted WeldTempPiro (Neural Network) - 12-16');
xlabel('Sample');
ylabel('Temperature');
hold off;

% Określenie opóźnienia (w sekundach) dla rysowania linii 'Actual' i 'Predicted'
actual_delay = 0.1;  % Większe opóźnienie dla linii 'Actual' w każdej iteracji
predicted_delay = 0.01;  % Bardzo małe opóźnienie dla linii 'Predicted'
start_delay_actual = 5;  % Całkowite opóźnienie startu rysowania linii 'Actual' w sekundach

% Zmienne do przechowywania aktualnych punktów rysowania
predicted_index = 1;
actual_index = 1;
start_time = tic;  % Rozpoczęcie liczenia czasu

% Rysowanie wykresu z opóźnieniem
while predicted_index <= length(YPred) || actual_index <= length(YTest)
    elapsed_time = toc(start_time);  % Obliczanie upływu czasu
    
    % Rysowanie linii 'Predicted' 
    if predicted_index <= length(YPred)
        set(h2, 'XData', 1:predicted_index, 'YData', YPred(1:predicted_index));
        predicted_index = predicted_index + 1;
        pause(predicted_delay);  % Małe opóźnienie dla 'Predicted'
    end

    % Rysowanie linii 'Actual' z opóźnionym startem
    if elapsed_time >= start_delay_actual && actual_index <= length(YTest)
        set(h1, 'XData', 1:actual_index, 'YData', YTest(1:actual_index));
        actual_index = actual_index + 1;
        pause(actual_delay);  % Większe opóźnienie dla 'Actual'
    end
    
    drawnow;  % Aktualizacja wykresu
end

% Czekanie na naciśnięcie klawisza
disp('Naciśnij dowolny klawisz, aby zamknąć wykres...');
waitforbuttonpress;


% Zwracanie wyniku
result = 'Wykres został wygenerowany';
end