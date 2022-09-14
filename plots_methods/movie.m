%% Plot gridded data - all years

fig = figure('units','normalized','outerposition',[0 0 1 1]);

dotsize=2;
years = 1970:2021;
fco2 = fco2_ave_weighted_year;

% last index represents the time/year/month. User can change that too.
% loop through time/year/month
for i = 1:size(fco2,3) 
    plotv=fco2(:,:,i)';  

%     % delelete unrealistic values
%     for c = 1:size(plotv,2)
%         for r = 1:size(plotv,1)
%             if plotv(r,c) > 460
%                plotv(r,c) = NaN;
%             elseif plotv(r,c) < 260
%                plotv(r,c) = NaN;
%             end
%         end
%     end

    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
    
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';

    colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
    caxis([250 450])
    hcb.Title.String = "fCO_2 [μatm]";
    hold (gca,'on');
    
    coast = load('coastlines.mat');
    mapshow(coast.coastlon, coast.coastlat, 'DisplayType','polygon','FaceColor',[.8 .8 .8]);
   
    ylabel('Latitude')
    xlabel('Longitude')
    title(sprintf('Surface water fCO_2 in %i',years(i)))
%     title(sprintf('Surface water fCO_2 in 1970 - %i',years(i)))
    ylim([-90 90])
    xlim([-180 180])
    hold off
%      % Write each frame to the file.
%        vidObj(i) = getframe(fig);
%        
end

