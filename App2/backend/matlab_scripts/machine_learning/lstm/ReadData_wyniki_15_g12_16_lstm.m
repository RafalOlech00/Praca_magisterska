function [X, Y] = ReadData_wyniki_15_g12_16_lstm()
    % Wczytanie danych
    data = readtable('wyniki_15_g12_16.xlsx');

    % Usunięcie wierszy z jakimikolwiek wartościami NaN
    data_clean = rmmissing(data);

    % Lista cech do analizy
    features = {'Volt', 'ImpederTemp', 'Curr', 'Power', 'Speed', 'Freq'};

    % Usuwanie wartości odstających dla każdej cechy
    for i = 1:length(features)
        Q1 = quantile(data_clean.(features{i}), 0.25);
        Q3 = quantile(data_clean.(features{i}), 0.75);
        IQR = Q3 - Q1;
        lower_bound = Q1 - 1.5 * IQR;
        upper_bound = Q3 + 1.5 * IQR;
        % Filtrowanie danych, zachowując tylko te w granicach
        data_clean = data_clean(data_clean.(features{i}) >= lower_bound & data_clean.(features{i}) <= upper_bound, :);
    end
    
    % Tworzenie interakcji między cechami
    for i = 1:length(features)
        for j = i+1:length(features)
            interaction_name = [features{i} '_' features{j}];
            data_clean.(interaction_name) = data_clean.(features{i}) .* data_clean.(features{j});
        end
    end

    % Polinomialne rozszerzenie cech
    for i = 1:length(features)
        data_clean.([features{i} '_Squared']) = data_clean.(features{i}) .^ 2;
        data_clean.([features{i} '_Cubed']) = data_clean.(features{i}) .^ 3;
    end

    % Logarytmiczne transformacje cech
    for i = 1:length(features)
        log_feature_name = [features{i} '_Log'];
        data_clean.(log_feature_name) = log(data_clean.(features{i}) + 1); % Dodajemy 1, aby uniknąć log(0)
    end

    % Lista wszystkich cech (oryginalne, interakcje, rozszerzenia i logarytmy)
    feature_names = features;
    for i = 1:length(features)
        for j = i+1:length(features)
            feature_names = [feature_names, {[features{i} '_' features{j}]}];
        end
        feature_names = [feature_names, {[features{i} '_Squared'], [features{i} '_Cubed'], [features{i} '_Log']}];
    end

    % Przypisanie cech i etykiet
    X = data_clean{:, feature_names};
    Y = data_clean.WeldTempPiro;
end
