%--------------------------------------------------------------------------
% loads flux estimates fluxB and fluxA and calculates mean flux (2018-2021)
% and std
%--------------------------------------------------------------------------
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load flux_socatv2022-sail.mat
fluxB = flux_est;

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load flux_socatv2022_1.mat
flux1 = flux_est;
load flux_socatv2022_2.mat
flux2 = flux_est;
load flux_socatv2022_3.mat
flux3 = flux_est;
load flux_socatv2022_4.mat
flux4 = flux_est;
load flux_socatv2022_5.mat
flux5 = flux_est;
load flux_socatv2022_6.mat
flux6 = flux_est;
load flux_socatv2022_7.mat
flux7 = flux_est;
load flux_socatv2022_8.mat
flux8 = flux_est;
load flux_socatv2022_9.mat
flux9 = flux_est;
load flux_socatv2022_11.mat
flux11 = flux_est;

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/MATLAB_Data/
load saildata_regrid.mat
saildata_regrid(1:144,:,:) = [];
load xlon 
load ylat 
[xx,yy] = meshgrid(xlon,ylat);
load coastlines.mat

yyears = repelem(1982:2021,1,12);
ind = find(yyears == 2018);
x2018 = ind(1);
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021
flux_A_mean = squeeze(mean(fluxA(x2018:end,:,:),'omitnan'));
flux_B_mean = squeeze(mean(fluxB(x2018:end,:,:),'omitnan'));


for j = 1:size(fluxA,2)
    for k =1:size(fluxA,3) 
        flux_diff2018(j,k) = abs(diff([flux_A_mean(j,k), flux_B_mean(j,k)]));
    end
end

val = nan(10,180,360);
% creates 10x annual means (RunA)
val(1,:,:) = squeeze(mean(flux1(x2018:end,:,:),'omitnan'));
val(2,:,:) = squeeze(mean(flux2(x2018:end,:,:),'omitnan'));
val(3,:,:) = squeeze(mean(flux3(x2018:end,:,:),'omitnan'));
val(4,:,:) = squeeze(mean(flux4(x2018:end,:,:),'omitnan'));
val(5,:,:) = squeeze(mean(flux5(x2018:end,:,:),'omitnan'));
val(6,:,:) = squeeze(mean(flux6(x2018:end,:,:),'omitnan'));
val(7,:,:) = squeeze(mean(flux7(x2018:end,:,:),'omitnan'));
val(8,:,:) = squeeze(mean(flux8(x2018:end,:,:),'omitnan'));
val(9,:,:) = squeeze(mean(flux9(x2018:end,:,:),'omitnan'));
val(10,:,:) = squeeze(mean(flux11(x2018:end,:,:),'omitnan'));

% calculates std out of 10 annual means
for j = 1:size(flux1,2)
    for k =1:size(flux1,3) 
        std_ult2018(j,k) = std(val(:,j,k),'omitnan');
    end
end

%%
%--------------------------------------------------------------------------
% North Atlantic-plot flux difference Dec 2021 pltv1 (180,360) as base and hatches
% areas, where diff > 2*std (pltv2)
%--------------------------------------------------------------------------


figure('units','normalized','outerposition',[0 0 1 1]);
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',18)
cbar = colorbar('eastoutside');
cbar.Position = cbar.Position - [.1 0 0 0];
cmap = colormap(flipud(spring));
colormap(cmap)
cbarrow('up')
caxis([0 .2])

% title('Flux difference < SOCATv2022 - sailing data >')

title({'Difference in air-sea CO_2 2021 flux due to sailing data'}, 'Position', [0, 1.3, 0]);
%m_proj('stereographic','lat',-90,'long',10,'radius',60); %radisu 50 für -60°S bis -40°S
m_proj('lambert','long',[-80 20],'lat',[0 60]);
m_coast('patch',[.7 .7 .7],'HandleVisibility','off');      %,'edgecolor','none'
% m_coast('patch',[1 .85 .7]);
m_grid('tickdir','out','xtick',12,'linest','-','backcolor',...
    [0.9    0.9    .9],'XAxisLocation','top','Fontsize',14);
hold on
 % Plot hatched pattern for positive differences
pltv2=flux_diff2018-2*std_ult2018;
    [~,h2]=m_contourf(xx,yy,pltv2,[0 300]);
 set(h2,'FaceColor','k');
 drawnow;
hFills = h2.FacePrims;  % array of TriangleStrip objects
[hFills.ColorType] = deal('truecoloralpha');  % default = 'truecolor'
for idx = 1 : numel(hFills)
   hFills(idx).ColorData(4) = 80;   % default=255
end

% plotv = abs(fluxA(480,:,:)-fluxB(480,:,:));
pltv1=flux_diff2018;

s = m_pcolor(xx, yy,squeeze(pltv1));

