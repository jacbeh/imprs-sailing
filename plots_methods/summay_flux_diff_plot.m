%----------------------------------------------------------------------
% 0. Load data
%----------------------------------------------------------------------

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load fluxA
load standdev_field.mat
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load flux_socatv2022-sail
% fluxB = squeeze(mean(flux_est,'omitnan'));
fluxB = flux_est;
% flux_diff = fluxA - fluxB;
unit = '[mol C m^{-2} yr^{-1}]';

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/MATLAB_Data/
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/functions
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions/m_map
load coastlines.mat
load xlon 
load ylat 
[xx,yy] = meshgrid(xlon,ylat);
% load saildata
load saildata_regrid
saildata_regrid(1:144,:,:) = [];

%----------------------------------------------------------------------
% 1. Calculate flux difference
%----------------------------------------------------------------------


% calculate flux difference: 480x180x360
for i = 1:size(fluxA,1)
    for j = 1:size(fluxA,2)
        for k =1:size(fluxA,3) 
            flux_diff_field(i,j,k) = abs(diff([fluxA(i,j,k), fluxB(i,j,k)]));
        end
    end
end

A = squeeze(mean(fluxA,'omitnan'));
B = squeeze(mean(fluxB,'omitnan'));
% calculate flux difference: 180x360
for j = 1:size(fluxA,2)
    for k =1:size(fluxA,3) 
        flux_diff(j,k) = abs(diff([A(j,k),B(j,k)]));
    end
end

%----------------------------------------------------------------------
%% Flux difference - worldmap plot
%----------------------------------------------------------------------

figure('units','normalized','outerposition',[0 0 1 1]);
clf
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',14)
% Plot variable2plot
pltv=flux_diff; 
s=pcolor(xx,yy,pltv);
s.EdgeColor='none';
hold (gca,'on');
mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
[cs,h]=contour(xx,yy,flux_diff,80,'LineColor','k');
h.LevelList = round(h.LevelList,2);
clabel(cs,h,'fontsize',10);%     % Plot Route
for i = 433:480
        xxr = xx(~isnan(saildata_regrid(i,:,:)));
        yyr = yy(~isnan(saildata_regrid(i,:,:)));
        scatter(xxr,yyr,15,'k','filled')
end
hold off
cmap = colormap(redblue(256));
cmap(1:70,:) = [];
colormap(cmap)
% Plot Labelling etc.
xlabel('Longitude')
ylabel('Latitude')
set(gca,'FontSize',18)
box on
title('Flux difference < SOCATv2022 - sailing data >')
 
cbar = colorbar;
caxis([0 .25])
cbarrow
ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)

clear s cbar  xxr yyr mm  

%----------------------------------------------------------------------
%% Flux difference - Southern Ocean plot
%----------------------------------------------------------------------

figure('units','normalized','outerposition',[0 0 1 1]);
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',14)
cbar = colorbar('eastoutside');
cbar.Position = cbar.Position - [.1 0 0 0];
cmap = colormap(redblue(256));
cmap(1:70,:) = [];
colormap(cmap)
cbarrow
caxis([0 .25])

% title('Flux difference < SOCATv2022 - sailing data >')

title({'Difference in air-sea CO_2 flux due to sailing data'}, 'Position', [0, 1.3, 0]);
m_proj('stereographic','lat',-90,'long',10,'radius',60); %radisu 50 für -60°S bis -40°S
m_coast('patch',[.7 .7 .7],'HandleVisibility','off');      %,'edgecolor','none'
m_grid('tickdir','out','xtick',12,'linest','-','backcolor',...
    [0.9    0.9    .9],'XAxisLocation','top','Fontsize',14);
hold on
s = m_pcolor(xx, yy,flux_diff);

s.EdgeColor='none';
[cs,h]=m_contour(xx,yy,flux_diff,'LineColor','k','LineWidth',1.5);
% h.LevelList = round(h.LevelList,2);
clabel(cs,h,'fontsize',10);
% m_scatter(saildata.Longitude,saildata.Latitude,5,'k')
%     saildata_regrid(467,:,:);
    for i = 433:480
        xxr = xx(~isnan(saildata_regrid(i,:,:)));
        yyr = yy(~isnan(saildata_regrid(i,:,:)));
        m_scatter(xxr,yyr,30,'k','filled')
    end
