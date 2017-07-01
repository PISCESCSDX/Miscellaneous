function [index, prefs]= mdf_make_index(namevec)
% function [index]= mdf_make_index(namevec)
%
% erzeugt aus der Liste aller mdf-Namen einen index-Vektor
% mit der Nummer des Präfixes (erste beiden Buchstaben)
% sowie der laufenden Nummer der Datei
%
% input         namevec  string-Matrix mit n MDF-Namen (gleiche
%                        Länge)
% ouput         index    index der Dateien mit dim= (n, 2)
%               prefs    cell vektor der gefundenen Präfixs

    %find out used prefixes
    prefs= {};
    for i= 1:size(namevec,1)
        prefix= namevec(i, 1:2);
        prefs= union(prefs, {prefix});
    end
    
    %create index vector
    fnum = size(namevec, 1);
    cmp_vec1= mat2cell(namevec(:,1:2), ones(fnum, 1), 2);
    index= zeros(fnum, 2);
    for i1= 1:size(prefs,2)
        cmp_vec2= strrepeat(prefs(i1), fnum)';
        index(strcmp(cmp_vec1, cmp_vec2), 1) = i1;
    end
    index(:, 2)= str2num(namevec(:, 3:end-4));

end