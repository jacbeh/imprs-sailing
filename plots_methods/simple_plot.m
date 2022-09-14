load coastlines.mat
load area.mat
dotsize=3;
figure(2)


%for mm = 1:612
    plotv = test2(:,:);


    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';
    caxis([-5 5]);
    colormap redblue(9000); hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
    hold (gca,'on');
    plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');

%     title(sprintf('Month %i',mm))
    title('Flux estimate')
    pause(0.05)
    
%end
    clear plotv xx yy mx mnx plotvc s hcb  map_height long  ;