% xxr = xx(~isnan(saildata_regrid(468,:,:)));
% yyr = yy(~isnan(saildata_regrid(468,:,:)));
% m_scatter(xxr,yyr,30,'k','filled')
% xxr = xx(~isnan(saildata_regrid(469,:,:)));
% yyr = yy(~isnan(saildata_regrid(469,:,:)));
% m_scatter(xxr,yyr,30,'k','filled')
ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',16)
hold off

%----------------------------------------------------------------------
%% Flux difference - last month (Dec 2021) Southern Ocean
%----------------------------------------------------------------------

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load fluxA
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load flux_socatv2022-sail
fluxB = flux_est;

for i = 1:size(fluxA,1)
    i
    for j = 1:size(fluxA,2)
        for k =1:size(fluxA,3) 
            flux_diff_field(i,j,k) = abs(diff([fluxA(i,j,k), fluxB(i,j,k)]));
        end
    end
end 

figure('units','normalized','outerposition',[0 0 1 1]);
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',18)
cbar = colorbar('eastoutside');
cbar.Position = cbar.Position - [.1 0 0 0];
cmap = colormap(redblue(256));
cmap(1:70,:) = [];
colormap(cmap)
cbarrow
caxis([0 .8])

% title('Flux difference < SOCATv2022 - sailing data >')

title({'Difference in air-sea CO_2 2021 flux due to sailing data'}, 'Position', [0, 1.3, 0]);
m_proj('stereographic','lat',-90,'long',10,'radius',60); %radisu 50 für -60°S bis -40°S
m_coast('patch',[.7 .7 .7],'HandleVisibility','off');      %,'edgecolor','none'
m_grid('tickdir','out','xtick',12,'linest','-','backcolor',...
    [0.9    0.9    .9],'XAxisLocation','top','Fontsize',14);
hold on
 % Plot hatched pattern for positive differences
 pltv2=squeeze(flux_diff_field(480,:,:))-2*squeeze(standdev_field(480,:,:)); % hatched
%  pltv2=squeeze(mean(squeeze(flux_diff_field(469:480,:,:)),'omitnan')-2*mean(squeeze(standdev_field(469:480,:,:)),'omitnan')); % hatched
    [~,h2]=m_contourf(xx,yy,pltv2,[0 300]);
 set(h2,'FaceColor','k');
 drawnow;
hFills = h2.FacePrims;  % array of TriangleStrip objects
[hFills.ColorType] = deal('truecoloralpha');  % default = 'truecolor'
for idx = 1 : numel(hFills)
   hFills(idx).ColorData(4) = 80;   % default=255
end

% plotv = abs(fluxA(480,:,:)-fluxB(480,:,:));
pltv1=squeeze(flux_diff_field(480,:,:));
% pltv1=squeeze(mean(flux_diff_field(469:480,:,:),'omitnan'));

s = m_pcolor(xx, yy,squeeze(pltv1));

s.EdgeColor='none';
[cs,h]=m_contour(xx,yy,squeeze(pltv1),'LineColor','k','LineWidth',1.5);
% h.LevelList = round(h.LevelList,2);
clabel(cs,h,'fontsize',10);
% m_scatter(saildata.Longitude,saildata.Latitude,5,'k')
%     saildata_regrid(467,:,:);
xxr = xx(~isnan(saildata_regrid(467,:,:)));
yyr = yy(~isnan(saildata_regrid(467,:,:)));
m_scatter(xxr,yyr,30,'k','filled')
xxr = xx(~isnan(saildata_regrid(468,:,:)));
yyr = yy(~isnan(saildata_regrid(468,:,:)));
m_scatter(xxr,yyr,30,'k','filled')
xxr = xx(~isnan(saildata_regrid(469,:,:)));
yyr = yy(~isnan(saildata_regrid(469,:,:)));
m_scatter(xxr,yyr,30,'k','filled')
ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',20)

% hh = hatchfill2(hp,'cross','LineWidth',1,'Fill','off');
hold off

