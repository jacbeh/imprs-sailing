%% Documentation: 
% This script 
% (A) plots fronts (Park and Durand fronts) in the Southern Ocean (SO)
% as well as the sailing route, 
% selects a front (usually -50°S - -60°S) in SO and 
% (B) plots the frontflux on a global map and 
% (C) plots the flux within the front over time


%--------------------------------------------------------------------------
%% (A1) load park and durand fronts (nc-file)
%--------------------------------------------------------------------------
% https://www.seanoe.org/data/00486/59800/
% Park Young-Hyang, Durand Isabelle (2019). Altimetry-drived Antarctic Circumpolar Current fronts. SEANOE. https://doi.org/10.17882/59800
% In addition to properly cite this dataset, it would be appreciated that the following work(s) be cited too, when using this dataset in a publication :
% Park Y.‐H., Park T., Kim T.‐W., Lee S.‐H., Hong C.‐S., Lee J.‐H., Rio M.‐H., Pujol M.‐I., Ballarotta M., Durand I., Provost C. (2019). Observations of the Antarctic Circumpolar Current over the Udintsev Fracture Zone, the narrowest choke point in the Southern Ocean. Journal of Geophysical Research: Oceans, -. https://doi.org/10.1029/2019JC015024

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/MATLAB_Data
%--------------------------------------------------------------------------
% Step 1: find all gridded .nc files in the folder (month after month)
%--------------------------------------------------------------------------

D = dir(('*.nc'));

if ~isempty(D)

%D = dir('*.nc');
%--------------------------------------------------------------------------
% Step 2: user selects the file desired
%--------------------------------------------------------------------------

    for tt=1:length(D) % CHECK FOR ALL FILES IN THE SAME FOLDER
    hdrs{tt}=D(tt,1).name; % Store the filenames
    end
    % open window to select the desired file to load
    [scrsz]=get(0,'ScreenSize');   ht=150;wd=600;
    fig = figure('position', [(scrsz(3)-wd)/2 (scrsz(4)-ht)/2 wd ht]);
    set(gcf,'color',[0.95 0.95 0.95]);
    uicontrol ('Style','text','position', [150 120 200 20],'String','Select file to read');
    %set(gcf,'color','w');
    uicontrol ('Style','text','position', [20 100 500 20],'String','(Warning: Coastal arrays are large and will use a lot of memory to be imported)');
    % check all filenames in the folder and display them as list objects in
    % the dropdown menu of the window
    if length(D)>=1
        for i=1:length(D) 
            if i==1
                strings=hdrs{i};
            else
                strings=[strings '|' hdrs{i}];
            end
        end
    else
        strings='no netCDF file available. Please press OK and read Command Window text in MATLAB'; % if there is no netCDF file
    end
    c = uicontrol ('Style','popupmenu','position', [20 40 500 50],'String',strings);

    % create OK and Cancel button
    okb=uicontrol ('Style','togglebutton','position', [(wd-50) 20 30 20],'String','OK','Callback','uiresume(gcbf)');
    ccb=uicontrol ('Style','togglebutton','position', [(wd-100) 20 40 20],'String','Cancel','Callback','close all');
    uiwait(fig);
    set(fig,'visible','off');
    
    % check which file has been selected and use its name for further steps
    if length(D)>=1
    bv=get(c,'Value');
    file_2_use = D(bv,1).name;

%--------------------------------------------------------------------------
% Step 3: load the data from desired file
%--------------------------------------------------------------------------

    % check the content of the file (names, units, attributes, etc.)
    file=ncinfo(file_2_use);
    
    dflt=[5]; % default ticks
    % get the varible names from the file to be displayed in window
    for tt=1:length(file.Variables)
    hdrs{tt}=file.Variables(1,tt).Name;
    end
    % open 2nd window with all variables from the file. User can chose as
    % many as desired to load
    [scrsz]=get(0,'ScreenSize');   ht=400;wd=700;
    fig = figure('position', [(scrsz(3)-wd)/2 (scrsz(4)-ht)/2 wd ht]);cols=[50 300 550];spc=30;ctrln=10;
    set(gcf,'color',[0.95 0.95 0.95]);
    uicontrol ('Style','text','position', [(wd-200)/2 ht-30 200 20],'String','Select Variables to Import');
    % display variables with check boxes
    for i=1:length(file.Variables)    
    if i<=20;    
        c(i) = uicontrol ('Style','checkbox','position', [cols((i>ctrln)+1) ht-50-spc*i+(ctrln*spc*(i>ctrln)) 50+length(char(hdrs{i}))*10 50],'String',hdrs{i});
    elseif i>20
        c(i) = uicontrol ('Style','checkbox','position', [cols((i>ctrln)+2) ht-50-spc*i+(ctrln*spc*((i>ctrln)+1)) 50+length(char(hdrs{i}))*10 50],'String',hdrs{i});
    end
    set(c(i),'Value',ismember(i,dflt));
    end
    
    % create OK and Cancel button
    okb=uicontrol ('Style','togglebutton','position', [(wd-50) 20 30 20],'String','OK','Callback','uiresume(gcbf)');
    ccb=uicontrol ('Style','togglebutton','position', [(wd-100) 20 40 20],'String','Cancel','Callback','close all');
    uiwait(fig);
    set(fig,'visible','off');
    
