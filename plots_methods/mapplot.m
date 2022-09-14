
%     % delelete unrealistic values
%     for c = 1:size(plotv,2)
%         for r = 1:size(plotv,1)
%             if plotv(r,c) > 460 || plotv(r,c) <260
%                plotv(r,c) = NaN;
%             end
%         end
%     end

    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
    
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';

    colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
    hold (gca,'on');
    
    coast = load('coastlines.mat');
    mapshow(coast.coastlon, coast.coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8]);
    hold on
    ylabel('Latitude')
    xlabel('Longitude')
    title('Surface water fCO_2 [μatm]')
    ylim([-90 90])
    xlim([-180 180])