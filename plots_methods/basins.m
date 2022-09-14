% Contribution of each basin-Plots
%--------------------------------------------------------------------------
% this scripts creates several plots: 
%  - basins boundaries,
%  - Time series of the annual mean and globally integrated air-sea CO2
%    flux and contribution of each basin,
%  - Hovmöller plots of the zonally integrated air-sea flux

clear
close all
clc
%--------------------------------------------------------------------------
% load flux data
%--------------------------------------------------------------------------
load coastlines
load xlon
load ylat
[xx,yy] = meshgrid(xlon,ylat);

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load fluxA_PgC
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load fluxB_PgC
% 
% %--------------------------------------------------------------------------
% % calculate area of each grid cell
% %--------------------------------------------------------------------------
% 
% % addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions/cdt/
% % oc_area = cdtarea(yy,xx);                               % area of each grid cell
% % sum(oc_area,'all')                                      % ocean surface are in m2
% cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021
% load area.mat
% oc_area = area;                                           % area of each grid cell
% sum(oc_area,'all')                                        % ocean surface are in m2
% clear area
% 
% % flux conversion in
% % Pg C yr-1 from mol C yr-1 m-2
% for i = 1:480
%     fluxA_PgC(i,:,:) = squeeze(fluxA(i,:,:)).*oc_area.*12.*10^-15; % mol C yr-1 m-2 flux (dummy) multiplied by area, atomic mass and Peta to convert in Pg C yr-1
%     fluxB_PgC(i,:,:) = squeeze(fluxB(i,:,:)).*oc_area.*12.*10^-15;
% end

%--------------------------------------------------------------------------
% a) Pacific 
%   https://www.marineregions.org/gazetteer.php?p=details&id=1903
%--------------------------------------------------------------------------

pacificflux = NaN(480,180,360);
minlata = -44;                              % see Landschützer et al., 2016
maxlata = 58.2165;
minlona1 = -180;
maxlona1 = -67.25;
minlona2 = 128.6931;
maxlona2 = 180;

ind1 = find(xx >= minlona1 & xx <= maxlona1 & yy >= minlata & yy <= maxlata);
ind2 = find(xx >= minlona2 & xx <= maxlona2 & yy >= minlata & yy <= maxlata);
inda = union(ind1,ind2);                    % all Pacific Ocean grid cells/coordinates

% figure()
for i = 1:480
    dummy = squeeze(fluxA_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, inda);            % create matrix with logical indices of Pacific cells
    dummy(indx) = NaN;                      % all cells except Pacific contain NaN-values now
%     A_dummy = cdtarea(yy,xx);               % area of each grid cell
%     A_dummy(indx) = NaN;                    % area of only Pacific ocean
%     pcolor(xx,yy,dummy);                  % test plot
%     pause(0.2)
    pacificflux(i,:,:) = dummy;
end

% figure()                                  % visual check
% for i=1:10
%     s=pcolor(xx,yy,squeeze(pacificflux(i,:,:)));
%     s.EdgeColor='none';
%     colorbar
%     caxis([-5 5])
%     pause(0.1)
% end

%--------------------------------------------------------------------------
% b) Atlantic 
%   https://www.marineregions.org/gazetteer.php?p=details&id=1902
%--------------------------------------------------------------------------

atlanticflux = NaN(480,180,360);
minlatb = -44;                              % see Landschützer et al., 2016
maxlatb = 68.6236;
minlonb = -83.0081;
maxlonb = 20;
indb = find(xx >= minlonb & xx <= maxlonb & yy >= minlatb & yy <= maxlatb);

for i = 1:480
    dummy = squeeze(fluxA_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, indb);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
%     pcolor(xx,yy,dummy); % test plot
%     pause(0.2)
    atlanticflux(i,:,:) = dummy; 
end

%--------------------------------------------------------------------------
% c) Indian 
%   https://www.marineregions.org/gazetteer.php?p=details&id=1904
%--------------------------------------------------------------------------

indianflux = NaN(480,180,360);
minlatc = -44;                              % see Landschützer et al., 2016
maxlatc = 31.1859;
minlonc = 20.0026;
maxlonc = 146.8982;
indc = find(xx >= minlonc & xx <= maxlonc & yy >= minlatc & yy <= maxlatc);

% figure()
for i = 1:480
    dummy = squeeze(fluxA_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, indc);            % create matrix with logical indices of Indian cells
    dummy(indx) = NaN;                      % all cells except Indian contain NaN-values now
%     pcolor(xx,yy,dummy); % test plot
%     pause(0.2)
    indianflux(i,:,:) =  dummy;
end