%----------------------------------------------------------------------
%% Flux difference - last month (Dec 2021) worldmap 
%----------------------------------------------------------------------

figure('units','normalized','outerposition',[0 0 1 1]);
clf
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',14)
% Plot variable2plot
plotv = fluxA(480,:,:)-fluxB(480,:,:);
s=pcolor(xx,yy,squeeze(plotv));
s.EdgeColor='none';
hold (gca,'on');
mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
[cs,h]=contour(xx,yy,squeeze(plotv),80,'LineColor','k');
h.LevelList = round(h.LevelList,2);
clabel(cs,h,'fontsize',10);%     % Plot Route
for i = 433:480
        xxr = xx(~isnan(saildata_regrid(i,:,:)));
        yyr = yy(~isnan(saildata_regrid(i,:,:)));
        scatter(xxr,yyr,15,'k','filled')
end
hold off
colormap(redblue) 
% Plot Labelling etc.
xlabel('Longitude')
ylabel('Latitude')
set(gca,'FontSize',14)
box on
title('Flux difference 2021 < SOCATv2022 - sailing data >')
 
cbar = colorbar;
caxis([-1.5 1.5])
cbarrow
ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)

clear s cbar  xxr yyr mm  

%--------------------------------------------------------------------------
%% flux over time: 40x1 global
%--------------------------------------------------------------------------
%standdev_runA_SOCAT_flux.m % script; calculates standard deviation of SOCAT runs 


% load ocean area
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021
load area.mat
oc_area = area;                                           % area of each grid cell
sum(oc_area,'all')                                        % ocean surface are in m2
clear area

% % load flux
% cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
% load flux_socatv2022_1.mat
% flux1 = flux_est;
% load flux_socatv2022_2.mat
% flux2 = flux_est;
% load flux_socatv2022_3.mat
% flux3 = flux_est;
% load flux_socatv2022_4.mat
% flux4 = flux_est;
% load flux_socatv2022_5.mat
% flux5 = flux_est;
% load flux_socatv2022_6.mat
% flux6 = flux_est;
% load flux_socatv2022_7.mat
% flux7 = flux_est;
% load flux_socatv2022_8.mat
% flux8 = flux_est;
% load flux_socatv2022_9.mat
% flux9 = flux_est;
% load flux_socatv2022_11.mat
% flux11 = flux_est;

% cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
% load flux_socatv2022-sail
% fluxB = flux_est;
% 
% flux conversion from mol C yr-1 m-2 in Pg C yr-1
% for i = 1:480
%     %fluxA_PgC(i,:,:) = squeeze(fluxA(i,:,:)).*oc_area.*12.*10^-15; % mol C yr-1 m-2 flux (dummy) multiplied by area, atomic mass and Peta to convert in Pg C yr-1
%     fluxB_PgC(i,:,:) = squeeze(fluxB(i,:,:)).*oc_area.*12.*10^-15;
%     flux1_PgC(i,:,:) = squeeze(flux1(i,:,:)).*oc_area.*12.*10^-15; % mol C yr-1 m-2 flux multiplied by area, atomic mass and Peta to convert in Pg C yr-1
%     flux2_PgC(i,:,:) = squeeze(flux2(i,:,:)).*oc_area.*12.*10^-15;
%     flux3_PgC(i,:,:) = squeeze(flux3(i,:,:)).*oc_area.*12.*10^-15;
%     flux4_PgC(i,:,:) = squeeze(flux4(i,:,:)).*oc_area.*12.*10^-15;
%     flux5_PgC(i,:,:) = squeeze(flux5(i,:,:)).*oc_area.*12.*10^-15;
%     flux6_PgC(i,:,:) = squeeze(flux6(i,:,:)).*oc_area.*12.*10^-15;
%     flux7_PgC(i,:,:) = squeeze(flux7(i,:,:)).*oc_area.*12.*10^-15;
%     flux8_PgC(i,:,:) = squeeze(flux8(i,:,:)).*oc_area.*12.*10^-15;
%     flux9_PgC(i,:,:) = squeeze(flux9(i,:,:)).*oc_area.*12.*10^-15;
%     flux11_PgC(i,:,:) = squeeze(flux11(i,:,:)).*oc_area.*12.*10^-15;
% end
% clear flux2 flux3 flux4 flux5 flux6 flux7 flux8 flux9 flux11
% 
% for i = 1:size(flux1,1)
%     i
%     for j = 1:size(flux1,2)
%         for k =1:size(flux1,3)
%             val = [flux1_PgC(i,j,k),flux2_PgC(i,j,k),flux3_PgC(i,j,k),...
%                 flux4_PgC(i,j,k),flux5_PgC(i,j,k),flux6_PgC(i,j,k),...
%                 flux7_PgC(i,j,k),flux8_PgC(i,j,k),flux9_PgC(i,j,k),...
%                 flux11_PgC(i,j,k)];
%             fluxA_PgC(i,j,k) = mean(val,'omitnan');
%         end
%     end
% end

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load fluxB_PgC
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load fluxA_PgC
load standdev

