%% calculate flux difference

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load flux_biome_socat
flux_withsail = flux_est;

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load flux_biome_socat-sail
flux_withoutsail = flux_est;

diff = flux_withsail - flux_withoutsail;

%% World flux (FINAL)
% creates video-file, if vid = 1

vid = 0;
close all
m_str = {'January','February','March','April','May','June','July',...
    'August','September','October','November','December'};
m_str = repmat(m_str,1,51);
yyears = 1982:2021;  
yyears = repelem(yyears,1,12);

load coastlines.mat
load xlon 
load ylat 
[xx,yy] = meshgrid(xlon,ylat);
load saildata_regrid
saildata_regrid(1:144,:,:) = [];

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/plots

fig = figure('units','normalized','outerposition',[0 0 .7 .8]);

if vid == 1                         % video-file
    set(gcf,'color','w');
    writerObj = VideoWriter('Flux difference_worldmap.mp4','MPEG-4');
    writerObj.FrameRate = 1.5;
    writerObj.Quality = 40;
    open(writerObj);
end

k = 0;
for mm = 1:480  
    k = k + 1;                      % frame-number for video-file

    cla

    % Plot flux difference
    plotv=squeeze(diff(mm,:,:));
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';

    % Plot Route
    hold (gca,'on');
    mapshow(coastlon, coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8])
    route=saildata_regrid(mm,:,:);
    xxr = xx(~isnan(route));
    yyr = yy(~isnan(route));
    scatter(xxr,yyr,20,'k','filled')
    hold off

    % Plot Labelling etc.
    title({'Difference in air-sea CO_2 flux due to sailing data',...
        sprintf('%i %s',yyears(mm),m_str{mm})});
    xlabel('Longitude')
    ylabel('Latitude')
    set(gca,'FontSize',14)
    cbar = colorbar;
    colormap(redblue)
    caxis([-5 5])
    box on
%     cbarrow
    ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',16)

    pause(0.1)

    if vid == 1
        vidObj(k) = getframe(fig);  % video-file
    end

end
clear xx yy s cbar  xxr yyr mm  

if vid == 1                         % video-file
    writeVideo(writerObj,vidObj)
    close(writerObj)
end

%% Flux Plot Southern Ocean all years with route (FINAL)
% creates video-file, if vid = 1;

vid = 0;
close all
load xlon
load ylat
load saildata
load saildata_regrid
m_str = {'January','February','March','April','May','June','July',...
    'August','September','October','November','December'};
m_str = repmat(m_str,1,52);
yyears = 1982:2021;  
yyears = repelem(yyears,1,12);
saildata_regrid(1:144,:,:) = [];
[xx,yy] = meshgrid(xlon,ylat);


if vid == 1                         % video-file
    set(gcf,'color','w');
    writerObj = VideoWriter('Flux difference_worldmap_southern_ocean.mp4','MPEG-4');
    writerObj.FrameRate = 1.5;
    writerObj.Quality = 40;
    open(writerObj);
end

fig = figure('units','normalized','outerposition',[0 0 1 1]);
set(gca,'Position',get(gca,'Position')*0.95)
set(gca,'FontSize',14)
cbar = colorbar('eastoutside');
cbar.Position = cbar.Position + [.05 0 0 0];
colormap(redblue)
cbarrow
caxis([-3 3])

k = 0;
for mm = 468
    k = k + 1;                 % frame-number for video-file
    cla
    title({'Difference in air-sea CO_2 flux due to sailing data',...
        sprintf('%i %s',yyears(mm),m_str{mm})}, 'Position', [0, 1.3, 0]);
    m_proj('stereographic','lat',-90,'long',10,'radius',60); %radisu 50 für -60°S bis -40°S
    m_coast('patch',[.7 .7 .7],'HandleVisibility','off');      %,'edgecolor','none'
    m_grid('tickdir','out','xtick',12,'linest','-','backcolor',...
        [0.9    0.9    .9],'XAxisLocation','top','Fontsize',14);
    hold on
%     s = m_pcolor(xx, yy,squeeze(diff(mm,:,:)));
    s = m_pcolor(xx, yy,squeeze(diff(mm,:,:)));

    s.EdgeColor='none';
%     [cs,h]=m_contour(xx,yy,squeeze(diff(mm,:,:)),'LineColor','k');
%     clabel(cs,h,'fontsize',8);
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
    ylabel(cbar, '[mol C m^{-2} yr^{-1}]','Interpreter','tex','FontSize',16)
    hold off
    pause(0.5)

    if vid == 1
        vidObj(k) = getframe(fig);  % video-file
    end

end

clear xx yy s cbar  xxr yyr mm  

if vid == 1                         % video-file
    writeVideo(writerObj,vidObj)
    close(writerObj)
end

%% Are there any NaN in input data e.g. in aco2?

% for mm = 1:468
%     if sum(isnan(atm_co2(mm,:,:)),'all') > 0 % if there are any NaN, display line 
%         mm 
%     end
% end