%--------------------------------------------------------------------------
% d) Southern Ocean
%   https://www.marineregions.org/gazetteer.php?p=details&id=1907
%--------------------------------------------------------------------------

southernflux = NaN(480,180,360);
minlatd = -85.5625;
maxlatd = -44;                              % see Landschützer et al., 2016
minlond = -180;
maxlond = 180;
indd = find(xx >= minlond & xx <= maxlond & yy >= minlatd & yy <= maxlatd);

% figure()
for i = 1:480
    dummy = squeeze(fluxA_PgC(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, indd);            % create matrix with logical indices of SO cells
    dummy(indx) = NaN;                      % all cells except SO contain NaN-values now
%     pcolor(xx,yy,dummy); % test plot
%     pause(0.2)
    southernflux(i,:,:) =  dummy;
end

%--------------------------------------------------------------------------
% Plot basin boundaries
%--------------------------------------------------------------------------

figure('units','normalized','outerposition',[0 0 1 1]);
clf
ylim([-90 90])
xlim([-180 180])
ax = gca;
mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
hold on
x = [minlona1 maxlona1 maxlona1 minlona1]; % Modify x coordinates of the polygon 
y = [minlata minlata maxlata maxlata]; % Modify y coordinates of the polygon
patch(ax, x, y,[0    0.4470    0.7410],'FaceAlpha',.2); % Modify patch color and transparency 
x = [minlona2 maxlona2 maxlona2 minlona2]; % Modify x coordinates of the polygon 
y = [minlata minlata maxlata maxlata]; % Modify y coordinates of the polygon
patch(ax, x, y,[0    0.4470    0.7410],'FaceAlpha',.2); % Modify patch color and transparency 

% add Atlantic patch
x = [minlonb maxlonb maxlonb minlonb]; % Modify x coordinates of the polygon 
y = [minlatb minlatb maxlatb maxlatb]; % Modify y coordinates of the polygon
patch(ax, x, y,[0.8500    0.3250    0.0980],'FaceAlpha',.2); % Modify patch color and transparency 

% add Indian patch
x = [minlonc maxlonc maxlonc minlonc]; % Modify x coordinates of the polygon 
y = [minlatc minlatc maxlatc maxlatc]; % Modify y coordinates of the polygon
patch(ax, x, y,[0.9290    0.6940    0.1250],'FaceAlpha',.2); % Modify patch color and transparency 

% add Southern Ocean patch
x = [minlond maxlond maxlond minlond]; % Modify x coordinates of the polygon 
y = [minlatd minlatd maxlatd maxlatd]; % Modify y coordinates of the polygon
patch(ax, x, y,[0.4940    0.1840    0.5560],'FaceAlpha',.2); % Modify patch color and transparency 

% labeling
title('Ocean basins')
xlabel('Longitude')
ylabel('Latitude')
set(gca,'FontSize',16)
box on
legend('','','Pacific Ocean','Atlantic Ocean','Indian Ocean','Southern Ocean','Location','southwest') 

% add front and sail route
xxr_sail = NaN;
yyr_sail = NaN;
for i = 433:480
    xxr = xx(~isnan(saildata_regrid(i,:,:)));
    yyr = yy(~isnan(saildata_regrid(i,:,:)));
    if ~isempty(xxr)
        xx_new = xxr;
        yy_new = yyr;
        xxr_sail = vertcat(xxr_sail, xx_new);
        yyr_sail = vertcat(yyr_sail, yy_new);
    end
end
scatter(xxr_sail,yyr_sail,15,'k','filled')

% add Southern Ocean patch
x = [minlond maxlond maxlond minlond]; % Modify x coordinates of the polygon 
y = [minlatd minlatd maxlatd maxlatd]; % Modify y coordinates of the polygon
patch(ax, x, y,[0.4940    0.1840    0.5560],'FaceAlpha',.2); % Modify patch color and transparency 

hold off

%--------------------------------------------------------------------------
% caluculate annual mean
%--------------------------------------------------------------------------
yyears = repelem(1982:2021,1,12);

count=1;
for i=1:12:length(yyears)
    % parameters in 40 (years) x 180 (lat) x 360 (lon)
    pacific_annual_mean(count,:,:)=mean(pacificflux(i:i+11,:,:),'omitnan');
    atlantic_annual_mean(count,:,:)=mean(atlanticflux(i:i+11,:,:),'omitnan');
    indian_annual_mean(count,:,:)=mean(indianflux(i:i+11,:,:),'omitnan');
    southern_annual_mean(count,:,:)=mean(southernflux(i:i+11,:,:),'omitnan');
    count=count+1;
end

for i=1:size(unique(yyears),2)
    % parameters 40x1
    pac_mean(i)=sum(reshape(squeeze(pacific_annual_mean(i,:,:)),[],1),'omitnan');
    atl_mean(i)=sum(reshape(squeeze(atlantic_annual_mean(i,:,:)),[],1),'omitnan');
    ind_mean(i)=sum(reshape(squeeze(indian_annual_mean(i,:,:)),[],1),'omitnan');
    so_mean(i)=sum(reshape(squeeze(southern_annual_mean(i,:,:)),[],1),'omitnan');
end
all_flux = pac_mean+atl_mean+ind_mean+so_mean;

yyears = 1982:2021;

%----------------------------------------------------------------------------------------------------------------------------------------------------------
% Time series of the annual mean and globally integrated air-sea CO2 flux from 1982 to 2021 based on the SOM-FFN output and the contributions of each basin 
%-----------------------------------------------------------------------------------------------------------------------------------------------------------

figure()
hold on
y = [so_mean',ind_mean',atl_mean',pac_mean'];
y = fliplr(y);
% y = (y./sum(y,2));
area(yyears,y,'LineWidth',1.5);
plot(yyears, all_flux,'k','LineWidth',1.8)
hold off
lgnd = {'Southern Ocean','Indian Ocean','Atlantic Ocean','Pacific Ocean'};
lgnd = fliplr(lgnd);
legend(lgnd,'Location','southwest')
xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',14)
% ylim([-3 0])
xlim([1982 2021])

%% 
%--------------------------------------------------------------------------
% Hovmöller plots of the zonally integrated air-sea flux
%--------------------------------------------------------------------------

% create new matrices to plot hovmöller-plots (480-time x 180-lat)
[yyy,aaa] = meshgrid(ylat,repelem(1982:2021,1,12));
pac_lon = NaN(480,180);
atl_lon = NaN(480,180);
ind_lon = NaN(480,180);
so_lon = NaN(480,180);

% calculate flux over longitude
for k = 1:480
    for i = 1:180
        pac_lon(k,i) = sum(pacificflux(k,i,:),'omitnan');
        atl_lon(k,i) = sum(atlanticflux(k,i,:),'omitnan');
        ind_lon(k,i) = sum(indianflux(k,i,:),'omitnan');
        so_lon(k,i) = sum(southernflux(k,i,:),'omitnan');
    end
end

% a) Pacific Hovmoeller Plot

