%==========================================================================
% Plot SOCAT- and sailing data
%==========================================================================
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/MATLAB_Data/

load saildata.mat
load socat.mat
socat(1:144,:,:)=[];
load xlon
load ylat
%%
%figure('units','normalized','outerposition',[0 0 1 1]);
%subplot(1,2,1);
close all
figure(8)
tt = 480; %612 for months, 52 for years

[xx,yy] = meshgrid(xlon,ylat);
% last index represents the year. User can change that too. (52 for year)

for i = tt-11:tt

    %plotv=fco2_ave_weighted(:,:,i)';  
    plotv=squeeze(socat(i,:,:));
    
    s=pcolor(xx,yy,plotv);
    
    s.EdgeColor='none';
    caxis([250 450])
    hold(gca, 'on')


end
hold off
coast = load('coastlines.mat');
mapshow(coast.coastlon, coast.coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8]);
colormap jet; 
% grid off
% set(hcb,'location','eastoutside','yaxislocation','right');
ylabel('Latitude','FontSize',18)
xlabel('Longitude','FontSize',18)
hcb=colorbar('southoutside'); 
% title('SOCAT: Surface water fCO_2','FontSize',26)
% ylabel(hcb, '[μatm]')
ylim([-90 90])
xlim([-180 180])
set(gca, 'FontSize',18)
set(hcb,'orientation','horizontal');
xlabel(hcb, 'fCO_2 [μatm]')
cbarrow
% set(gca, 'Projection','perspective')

%%
figure
scatter(saildata.Longitude,saildata.Latitude,10,saildata.fCO_2);


colormap jet; %hcb=colorbar; %set(hcb,'orientation','horizontal');
hold on
coast = load('coastlines.mat');
mapshow(coast.coastlon, coast.coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8]);
hold off
ylabel('Latitude','FontSize',18)
xlabel('Longitude','FontSize',18)
title('Sailing data: Surface water fCO_2 (2018 - 2021)','FontSize',26)
set(gca,'FontSize',18)
box on
grid on
ylim([-90 90])
xlim([-180 180])
caxis([250 450])
% %cbarrow
% %hcb.Title.String = "fCO_2 [μatm]";
% xlabel(hcb, 'fCO_2 [μatm]')
% hcb.Layout.Tile = 'south'; 

%%
figure(6)
%saildata2 = saildata(saildata.Date > datetime('01-Dec-2020') & saildata.Date < datetime('01-Jan-2021 12', 'Format','dd-MMM-y HH'),:);
saildata2 = saildata(saildata.Date > datetime('01-Dec-2020') & saildata.Date < datetime('01-Jan-2021', 'Format','dd-MMM-y'),:);

scatter(saildata2.Longitude,saildata2.Latitude,15,saildata2.fCO_2);

grid on
colormap jet; %hcb=colorbar; %set(hcb,'orientation','horizontal');
hold on
coast = load('coastlines.mat');
mapshow(coast.coastlon, coast.coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8]);
hold off
ylabel('Latitude','FontSize',18)
xlabel('Longitude','FontSize',18)
title('Sailing data: Surface water fCO_2 (2018 - 2021)','FontSize',26)
set(gca,'FontSize',18)
box on
ylim([-90 90])
xlim([-180 180])
caxis([250 450])