% caluculate annual mean
yyears = repelem(1982:2021,1,12);

count=1;
for i=1:12:length(yyears)
    % 40 (years) x 180 (lat) x 360 (lon)
    annual_meanA(count,:,:)=mean(fluxA_PgC(i:i+11,:,:),'omitnan');
    annual_meanB(count,:,:)=mean(fluxB_PgC(i:i+11,:,:),'omitnan');
    count=count+1;
end

for i=1:size(unique(yyears),2)
    % parameters 40x1
    meanA(i)=sum(reshape(squeeze(annual_meanA(i,:,:)),[],1),'omitnan');
    meanB(i)=sum(reshape(squeeze(annual_meanB(i,:,:)),[],1),'omitnan');
end
yyears = 1982:2021;

figure()
plot(yyears,meanA,'b','LineWidth',1.5)
hold on
plot(yyears,meanB,'r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [meanA+standdev, fliplr(meanA+standdev.*(-1))];
f = fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.3);
hold off
%grid on
legend('SOCAT+sail','SOCAT-sail','Location','southwest')
%xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xlim([1982 2021])
ylim([-2.7 -0.9])
yticks(fliplr([-.5 -1 -1.5 -2 -2.5]))

% Landschützer 2014 (excluding Arctic and coastal regions): −1.42 ± 0.53 Pg C yr−1
mean(meanA,'omitnan') % -1.7777
mean(meanB,'omitnan') % -1.7671
mean(standdev) % 0.0666


%--------------------------------------------------------------------------
%% flux over time: 480x1 global
%--------------------------------------------------------------------------
% x-axis: months (not years)
% caluculate monthly mean

yyears = repelem(1982:2021,1,12);

count=1;
for i=1:length(yyears)
    % 480 (months) x 180 (lat) x 360 (lon)
    month_meanA(count,:,:)=mean(fluxA_PgC(i,:,:),'omitnan');
    month_meanB(count,:,:)=mean(fluxB_PgC(i,:,:),'omitnan');
    count=count+1;
end

for i=1:length(yyears)
    % parameters 480x1
    mean_monthlyA(i)=sum(reshape(squeeze(month_meanA(i,:,:)),[],1),'omitnan');
    mean_monthlyB(i)=sum(reshape(squeeze(month_meanB(i,:,:)),[],1),'omitnan');
end

% yyears = 1982:2021;

yyears = 1:480;
% mm_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
mm_str = 1982:2021;

mm_str = repmat(mm_str,1,40);
figure('units','normalized','outerposition',[0 0 1 1]);
plot(yyears,mean_monthlyA,'b','LineWidth',1.5)
hold on
plot(yyears,mean_monthlyB,'r','LineWidth',1.5)
% x2 = [yyears, fliplr(yyears)];
% inBetween = [mean_monthlyA, fliplr(mean_monthlyA.*(-1))];
% f = fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.3);
hold off
grid on
legend('SOCAT+sail','SOCAT-sail','Location','southwest')
title('Global')
subtitle('Jan 1982 - Dec 2021')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xticks(1:12:480)
% xticklabels([])
% xlabel('Time [Months]')
xticklabels(mm_str)
xtickangle(90)
set(gca,'Fontsize',20)
%--------------------------------------------------------------------------
%% flux over time: 12x1 global
%--------------------------------------------------------------------------
% x-axis: Jan - Dec

