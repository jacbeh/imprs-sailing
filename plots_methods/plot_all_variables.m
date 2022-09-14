%% JB: Interactive Plot
% to plot: SOCAT and saildata see also summary_plots
% option "...": test plot, just add whatever you want to visually check

% clear
clc

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/MATLAB_Data

%============== control parameter =========================================

% select variable2plot
dflt=1;
hdrs{1}='SST';hdrs{2}='MLD';hdrs{3}='SSS';hdrs{4}='Takahashi Climatology';...
    hdrs{5}='Chl-a';hdrs{6}='atm. CO2';hdrs{7}='Pressure';hdrs{8}='Sea Ice';...
    hdrs{9}='Wind';hdrs{10}='SOCAT';hdrs{11}='Sailing Data';...
    hdrs{12}='A) Flux (SOCAT)';hdrs{13}='B) Flux (SOCAT - Sailing Data)';...
    hdrs{14}='Flux difference';hdrs{15}='...';
[scrsz]=get(0,'ScreenSize');   ht=700;wd=600;
fig = figure('position', [(scrsz(3)-wd)/2 (scrsz(4)-ht)/2 wd ht]);cols=[50 300];spc=50;ctrln=13;
uicontrol ('Style','text','position', [(wd-200)/2 ht-20 200 20],'String','Select Variable to Import');

for i=1:15
    c(i) = uicontrol ('Style','radiobutton','position', [cols((i>ctrln)+1) ht-50-spc*i+(ctrln*spc*(i>ctrln)) 50+length(char(hdrs{i}))*10 50],'String',hdrs{i});
    set(c(i),'Value',ismember(i,dflt));
end
uicontrol ('Style','togglebutton','position', [(wd-50) 20 30 20],'String','OK','Callback','uiresume(gcbf)');
uicontrol ('Style','togglebutton','position', [(wd-100) 20 40 20],'String','Cancel','Callback','uiresume(gcbf)');
uiwait(fig);
set(fig,'visible','off');
clear cols ctrln dflt ht scrsz spc

prompt={'vid','first_month2plot','last_month2plot'};
% defans={'sst sss mld chl aco2 pco2taka pressure seaice wind socat saildata fluxA fluxB',...
%     'on or off','1','480'};
defans={'off','460','480'};
fields = {'vid','first_month2plot','last_month2plot'};
info = inputdlg(prompt, 'please enter plot settings', 1, defans);
if ~isempty(info)                                   %see if user hit cancel
   info = cell2struct(info,fields);                 %convert string to number
%    variable2plot   = info.variable2plot;
   vid   = info.vid;
   first_month2plot   = info.first_month2plot;
   last_month2plot   = info.last_month2plot;
end
clear prompt defans fields info

i = 1;  
while c(i).Value == 0  
    i = i + 1;
end
variable2plot = char(hdrs{i});
% clear hdrs c

if(strcmp(variable2plot,'SST')==1)
    load sst
    plotv = sst;
    cxmin = 0;
    cxmax = 30;
    unit = '[°C]';
elseif (strcmp(variable2plot,'SSS')==1)
    load sss
    plotv = sss;
    cxmin = 32;
    cxmax = 38;
    unit = '[PSU]';
elseif (strcmp(variable2plot,'MLD')==1)
    load mld
    plotv = mld;
    cxmin = 2;
    cxmax = 6;
    unit = 'log(MLD) [m]';
elseif (strcmp(variable2plot,'Takahashi Climatology')==1)
    load pco2_taka
    plotv = pco2_taka;
    cxmin = 280;
    cxmax = 400;
    unit = '[μatm]';
elseif (strcmp(variable2plot,'Chl-a')==1)
    load chl
    plotv = chl;
    cxmin = -4.5;
    cxmax = 3;
    unit = 'log(Chl-a) [mg m^{-3}]';
elseif (strcmp(variable2plot,'atm. CO2')==1)
    load aco2
    plotv = aco2;
    cxmin = 330;
    cxmax = 420;
    unit = '[μmol mol^{-1}]';
elseif (strcmp(variable2plot,'Pressure')==1)
    load pressure
    plotv = pressure;
    cxmin = 950;
    cxmax = 1060;
    unit = '[hPa]';
elseif (strcmp(variable2plot,'Sea Ice')==1)
    load seaice
    plotv = seaice*100;
    cxmin = 0;
    cxmax = 100;
    unit = '[%]';
elseif (strcmp(variable2plot,'Wind')==1)
    load wind
    plotv = wind;
    cxmin = 0;
    cxmax = 150;
    unit = '[m s^{-1}]';
