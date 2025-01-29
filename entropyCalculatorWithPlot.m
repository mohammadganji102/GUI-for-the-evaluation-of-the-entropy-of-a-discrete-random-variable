function entropyCalculatorWithPlot()
    % Create the main GUI window
    fig = uifigure('Name', 'Discrete RV Entropy Calculator with Plot', 'Position', [100 100 800 450]);
    
    % Create a label for the title at the top
    titleLabel = uilabel(fig)
    titleLabel.Text = "Discrete Entropy Calculator"
    titleLabel.Position = [300 370 250 30]
    titleLabel.FontSize =16
    titleLabel.FontWeight = "bold"
    
    % Create a label for the formula input
    formulaLabel = uilabel(fig)
    formulaLabel.Text="p(n) proportional to:"
    formulaLabel.FontSize=12
    formulaLabel.Position = [20 310 200 30]
  %  formulaLabel = uilabel(fig, ...
  %      'Text', 'p(n) proportional to:', ...
  %      'Position', [20 310 200 30], 'FontSize', 12);
    
    % Create a text input for the formula of p(n)
    formulaInput = uieditfield(fig, 'text', ...
        'Position', [250 310 200 30], ...
        'Placeholder', 'e.g., 1/(n+2)');
    
    % Create a label for the range input
    rangeLabel = uilabel(fig)
    rangeLabel.Text="Range of n"
    rangeLabel.Position=[20 250 200 30]
    rangeLabel.FontSize = 12;
    
    % Create a text input for the range of n
    rangeInput = uieditfield(fig, 'text', ...
        'Position', [250 250 200 30], ...
        'Placeholder', 'e.g., 0,10');
    
    % Create a label for displaying the entropy result
    entropyLabel = uilabel(fig)
    entropyLabel.Text= "Entropy="
    entropyLabel.Position=[20 180 200 30]
    entropyLabel.FontSize = 12
    
    % Create a field to display the entropy result (inside a box)
    entropyResult = uilabel(fig)
    entropyResult.Text =""
    entropyResult.Position = [250 180 200 30]
    entropyResult.FontSize = 12
    entropyResult.FontWeight = "bold"
    entropyResult.BackgroundColor=[0.9 0.9 0.9]
    entropyResult.HorizontalAlignment= "center"
    
    % Axes for plotting p(n) (Move the plot to the right side)
    ax = uiaxes(fig, 'Position',[480 90 280 250]);  % Position plot on the right;
    ax.XLabel.String = 'n';
    ax.YLabel.String = 'p(n)';
    
    % Create the exit button
    exitButton = uibutton(fig, 'push', 'Text', 'Exit', 'Position', [100 100 70 30], 'FontSize', 12, ...
        'ButtonPushedFcn', @(btn, event) close(fig));
    
    % Callback for formula and range input changes
    formulaInput.ValueChangedFcn = @(src, event) calculateAndPlot();
    rangeInput.ValueChangedFcn = @(src, event) calculateAndPlot();
    
    % Nested function to calculate entropy and update the plot
    function calculateAndPlot()
        % Get formula and range values
        formula = formulaInput.Value;
        rangeStr = rangeInput.Value;
        
        % Parse the range input
        try
            rangeVals = str2num(rangeStr); %#ok<ST2NM> 
            if length(rangeVals) ~= 2 || rangeVals(1) >= rangeVals(2)
                error('Invalid range');
            end
            nVals = rangeVals(1):rangeVals(2);
        catch
            entropyResult.Text = 'Invalid range format.';
            return;
        end
        
        % Evaluate p(n) for each n
        try
            p = arrayfun(@(n) eval(formula), nVals);
        catch
            entropyResult.Text = 'Invalid formula.';
            return;
        end
        
        % Normalize p(n) to ensure it sums to 1
        p = p / sum(p);
        
        % Calculate entropy
        entropy = -sum(p .* log2(p));
        entropyResult.Text = sprintf('%.6f', entropy);
        
        % Plot p(n)
        plot(ax, nVals, p, 'o-', 'LineWidth', 1.5, 'MarkerSize', 6);
    end
end
