%================================================
% Kurzanleitung zur allgemeinen Datenauswertung von
% Synchronisationsmessungen mit Couronne, Emissive-, Transport-,
% B-Punkt-Sonden
%
% 1) mdfzip -> fasst die 8er Cluster der Couronne-Messung zusammen
% 2) mdf2bin -> normalisiert die Couronne auf die Standard-Abweichung
%  - eventuell "dirtyphase.m" hier benutzen, um Rippel zu neutralisieren
% 3) cnmeva -> Auswertung der Couronne Daten
% 4) plotcoulist -> plot der Couronne Daten
% 5) eva1raw -> abspeichernder Sondenmessungen in Variablen in probes.mat
%  - hier die Kanäle und die Verstärkungen eingeben
% 6) eva2eva -> Auswertung der Sondendaten
% 7) eva3plot -> plot der Sondenauswertung
%  - hier eventuell noch Unterroutinen programmieren und Diagramme in
%    einzelnen mat-files abspeichern
%================================================