% % caluculate monthly mean
% yyears = repelem(1982:2021,1,12);
% 
% count=1;
% for i=1:12
%     % 12 (months) x 180 (lat) x 360 (lon)
%     meanmonthA(count,:,:)=mean(fluxA_PgC(i:12:length(yyears),:,:),'omitnan');
%     meanmonthB(count,:,:)=mean(fluxB_PgC(i:12:length(yyears),:,:),'omitnan');
%     count=count+1;
% end
% 
% for i=1:12
%     % parameters 12x1
%     monthA(i)=sum(reshape(squeeze(meanmonthA(i,:,:)),[],1),'omitnan');
%     monthB(i)=sum(reshape(squeeze(meanmonthB(i,:,:)),[],1),'omitnan');
% end
%----------------------------------------------------------------------
% STEP1: mask - we do not need mask now, because we want to see global
%----------------------------------------------------------------------

fluxes = NaN(10,480,180,360);
fluxes(1,:,:,:) = flux1_PgC;
fluxes(2,:,:,:) = flux2_PgC;
fluxes(3,:,:,:) = flux3_PgC;
fluxes(4,:,:,:) = flux4_PgC;
fluxes(5,:,:,:) = flux5_PgC;
fluxes(6,:,:,:) = flux6_PgC;
fluxes(7,:,:,:) = flux7_PgC;
fluxes(8,:,:,:) = flux8_PgC;
fluxes(9,:,:,:) = flux9_PgC;
fluxes(10,:,:,:) = flux11_PgC;

%----------------------------------------------------------------------
% STEP2: calculate monthly mean (12x1)
%----------------------------------------------------------------------


[~,fluxA_12x1]  = monthly_flux_mean(fluxA_PgC);
[~,fluxB_12x1]  = monthly_flux_mean(fluxB_PgC);

[~,fluxA1_12x1]  = monthly_flux_mean(squeeze(fluxes(1,:,:,:)));
[~,fluxA2_12x1]  = monthly_flux_mean(squeeze(fluxes(2,:,:,:)));
[~,fluxA3_12x1]  = monthly_flux_mean(squeeze(fluxes(3,:,:,:)));
[~,fluxA4_12x1]  = monthly_flux_mean(squeeze(fluxes(4,:,:,:)));
[~,fluxA5_12x1]  = monthly_flux_mean(squeeze(fluxes(5,:,:,:)));
[~,fluxA6_12x1]  = monthly_flux_mean(squeeze(fluxes(6,:,:,:)));
[~,fluxA7_12x1]  = monthly_flux_mean(squeeze(fluxes(7,:,:,:)));
[~,fluxA8_12x1]  = monthly_flux_mean(squeeze(fluxes(8,:,:,:)));
[~,fluxA9_12x1]  = monthly_flux_mean(squeeze(fluxes(9,:,:,:)));
[~,fluxA11_12x1]  = monthly_flux_mean(squeeze(fluxes(10,:,:,:)));



%----------------------------------------------------------------------
% STEP3: calculate std 12x1
%----------------------------------------------------------------------

standdev_12x1 = nan(1,12);
for i=1:12
   val = [fluxA1_12x1(i),fluxA2_12x1(i),fluxA3_12x1(i),...
        fluxA4_12x1(i),fluxA5_12x1(i),fluxA6_12x1(i),...
        fluxA7_12x1(i),fluxA8_12x1(i),fluxA9_12x1(i),fluxA11_12x1(i)];
    standdev_12x1(i)= std(val);
end


yyears = 1:12;
mm_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
figure(3)
plot(yyears,fluxA_12x1,'b','LineWidth',1.5)
hold on
plot(yyears,fluxB_12x1,'r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [fluxA_12x1+standdev_12x1, fliplr(fluxA_12x1+standdev_12x1.*(-1))];
f = fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.3);
hold off
grid on
legend('SOCAT+sail','SOCAT-sail','Location','south')
%xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xticks(1:12)
title('Global')
xticklabels(mm_str)
xlim([1 12])
xtickangle(45)
% ylim([-2.7 -0.9])
yticks([-2.2 -1.8 -1.4 -1])
ylim([-2.25 -.9])
grid off

