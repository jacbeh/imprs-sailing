% Die Funktion Geogr_Scatterplot stellt Messwerte in einer Weltkarte 
% graphisch dar. Es werden 3 Weltkarten-Layouts angeboten.
% Es gibt einen Sonderfall: Wird kein 4. Inputargument, d.h. 
% keine zu plottende Eigenschaft, angegeben, dann wird nur die Route mit 
% zeitlichem Verlauf dargestellt.
%
% Syntax:        
%                    Geogr_Scatterplot(data,Einheiten,option,j)
%
% Input:            
%                        data = Tabelle mit Messwerten
%                   Einheiten = Cell array mit Einheiten der 
%                               Tabellenspalten aus data als Einträge
%                      option = 1, 2 oder 3 (bestimmt das Layout der Karte)
%                           j = Spalte der Tabelle data, enthält Messwerte
%                
% See also: 
% geobasemap | geoshow | scatter | geoscatter
%
% Jacqueline Behncke
% 2021-04-02 (Matlab R2020b)

function Geogr_Scatterplot(data,Einheiten,option,j)
% Um Zeitverlauf in Plots darzustellen: Zeit farblich einbringen
% Dafür aus datetime-Spalte numerische Zeitwerte generieren (in Dauer in
% Tagen seit Start der Messungen)

dt = data.Date - min(data.Date);    % duration array
dt = days(dt);                      % convert dt to double array of values 
                                    % in units of days
    % leere Figure öffnen:
        
    %fig = figure('units','normalized','outerposition',[0 0 1 1]);
        
    % Weltkarten-Layout 1:
    
    if option == 1     
       
        % Landmassen darstellen:
        geoshow('landareas.shp', 'FaceColor',0.7*[1 1 1]) 
        
        % Area-of-interest festlegen:
        
        axis([-180,180,-90,90]);
        
        % Achsen beschriften, Grid hinzufügen:
        
        xlabel('Longitude')
        ylabel('Latitude')
        grid minor

        % Daten auf Landkarte plotten:
        
        hold on
        
            % Sonderfall 3 Inputargumente: 
            % Graphische Darstellung der jeweiligen Lokationen (Längen-, 
            % Breitgrade) mit farblich gekennzeichneten zeitlichem Verlauf 
            % (dt+1)
            
            if nargin == 3    
                scatter(data{:,1}, data{:,2},30,dt+1,'filled')
                
                % figure benennen für späteren Export:
                
                fig.Name = ('Route');                   
                
            % ansonsten Lokationen in Längen- und Breitengrade plotten mit 
            % farblichen Verlauf gemäß der Werte der Tabellenspalte bzw. 
            % Eigenschaft j  
            
            else
                scatter(data{:,1}, data{:,2},30,data{:,j},'filled')
                
                % figure benennen für späteren Export:
                
                fig.Name = sprintf('Map - %s',data.Properties.VariableNames{j});
                
                % Beschriftung und Colorbar hinzufügen:
                
                title(data.Properties.VariableNames{j})
                cbar = colorbar('eastoutside');
                set(get(cbar,'Title'),'String',sprintf('[%s]',Einheiten{j}))
                

            end
        hold off
    
    % Weltkarten-Layout 2 bzw. 3: 
    
    elseif option == 2 || option == 3
        
        % Bei nur 3 Inputargumente: Graphische Darstellung der jeweiligen 
        % Lokationen (Längen-, Breitgrade) mit farblich gekennzeichneten 
        % zeitlichem Verlauf (dt+1)
        
        if nargin == 3 
            geoscatter([data{:,2}], [data{:,1}],30,dt+1,'filled')
            
             % figure benennen für späteren Export:
                
                fig.Name = ('Route');
            
        % ansonsten Lokationen in Längen- und Breitengrade plotten mit 
        % farblichen Verlauf gemäß der Werte der Tabellenspalte bzw. 
        % Eigenschaft j  
        
        else
            geoscatter(data{:,2}, data{:,1},30,data{:,j},'filled') % marker size 30
            
            % figure benennen für späteren Export:
                
            fig.Name = sprintf('Map - %s',data.Properties.VariableNames{j});
                
            
            % Beschriftung und Colorbar hinzufügen:
            
            title(data.Properties.VariableNames{j})
            cbar = colorbar('eastoutside');
            set(get(cbar,'Title'),'String',sprintf('[%s]',Einheiten{j}))
            
        end
        
            % Hinzufügen der jeweiligen Basemap:
            
            if option == 2
                geobasemap streets
            else
                geobasemap satellite
            end
    
    % Ist option weder 1,2 noch 3, wird eine entsprechende Fehlermeldung 
    % ausgegeben.
    
    else
        error('3. Inputargument falsch gewählt. Option: 1,2 oder 3.')
    end
end