% NORTH ATLTANTIC
mask = [0, 68.6236, -83.0081,20]; 
minlat = mask(1);
maxlat = mask(2);
minlon = mask(3);
maxlon = mask(4);

ind = find(xx >= minlon & xx <= maxlon & yy >= minlat & yy <= maxlat);

for i = 1:480
    dummy = squeeze(saildata_regrid(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
    saildata_NA(i,:,:) = dummy;
end

sum(~isnan(saildata_NA),'all')

% parameters 12x1:

for i=1:12
    monthly_countNA_12x1(i)=sum(~isnan(saildata_NA(i:12:480,:,:)),'all');
end

% SOUTHERN OCEAN
mask = [-60, -50, -179.5,179.5];
minlat = mask(1);
maxlat = mask(2);
minlon = mask(3);
maxlon = mask(4);

ind = find(xx >= minlon & xx <= maxlon & yy >= minlat & yy <= maxlat);

for i = 1:480
    dummy = squeeze(saildata_regrid(i,:,:));
    nrs = reshape(1:numel(ones(180,360)),180,360);
    indx = ~ismember(nrs, ind);            % create matrix with logical indices of Atlantic cells
    dummy(indx) = NaN;                      % all cells except Atlantic contain NaN-values now
    saildata_SO(i,:,:) = dummy;
end

sum(~isnan(saildata_SO),'all')

% parameters 12x1:

for i=1:12
    monthly_countSO_12x1(i)=sum(~isnan(saildata_SO(i:12:480,:,:)),'all');
end

% GLOBAL
% parameters 12x1:

for i=1:12
    monthly_countglobal_12x1(i)=sum(~isnan(saildata_regrid(i:12:480,:,:)),'all');
end

nr_global = monthly_countglobal_12x1-monthly_countNA_12x1-monthly_countSO_12x1;

%%
figure(1)
nrobs = [monthly_countNA_12x1',monthly_countSO_12x1',nr_global'];
mm_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
b = bar(1:12,nrobs,'stacked');
b(3).FaceColor = [.8 .8 .8];
% hold on
% bar(1:12,monthly_countglobal_12x1)
ylabel('No. of obs.')
%title('North Atlantic [0° - 70°N]')
set(gca,'FontSize',18)
xticks(1:12)
grid on
xticklabels(mm_str)
legend('North Atlantic [0° - 70°N]','Southern Ocean [-50°S - -60°S]','Global','Location','north')