%--------------------------------------------------------------------------
%% flux over time: 12x1 Southern Ocean -50°S - -60°S
%--------------------------------------------------------------------------

% x-axis: Jan - Dec - ONLY SO FRONTBAND

mask = [-60, -50, -179.5,179.5];
fluxes = NaN(10,480,180,360);
fluxes(1,:,:,:) = flux1_PgC;
fluxes(2,:,:,:) = flux2_PgC;
fluxes(3,:,:,:) = flux3_PgC;
fluxes(4,:,:,:) = flux4_PgC;
fluxes(5,:,:,:) = flux5_PgC;
fluxes(6,:,:,:) = flux6_PgC;
fluxes(7,:,:,:) = flux7_PgC;
fluxes(8,:,:,:) = flux8_PgC;
fluxes(9,:,:,:) = flux9_PgC;
fluxes(10,:,:,:) = flux11_PgC;


ylat = [-89.5:89.5]';
xlon = [-179.5:179.5]';
[xx,yy] = meshgrid(xlon,ylat);
%----------------------------------------------------------------------
% STEP 1: apply clipping mask on all 10xfluxA (here:all_frontfluxA)
%        and fluxA_PgC (the mean of 10xfluxA) and fluxB_fluxB_PgC
%----------------------------------------------------------------------
minlat = mask(1);
maxlat = mask(2);
minlon = mask(3);
maxlon = mask(4);

ind = find(xx >= minlon & xx <= maxlon & yy >= minlat & yy <= maxlat);

% clip fluxes A
all_frontfluxA = NaN(10,480,180,360);
frontfluxA = NaN(480,180,360);

for f = 1:size(fluxesA,1)
flux = squeeze(fluxesA(f,:,:,:));

    for i = 1:480
        dummy = squeeze(flux(i,:,:));
        nrs = reshape(1:numel(ones(180,360)),180,360);
        indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
        dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
        frontfluxA(i,:,:) = dummy;
    end
    all_frontfluxA(f,:,:,:) = frontfluxA;
end    


clear frontfluxA

