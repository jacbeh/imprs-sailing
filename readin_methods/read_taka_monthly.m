%% Import
close all
clear all
clc

% load('training_data/taka/Taka_pCO2_eth_v2021.mat');

% https://www.pmel.noaa.gov/co2/story/LDEO+Surface+Ocean+CO2+Climatology
load xlon
load ylat
cd /Users/jacquelinebehncke/Desktop/PhD/Data/pCO2


takahashi = readtable('takahashi_monthly.txt','VariableNamingRule','preserve');
takahashi.Properties.VariableNames = ["LAT","LON", "MONTH", "PCO2_SW", "MOD_SST", "VCO2_AIR", "PCO2_AIR",   "PBARO", "SST", "SAL", "DELTA_PCO2", "WINDSPEED", "P_VEL_SW06", "GASCOEFSW","K0_CO2", "AREA_MKM2", "ICE_PCT",  "FLUXM2SW06",  "FLUXGMSW06",    "TFLUXSW06"];


%% Gridded pCO2-Takahashi climatology (4°lat x 5°lon)

pco2_grid=NaN(size(unique(takahashi.LAT),1),size(unique(takahashi.LON),1),size(unique(takahashi.MONTH),1));

lat = takahashi.LAT;
lon = takahashi.LON;
CO2 = takahashi.PCO2_SW;
date = takahashi.MONTH;

count=0;
countdate = 1;
        
for mm = 1:12   

    ind = find(date ==mm);

    if ~isempty(ind)
            
                datedummy=date(ind);
                londummy=lon(ind);
                latdummy=lat(ind);
                CO2dummy=CO2(ind);
                
                countlat=1;
        for uu=-76:4:80
    
        ind1=find(latdummy>=uu & latdummy< uu+1);
            
            if ~isempty(ind)
                datedummy1=datedummy(ind1);
                londummy1=londummy(ind1);
                latdummy1=latdummy(ind1);
                CO2dummy1=CO2dummy(ind1);
                
                countlon=1;
    
                for zz=[182.5:5:357.5,2.5:5:177.5] %2.5:5:357.5%-180:1:179
            
                ind2=find(londummy1>=zz & londummy1<zz+1);
                    
                    datedummy2=datedummy1(ind2);
                    londummy2=londummy1(ind2);
                    latdummy2=latdummy1(ind2);
                    CO2dummy2=CO2dummy1(ind2);
                    
                    if ~isempty(ind2)
                        
                        finCO2=mean(CO2dummy2,"omitnan");
                        
                        pco2_grid(countlat,countlon,countdate)=finCO2;
                        
                        count=count+1;
                
                    end
            
                    countlon=countlon+1;
            
               end
        
            end
    
            countlat=countlat+1;
    
        end
    end
    countdate=countdate+1;
end

% save('pco2taka.mat','pco2taka')
% dummy = pco2_grid;
% pco2_grid(:,1:end) = dummy(:,[37:end,1:36]);


%% regridding and interpolation 


[xx,yy] = meshgrid(xlon,ylat);                  % new mesh
lat_grid=-76:4:80;
lon_grid=2.5:5:357.5;%2.5:5:357.5;
lon_grid = lon_grid-180;
%[xxt,yyt] = meshgrid(lon_grid,lat_grid);        % original mesh
[xxt,yyt] = ndgrid(lon_grid,lat_grid);          % original mesh
pco2_grid = permute(pco2_grid,[2 1 3]);



pco2_taka = NaN(180,360,12);

for mm = 1:12
    F = griddedInterpolant(xxt,yyt,squeeze(pco2_grid(:,:,mm)));      % create interpolation
    %[Xq,Yq] = ndgrid(2.5:1:357.5,-76.5:1:80.5);       % define grid with finer resolution
    [Xq,Yq] = ndgrid(-179.5:1:179.5,-89.5:1:89.5);     % define grid with finer resolution
    

    Vq = F(Xq,Yq);
    % plot original and finer resolution
    figure()   
    pcolor(Xq,Yq,Vq); title(sprintf('Finer resolution - Month %i',mm))
    colorbar
    caxis([280 480])
    figure()
    pcolor(xxt,yyt,squeeze(pco2_grid(:,:,mm))); title(sprintf('Original resolution - Month %i',mm))
    colorbar
    caxis([280 480])
%     % % convert ndgrid in meshgrid
%     xm = pagetranspose(Xq);
%     ym = pagetranspose(Yq);
%     vm = pagetranspose(Vq);
% 
% 
%     % add "extra" coordinates 
% 
%     % add 14 lat-ccordinates in front and 10 at the end
%     testy = ym;
%     testy(1:13,:)= NaN;
%     testy(14:end+13,:)=ym;
%     testy(end+1:end+9,:)= NaN;
%     
%     % add 2 lon-ccordinates in front and 2 at the end
%     testx = xm;
%     testx(:,1:2)= NaN;
%     testx(:,3:end+2)=xm;
%     testx(:,end+1:end+2)= NaN;
%     
%     % add extra lon AND lat coordinates
%     testv = vm;
%     testv(:,1:2)= NaN;
%     testv(:,3:end+2)=vm;
%     testv(:,end+1:end+2)= NaN;
%     
%     test2v = testv;
%     test2v(1:13,:)= NaN;
%     test2v(14:end+13,:)=testv;
%     test2v(end+1:end+9,:)= NaN; 
%     
%     pco2_taka = test2v;

%Vq = fillmissing(Vq, 'linear');
Vq = inpaintn(Vq);

    figure(3)
    pcolor(xx,yy,permute(Vq, [2 1])); title(sprintf('Final (finer) resolution - Month %i',mm))
    colormap jet
    colorbar 
    caxis([280 480])

    pco2_taka(:,:,mm) = permute(Vq, [2 1]);

    
end
%save('pco2_taka.mat','pco2_taka')
%% Test plot
dotsize=3;
load coastlines.mat

for mm =1:12
    
    figure()
    % plotv = pco2_grid;
    % ylat=-76:4:80;
    % xlon=-179.5:5:179.5;%[177.5:5:357.5,2.5:5:172.5] %2.5:5:357.5;
    
    plotv = pco2_taka(:,:,mm);
    % plotv = squeeze(data_taka(2,:,:));
    % xlon = lon;
    % ylat = lat;
    
    
        [xx,yy] = meshgrid(xlon,ylat);
        mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
        s=pcolor(xx,yy,plotv); title(sprintf('Month %i',mm))
        s.EdgeColor='none';
    %     caxis([mnx mx]);
        caxis([300 430])
        colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
        hold (gca,'on');
        plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');
end
  
    clear plotv mx mnx plotvc s ;

%% one year for all months

for i = 1:12:624
    pco2_taka(:,:,i:i+11) = pco2_taka(:,:,1:12);
end

pco2_taka = permute(pco2_taka,[2 1 3]);

%save('pco2_taka.mat','pco2_taka')