s.EdgeColor='none';
[cs,h]=m_contour(xx,yy,squeeze(pltv1),'LineColor','k','LineWidth',1.5);
% h.LevelList = round(h.LevelList,2);
clabel(cs,h,'fontsize',10);
% m_scatter(saildata.Longitude,saildata.Latitude,5,'k')
%     saildata_regrid(467,:,:);
xxr = xx(~isnan(saildata_regrid(467,:,:)));
yyr = yy(~isnan(saildata_regrid(467,:,:)));
m_scatter(xxr,yyr,50,'k','filled')
xxr = xx(~isnan(saildata_regrid(468,:,:)));
yyr = yy(~isnan(saildata_regrid(468,:,:)));
m_scatter(xxr,yyr,50,'k','filled')
xxr = xx(~isnan(saildata_regrid(469,:,:)));
yyr = yy(~isnan(saildata_regrid(469,:,:)));
m_scatter(xxr,yyr,50,'k','filled')
ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',20)

% hh = hatchfill2(hp,'cross','LineWidth',1,'Fill','off');
hold off

%%
pltv1=flux_diff;
pltv2=flux_diff-2*std_ult;


SO_NA_flux = NaN(480,180,360);
% boundaries North Atlantik
minlata = -0;                               % see Landschützer et al., 2016
maxlata = 68.6236;              
minlona = -83.0081;            
maxlona = 20;                  
% boundaries Southern Ocean
minlatb = -85.5625;
maxlatb = -40;                              % see Landschützer et al., 2016
minlonb = -180;
maxlonb = 180;

inda = find(xx >= minlona & xx <= maxlona & yy >= minlata & yy <= maxlata);
indb = find(xx >= minlonb & xx <= maxlonb & yy >= minlatb & yy <= maxlatb);
ind = union(inda,indb);                    % all NA and SO grid cells/coordinates
  

dummy = pltv1;
nrs = reshape(1:numel(ones(180,360)),180,360);
indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
pltv1_mask = dummy; 

  
dummy = pltv2;
nrs = reshape(1:numel(ones(180,360)),180,360);
indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
pltv2_mask = dummy; 
    

%%
figure(2)
clf
set(gca,'Position',get(gca,'Position')*0.95)
% Choose variable2plot
% flux_diff = abs(squeeze(mean(fluxA,'omitnan'))-squeeze(mean(fluxB,'omitnan')));
% pltv1=squeeze(mean(fluxB,'omitnan'));
pltv1 = pltv1_mask;
pltv2 = pltv2_mask;
s = pcolor(xx,yy,pltv1);
s.EdgeColor = 'none';
cmap = colormap(flipud(spring));
colormap(cmap)
caxis([0 .2])
cbar = colorbar;
cbarrow('up')
hold on
% Plot hatched pattern for positive differences
[~,h2]=contourf(xx,yy,pltv2,[0 10]);
set(h2,'FaceColor','k');
drawnow;
hFills = h2.FacePrims;  % array of TriangleStrip objects
[hFills.ColorType] = deal('truecoloralpha');  % default = 'truecolor'
for idx = 1 : numel(hFills)
   hFills(idx).ColorData(4) = 80;   % default=255
end

% Plot Route
for i = 433:480
    xxr = xx(~isnan(saildata_regrid(i,:,:)));
    yyr = yy(~isnan(saildata_regrid(i,:,:)));
    scatter(xxr,yyr,15,'k','filled')
end
% Plot continents
mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
hold off
% Add Labels etc.
% xlabel('Longitude')
% ylabel('Latitude')
% title('Flux difference')
% subtitle('Shaded areas: flux diff > 2*std')
ylim([-10 80])
xlim([-120 60])
xticks([])
yticks([])
ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',18)
set(gca,'FontSize',18)
box on

%% Flux over time

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


[frontfluxA, frontfluxB,standdev_front] = mask_fluxovertime(mask,fluxes,fluxA,fluxB);
atlmask = [0,68.6236,-83.0081,20];
[atlfluxA, atlfluxB,standdev_atl] = mask_fluxovertime(atlmask,fluxes,fluxA,fluxB);

%--------------------------------------------------------------------------
% plots flux over time: North Atlantik 
%--------------------------------------------------------------------------
yyears = 1982:2021;

figure(1)
plot(yyears,atlfluxA','LineStyle','-','Color','b','LineWidth',1.5)
hold on
plot(yyears,atlfluxB','LineStyle','-','Color','r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [atlfluxA+standdev_atl, fliplr(atlfluxA+standdev_atl.*(-1))];
fill(x2, inBetween, [.9 .9 .9], 'FaceAlpha',0.3);
legend('Flux estimate (SOCAT+sail)','Flux estiamte (SOCAT-sail)','FontSize',14,'Location','southwest')
hold off
%grid on
%xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xlim([1982 2021])
%