% clip fluxB and mean fluxA
frontfluxB = NaN(480,180,360);
frontfluxA = NaN(480,180,360);
for i = 1:480
    dummy = squeeze(fluxB_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
    frontfluxB(i,:,:) = dummy; 

    dummy = squeeze(fluxA_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
    frontfluxA(i,:,:) = dummy; 
end
%----------------------------------------------------------------------
% STEP2: calculate monthly mean (12x1)
%----------------------------------------------------------------------


[~,monthlymean_frontfluxA]  = monthly_flux_mean(frontfluxA);
[~,monthlymean_frontfluxB]  = monthly_flux_mean(frontfluxB);

[~,monthlymean_fluxA1]  = monthly_flux_mean(squeeze(all_frontfluxA(1,:,:,:)));
[~,monthlymean_fluxA2]  = monthly_flux_mean(squeeze(all_frontfluxA(2,:,:,:)));
[~,monthlymean_fluxA3]  = monthly_flux_mean(squeeze(all_frontfluxA(3,:,:,:)));
[~,monthlymean_fluxA4]  = monthly_flux_mean(squeeze(all_frontfluxA(4,:,:,:)));
[~,monthlymean_fluxA5]  = monthly_flux_mean(squeeze(all_frontfluxA(5,:,:,:)));
[~,monthlymean_fluxA6]  = monthly_flux_mean(squeeze(all_frontfluxA(6,:,:,:)));
[~,monthlymean_fluxA7]  = monthly_flux_mean(squeeze(all_frontfluxA(7,:,:,:)));
[~,monthlymean_fluxA8]  = monthly_flux_mean(squeeze(all_frontfluxA(8,:,:,:)));
[~,monthlymean_fluxA9]  = monthly_flux_mean(squeeze(all_frontfluxA(9,:,:,:)));
[~,monthlymean_fluxA11]  = monthly_flux_mean(squeeze(all_frontfluxA(10,:,:,:)));



%----------------------------------------------------------------------
% STEP3: calculate std 12x1
%----------------------------------------------------------------------

standdev_front = nan(1,12);
for i=1:12
   val_front = [monthlymean_fluxA1(i),monthlymean_fluxA2(i),monthlymean_fluxA3(i),...
        monthlymean_fluxA4(i),monthlymean_fluxA5(i),monthlymean_fluxA6(i),...
        monthlymean_fluxA7(i),monthlymean_fluxA8(i),monthlymean_fluxA9(i),monthlymean_fluxA11(i)];
    standdev_front(i)= std(val_front);
end

figure(4)
yyears = 1:12;
mm_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
plot(yyears,monthlymean_frontfluxA,'b','LineWidth',1.5)
hold on
plot(yyears,monthlymean_frontfluxB,'r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [monthlymean_frontfluxA+standdev_front, fliplr(monthlymean_frontfluxA+standdev_front.*(-1))];
f = fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.3);
hold off
grid off
legend('SOCAT+sail','SOCAT-sail','Location','south')
%xlabel('Time [Year]')
title('Southern Ocean [-50°S -60°S]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xticks(1:12)
xticklabels(mm_str)
xlim([1 12])
% ylim([-2.7 -0.9])
% yticks(fliplr([-.5 -1 -1.5 -2 -2.5]))

%--------------------------------------------------------------------------
%% flux over time: 12x1 North Atlantic (0°N - 70°N)
%--------------------------------------------------------------------------

% x-axis: Jan - Dec - 

mask = [0, 68.6236, -83.0081,20]; 
fluxes = NaN(10,480,180,360);
fluxes(1,:,:,:) = flux1_PgC;
fluxes(2,:,:,:) = flux2_PgC;
fluxes(3,:,:,:) = flux3_PgC;
fluxes(4,:,:,:) = flux4_PgC;
fluxes(5,:,:,:) = flux5_PgC;
fluxes(6,:,:,:) = flux6_PgC;
fluxes(7,:,:,:) = flux7_PgC;
fluxes(8,:,:,:) = flux8_PgC;
fluxes(9,:,:,:) = flux9_PgC;
fluxes(10,:,:,:) = flux11_PgC;


ylat = [-89.5:89.5]';
xlon = [-179.5:179.5]';
[xx,yy] = meshgrid(xlon,ylat);
%----------------------------------------------------------------------
% STEP 1: apply clipping mask on all 10xfluxA (here:all_frontfluxA)
%        and fluxA_PgC (the mean of 10xfluxA) and fluxB_fluxB_PgC
%----------------------------------------------------------------------
minlat = mask(1);
maxlat = mask(2);
minlon = mask(3);
maxlon = mask(4);

ind = find(xx >= minlon & xx <= maxlon & yy >= minlat & yy <= maxlat);

% clip fluxes A
all_NAfluxA = NaN(10,480,180,360);
NAfluxA = NaN(480,180,360);

for f = 1:size(fluxesA,1)
flux = squeeze(fluxesA(f,:,:,:));

    for i = 1:480
        dummy = squeeze(flux(i,:,:));
        nrs = reshape(1:numel(ones(180,360)),180,360);
        indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
        dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
        NAfluxA(i,:,:) = dummy;
    end
    all_NAfluxA(f,:,:,:) = NAfluxA;
end    


clear NAfluxA

% clip fluxB and mean fluxA
NAfluxB = NaN(480,180,360);
NAfluxA = NaN(480,180,360);
for i = 1:480
    dummy = squeeze(fluxB_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
    NAfluxB(i,:,:) = dummy; 

    dummy = squeeze(fluxA_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
    NAfluxA(i,:,:) = dummy; 
end
%----------------------------------------------------------------------
% STEP2: calculate monthly mean (12x1)
%----------------------------------------------------------------------


[~,monthlymean_NAfluxA]  = monthly_flux_mean(NAfluxA);
[~,monthlymean_NAfluxB]  = monthly_flux_mean(NAfluxB);

[~,monthlymean_fluxA1]  = monthly_flux_mean(squeeze(all_NAfluxA(1,:,:,:)));
[~,monthlymean_fluxA2]  = monthly_flux_mean(squeeze(all_NAfluxA(2,:,:,:)));
[~,monthlymean_fluxA3]  = monthly_flux_mean(squeeze(all_NAfluxA(3,:,:,:)));
[~,monthlymean_fluxA4]  = monthly_flux_mean(squeeze(all_NAfluxA(4,:,:,:)));
[~,monthlymean_fluxA5]  = monthly_flux_mean(squeeze(all_NAfluxA(5,:,:,:)));
[~,monthlymean_fluxA6]  = monthly_flux_mean(squeeze(all_NAfluxA(6,:,:,:)));
[~,monthlymean_fluxA7]  = monthly_flux_mean(squeeze(all_NAfluxA(7,:,:,:)));
[~,monthlymean_fluxA8]  = monthly_flux_mean(squeeze(all_NAfluxA(8,:,:,:)));
[~,monthlymean_fluxA9]  = monthly_flux_mean(squeeze(all_NAfluxA(9,:,:,:)));
[~,monthlymean_fluxA11]  = monthly_flux_mean(squeeze(all_NAfluxA(10,:,:,:)));



%----------------------------------------------------------------------
% STEP3: calculate std 12x1
%----------------------------------------------------------------------

standdev_NA = nan(1,12);
for i=1:12
   val_front = [monthlymean_fluxA1(i),monthlymean_fluxA2(i),monthlymean_fluxA3(i),...
        monthlymean_fluxA4(i),monthlymean_fluxA5(i),monthlymean_fluxA6(i),...
        monthlymean_fluxA7(i),monthlymean_fluxA8(i),monthlymean_fluxA9(i),monthlymean_fluxA11(i)];
    standdev_NA(i)= std(val_front);
end

figure(4)
yyears = 1:12;
mm_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
plot(yyears,monthlymean_NAfluxA,'b','LineWidth',1.5)
hold on
plot(yyears,monthlymean_NAfluxB,'r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [monthlymean_NAfluxA+standdev_NA, fliplr(monthlymean_NAfluxA+standdev_NA.*(-1))];
f = fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.3);
hold off
grid off
legend('SOCAT+sail','SOCAT-sail','Location','south')
%xlabel('Time [Year]')
title('North Atlantic [0° - 70°N]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xticks(1:12)
xticklabels(mm_str)
xlim([1 12])
% ylim([-2.7 -0.9])
% yticks(fliplr([-.5 -1 -1.5 -2 -2.5]))

%% global, NA, front in one

figure(5)
yyears = 1:12;
mm_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};

% North Atlantic
plot(yyears,monthlymean_NAfluxA,'LineStyle','-.','Color','b','Marker','none','LineWidth',1.5)
hold on
plot(yyears,monthlymean_NAfluxB,'LineStyle','-.','Color','r','Marker','none','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [monthlymean_NAfluxA+standdev_NA, fliplr(monthlymean_NAfluxA+standdev_NA.*(-1))];
fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.5,'Marker','none','LineStyle','none');

% Southern Ocean front
plot(yyears,monthlymean_frontfluxA,'LineStyle','--','Color','b','Marker','none','LineWidth',1.5)
plot(yyears,monthlymean_frontfluxB,'LineStyle','--','Color','r','Marker','none','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [monthlymean_frontfluxA+standdev_front, fliplr(monthlymean_frontfluxA+standdev_front.*(-1))];
fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.5,'Marker','none','LineStyle','none');
grid off
hold off
%xlabel('Time [Year]')
% title('North Atlantic [0° - 70°N]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xticks(1:12)
xticklabels(mm_str)
xlim([1 12])

yyaxis right
plot(yyears,fluxA_12x1,'LineStyle','-','Color','b','Marker','none','LineWidth',1.5)
hold on
plot(yyears,fluxB_12x1,'LineStyle','-','Color','r','Marker','none','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [fluxA_12x1+standdev_12x1, fliplr(fluxA_12x1+standdev_12x1.*(-1))];
fill(x2, inBetween, [.8 .8 .8], 'FaceAlpha',0.5,'Marker','none','LineStyle','none');
hold off
ax = gca;
ax.YAxis(2).Limits = [-2.7 .5];
legend('North Atlantic (0° - 70°N)','','',...
    'Southern Ocean (-50°S - -60°S)','','','Global','Location','southeast')
ax.YAxis(2).Color = 'k';
grid on

