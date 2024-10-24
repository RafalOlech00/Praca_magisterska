function result = Projekt_wyniki_15_g10_12()
clc;
clear variables;

% Wczytanie danych 
[X, Y] = ReadData_wyniki_15_g10_12();

% Normalizacja danych 
mu = mean(X);
sigma = std(X);
X = (X - mu) ./ sigma;

% Podział danych na treningowe i testowe
[X_train, X_test, Y_train, Y_test] = splitdata(X, Y, 0.3);

% Regresja liniowa
[Y_predL] = LinerModel(X_train, Y_train, X_test, Y_test);

% Konfiguracja okna figury
figure;
set(gcf, 'Position', [275, 100, 1000, 400]); % [left, bottom, width, height]

% Konfiguracja wykresu
h1 = plot(NaN, NaN, 'b'); 
hold on;
h2 = plot(NaN, NaN, 'r'); 
legend('Actual', 'Predicted');
title('Actual vs Predicted WeldTempPiro (Linear Regression) - 10-12');
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
while predicted_index <= length(Y_predL) || actual_index <= length(Y_test)
    elapsed_time = toc(start_time);  % Obliczanie upływu czasu
    
    % Rysowanie linii 'Predicted' 
    if predicted_index <= length(Y_predL)
        set(h2, 'XData', 1:predicted_index, 'YData', Y_predL(1:predicted_index));
        predicted_index = predicted_index + 1;
        pause(predicted_delay);  % Małe opóźnienie dla 'Predicted'
    end

    % Rysowanie linii 'Actual' z opóźnionym startem
    if elapsed_time >= start_delay_actual && actual_index <= length(Y_test)
        set(h1, 'XData', 1:actual_index, 'YData', Y_test(1:actual_index));
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