elseif (strcmp(variable2plot,'SOCAT')==1)
    load socat
    plotv = socat;
    cxmin = 280;
    cxmax = 540;
    unit = '[μatm]';
elseif (strcmp(variable2plot,'Sailing Data')==1)
    load saildata_regrid
    plotv = saildata_regrid;
    cxmin = 280;
    cxmax = 540;
    unit = '[μatm]';
elseif (strcmp(variable2plot,'A) Flux (SOCAT)')==1)
    cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
    load flux_socatv2022_1
    plotv = flux_est;
    cxmin = -5;
    cxmax = 5;
    unit = '[mol C m^{-2} yr^{-1}]';
elseif (strcmp(variable2plot,'B) Flux (SOCAT - Sailing Data)')==1)
    cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
    load flux_socatv2022-sail
    plotv = flux_est;
    cxmin = -5;
    cxmax = 5;
    unit = '[mol C m^{-2} yr^{-1}]';
elseif (strcmp(variable2plot,'Flux difference')==1)
    cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
    load flux_biome_socat
    fluxA = flux_est;
    cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
    load flux_biome_socat-sail
    fluxB = flux_est;
    plotv = fluxA-fluxB;
    cxmin = -5;
    cxmax = 5;
    unit = '[mol C m^{-2} yr^{-1}]';
else
    plotv = biomes;
%     cxmin = 1;
%     cxmax = 16;
    unit = '';
end

mm_ind = 480;
mm_start = 1982;
mm_end = 2021;

% if plotv contains 624 months and not 480 months
y = mm_start:mm_end;  
y = repelem(y,1,12);
c = 624-length(y);
if size(plotv,1) == 624
    plotv(1:c,:,:) = [];
end
clear y c

%============== load plot relevant parameter ==============================

close all
m_str = {'January','February','March','April','May','June','July',...
    'August','September','October','November','December'};
m_str = repmat(m_str,1,52);

yyears = 1982:2021;  
yyears = repelem(yyears,1,12);

load coastlines.mat
load xlon 
load ylat 
[xx,yy] = meshgrid(xlon,ylat);

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/plots

%============== plot ==============================

fig = figure('units','normalized','outerposition',[0 0 .7 .8]);

if (strcmp(vid,'on')==1)               % video-file
    set(gcf,'color','w');
    writerObj = VideoWriter(sprintf('%s.mp4',char(hdrs{i})),'MPEG-4');
    writerObj.FrameRate = 1.5;
    writerObj.Quality = 40;
    open(writerObj);
end

k = 0;
for mm = str2double(first_month2plot):str2double(last_month2plot) 
    k = k + 1;                      % frame-number for video-file
%     cla
    clf
    % Plot variable2plot
    pltv=squeeze(plotv(mm,:,:));
    s=pcolor(xx,yy,pltv);
    s.EdgeColor='none';

    hold (gca,'on');
    % if there are NaN, then plot not only contour of continents but filled polygons
    if sum(isnan(reshape(plotv,[],1))) > 0 
        mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
    else
        plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',3, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-','LineWidth',1);
    end
    hold off
%     % Plot Route
%     route=saildata_regrid(:,:,mm)';
%     xxr = xx(~isnan(route));
%     yyr = yy(~isnan(route));
%     scatter(xxr,yyr,20,'k','filled')

    % Plot Labelling etc.
    title(sprintf('%s ',char(hdrs{i})))
    subtitle(sprintf('%i %s',yyears(mm),m_str{mm}));
    xlabel('Longitude')
    ylabel('Latitude')
    set(gca,'FontSize',14)
    box on
    if i == 12 
        colormap(redblue)       % flux in colormap red white blue
        title('Flux estimate based on SOCAT')
        subtitle(sprintf('%i %s',yyears(mm),m_str{mm}))
    elseif i == 13
        colormap(redblue)       % flux in colormap red white blue
        title('Flux estimate based on SOCAT without sailing data')
        subtitle(sprintf('%i %s',yyears(mm),m_str{mm}))
    elseif i == 14
        colormap(redblue)       % flux in colormap red white blue
    else
        colormap jet
    end

    cbar = colorbar;
    if i < 15
        caxis([cxmin cxmax])
    end
    h = cbarrow;
    ylabel(cbar, sprintf('%s',unit),'Interpreter','tex','FontSize',16)
    pause(0.1)

    if (strcmp(vid,'on')==1)
        vidObj(k) = getframe(fig);  % video-file
    end

end
clear xx yy s cbar  xxr yyr mm  

if (strcmp(vid,'on')==1)              % video-file
    writeVideo(writerObj,vidObj)
    close(writerObj)
end