%--------------------------------------------------------------------------
% Step 4: load the checked data and assign the correct name to it
%--------------------------------------------------------------------------

    disp('All DONE! Array(s)')% are in your workspace');

    for i=1:length(file.Variables),bv(i)=get(c(i),'Value');
    
        if bv(i)==1
        data_in = ncread(file_2_use,file.Variables(1,i).Name);
        eval([char(file.Variables(1,i).Name) '=data_in;']);
        disp(['"' char(file.Variables(1,i).Name) '"']);
        end
    end
        if sum(bv)>0
            disp(['from "' file_2_use '"']);
            disp('imported into your workspace'); 
        else
            disp('are NOT imported in your workspace') 
            disp('=> no array was selected')
            disp('Please run again and select variable(s) to import')
        end
    else
        disp('There are no gridded SOCAT netCDF files in your current folder.')
        disp('Please follow the steps below:')
        disp('1) Download a gridded netCDF file from socat.info => Data Download')
        disp('   => Gridded files from CDIAC SOCAT V3.')  
        disp('2) Download 1 or more netCDF file(s) into the same folder as this file and run again.')
        disp('3) Select the file in the first window then press OK.')
        disp('4) Select the variable(s) you want to import in the second window and press OK.')
    end
    
    clear D data_in c bv i tt file file_name okb ccb cols ctrln dflt fig
    clear file_2_use ht scrsz spc wd hdrs strings
    

end


%--------------------------------------------------------------------------
%% (A2) Plot park and durand fronts and sailing route
%--------------------------------------------------------------------------

load xlon 
load ylat 
[xx,yy] = meshgrid(xlon,ylat);
load saildata_regrid
saildata_regrid(1:144,:,:) = [];

cols = [255/255 128/255 0;
    255/255 102/255 102/255;
    0 102/255 204/255];
figure(1)
clf
title({'Difference in air-sea CO_2 2021 flux due to sailing data'}, 'Position', [0, 1.3, 0]);
m_proj('stereographic','lat',-90,'long',10,'radius',60); %radisu 50 für -60°S bis -40°S
m_coast('patch',[.7 .7 .7],'HandleVisibility','off');      %,'edgecolor','none'
m_grid('tickdir','out','xtick',12,'linest','-','backcolor',...
    [0.8510    0.9412    1.0000],'XAxisLocation','top','Fontsize',14);
hold on

 % Plot hatched pattern for positive differences
pltv=squeeze(sst(480,:,:));
% m_plot(LonSB,LatSB,'LineWidth',3)%,'Color',cols(1,:))
m_plot(LonNB,LatNB,'LineWidth',3)%,'Color',cols(1,:))
m_plot(LonSAF,LatSAF,'LineWidth',3)%,'Color',cols(3,:))
m_plot(LonPF,LatPF,'LineWidth',3)%,'Color',cols(1,:))
m_plot(LonSACCF,LatSACCF,'LineWidth',3)%,'Color',cols(2,:))
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
    m_scatter(xxr,yyr,15,'k','filled')
end

title('Park-Durand-Fronts in Southern Ocean')
set(gca,'FontSize',18)
lon_bound = ([0:0.001:180, -180:0.001:0])';
lat_bound = repelem(50,size(lon_bound,1),1);
% m_plot(lon_bound,lat_bound,'LineWidth',3)
legend('','','','','','','','','Northern Boundary (NB)','Subantarctic Front (SAF)','Polar Front (PF)','Southern ACC Front (sACCF)','Vendée Globe sailing route')

% s = m_pcolor(xx, yy,pltv);
% s.EdgeColor='none';
% [cs,h]=m_contour(xx,yy,pltv,[0.6 6.9],'LineColor','r','LineWidth',1.5);
% [cs,h]=m_contour(xx,yy,pltv,[0.6 6.9],'LineColor','r','LineWidth',1.5);
% % h.LevelList = round(h.LevelList,2);
% % clabel(cs,h,'fontsize',10);
hold off

%--------------------------------------------------------------------------
%% (B) Plot frontflux
%--------------------------------------------------------------------------

frontflux = select_front(flux_diff_field);
frontflux = squeeze(mean(frontflux,'omitnan'));

figure(1)
clf
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',14)
%pltv = squeeze(front_fluxB(1,:,:));
pltv = (frontflux);
hold on
s=pcolor(xx,yy,pltv);
s.EdgeColor='none';
cbar = colorbar;
colormap(redblue) 
caxis([0 0.5])
% caxis([-5*10^-4 5*10^-4 ])
cbarrow('up')
box on
mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
% % Plot Route
for i = 433:480
    xxr = xx(~isnan(saildata_regrid(i,:,:)));
    yyr = yy(~isnan(saildata_regrid(i,:,:)));
    scatter(xxr,yyr,5,'k','filled')
end
% % Plot Labelling etc.
% xlabel('Longitude')
% ylabel('Latitude')
xticks([])
yticks([])
set(gca,'FontSize',18)
ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',20)
hold off

%--------------------------------------------------------------------------
%% (C) plots flux over time: front
%--------------------------------------------------------------------------
 
% C1: clips front in SO
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

% C2: plots flux over time: front
yyears = 1982:2021;

figure(1)
plot(yyears,frontfluxA','LineStyle','-','Color','b','LineWidth',1.5)
hold on
plot(yyears,frontfluxB','LineStyle','-','Color','r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [frontfluxA+standdev_front, fliplr(frontfluxA+standdev_front.*(-1))];
fill(x2, inBetween, [.9 .9 .9], 'FaceAlpha',0.3);
legend('Flux estimate (SOCAT+sail)','Flux estimate (SOCAT-sail)','FontSize',14,'Location','southwest')
hold off
%grid on
%xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xlim([1982 2021])
