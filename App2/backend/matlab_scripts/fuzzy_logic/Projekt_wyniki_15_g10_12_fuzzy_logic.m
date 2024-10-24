function result = Projekt_wyniki_15_g10_12_fuzzy_logic()
% Krok 1: Wczytanie danych rzeczywistych
data = readtable('wyniki_15_g10_12.xlsx'); 

% Krok 2: Przygotowanie danych wejściowych i wyjściowych
volt = data.Volt;            
impeder_temp = data.ImpederTemp;
curr = data.Curr;
power = data.Power;
speed = data.Speed;
freq = data.Freq;
weld_temp_piro = data.WeldTempPiro;

% Krok 3: Wczytanie modelu logiki rozmytej
fis = readfis('Temperature_Prediction_wyniki_15_g10_12.fis');  

% Krok 4: Symulacja modelu logiki rozmytej
num_samples = height(data);
predicted_weld_temp_piro = zeros(num_samples, 1);

for i = 1:num_samples
    input_data = [volt(i), impeder_temp(i), curr(i), power(i), speed(i), freq(i)];
    predicted_weld_temp_piro(i) = evalfis(fis, input_data);
end

% Krok 5: Wygładzanie danych
smoothed_weld_temp_piro = smoothdata(weld_temp_piro, 'movmean', 100);
smoothed_predicted_weld_temp_piro = smoothdata(predicted_weld_temp_piro, 'movmean', 100);

% Krok 6: Konfiguracja okna figury
figure;
set(gcf, 'Position', [275, 100, 1000, 400]); % [left, bottom, width, height]

% Konfiguracja wykresu
h1 = plot(NaN, NaN, 'b'); 
hold on;
h2 = plot(NaN, NaN, 'r'); 
legend('Actual', 'Predicted');
title('Experimental Data vs Fuzzy Logic Predictions (10-12)');
xlabel('Sample');
ylabel('Temperature');
hold off;

% Krok 7: Określenie opóźnienia (w sekundach) dla startu linii 'Actual' i prędkości rysowania linii
start_delay_actual = 5;  % Całkowite opóźnienie startu rysowania linii 'Actual' w sekundach
predicted_delay = 0.005; % Bardzo małe opóźnienie dla linii 'Predicted'
actual_delay = 0.005;    % Bardzo małe opóźnienie dla linii 'Actual' po starcie

% Zmienne do przechowywania aktualnych punktów rysowania
predicted_index = 1;
actual_index = 1;
start_time = tic;  % Rozpoczęcie liczenia czasu

% Krok 8: Rysowanie wykresu z opóźnieniem
while predicted_index <= length(smoothed_predicted_weld_temp_piro) || actual_index <= length(smoothed_weld_temp_piro)
    elapsed_time = toc(start_time);  % Obliczanie upływu czasu
    
    % Rysowanie linii 'Predicted' 
    if predicted_index <= length(smoothed_predicted_weld_temp_piro)
        set(h2, 'XData', 1:predicted_index, 'YData', smoothed_predicted_weld_temp_piro(1:predicted_index));
        predicted_index = predicted_index + 1;
        pause(predicted_delay);  % Małe opóźnienie dla 'Predicted'
    end

    % Rysowanie linii 'Actual' z opóźnionym startem
    if elapsed_time >= start_delay_actual && actual_index <= length(smoothed_weld_temp_piro)
        set(h1, 'XData', 1:actual_index, 'YData', smoothed_weld_temp_piro(1:actual_index));
        actual_index = actual_index + 1;
        pause(actual_delay);  % Małe opóźnienie dla 'Actual'
    end
    
    drawnow;  % Aktualizacja wykresu
end

% Ostateczna aktualizacja dla pełnego zestawu danych
set(h1, 'XData', 1:num_samples, 'YData', smoothed_weld_temp_piro);
set(h2, 'XData', 1:num_samples, 'YData', smoothed_predicted_weld_temp_piro);
drawnow;

% Czekanie na naciśnięcie klawisza
disp('Naciśnij dowolny klawisz, aby zamknąć wykres...');
waitforbuttonpress;

% Zwracanie wyniku
result = 'Wykres został wygenerowany';
end
