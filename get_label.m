function label = get_label(str)
   
    % Use regexpi to perform case-insensitive matching
    isMatch = @(str, word) ~isempty(regexp(str, word));
    
    if isMatch(str, "normal")
        label = categorical("Normal");
    elseif isMatch(str, "agresivo")
         label = categorical("Agresivo");
    elseif isMatch(str, "timido")
         label = categorical("Timido");
    else
        label = categorical("Ninguno");
    end
end