figure('units','normalized','outerposition',[0 0 1 .5]);
s = pcolor(aaa,yyy,pac_lon);
s.EdgeColor = 'none';
hold on
% contour(aaa,yyy,pac,'LineColor','k');
hold off
cbar = colorbar;
colormap(redblue)
cbarrow
ylabel('Latitude °N')
% xlabel('Time [Year]')
title('(a) Pacific Ocean')
set(gca,'FontSize',16)
ylim([-43.5 58.5])
xticks([1985 1990 1995 2000 2005 2010 2015 2020])
box on
caxis([-0.03 0.03])
unit = 'Pg C yr^{-1}';
ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)

% b) Atlantic Hovmoeller Plot

figure('units','normalized','outerposition',[0 0 1 .5]);
s = pcolor(aaa,yyy,atl_lon);
s.EdgeColor = 'none';
cbar = colorbar;
colormap(redblue)
cbarrow
ylabel('Latitude °N')
title('(b) Atlantic Ocean')
set(gca,'FontSize',16)
ylim([-43.5 69.5])
xticks([1985 1990 1995 2000 2005 2010 2015 2020])
box on
caxis([-0.03 0.03])
ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)

% c) Indian Hovmoeller Plot

figure('units','normalized','outerposition',[0 0 1 .5]);
s = pcolor(aaa,yyy,ind_lon);
s.EdgeColor = 'none';
cbar = colorbar;
colormap(redblue)
cbarrow
ylabel('Latitude °N')
title('(c) Indian Ocean')
set(gca,'FontSize',16)
ylim([-43.5 31.5])
xticks([1985 1990 1995 2000 2005 2010 2015 2020])
box on
caxis([-0.03 0.03])
ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)

% d) Southern Ocean Hovmoeller Plot

figure('units','normalized','outerposition',[0 0 1 .5]);
s = pcolor(aaa,yyy,so_lon);
s.EdgeColor = 'none';
cbar = colorbar;
colormap(redblue)
cbarrow
ylabel('Latitude °N')
title('(d) Southern Ocean')
set(gca,'FontSize',16)
ylim([-77.5 -43.5])
xticks([1985 1990 1995 2000 2005 2010 2015 2020])
box on
caxis([-0.03 0.03])
ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)

