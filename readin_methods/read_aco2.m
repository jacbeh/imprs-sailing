% read atmospheric xCO2 data
load xlon
aCO2 = readtable("xCO2_without_header.txt",VariableNamingRule="preserve");


years = repelem(1979:2020,1,12)'; 

dates = array2table(NaT(2017,1));
for i = 1:size(aCO2,1)
    jul = ConvertSerialYearToDate( aCO2.Var1(i));
    dates{i,1} = datetime(jul,'convertfrom','datenum');
end

% each column = 1 of 41 latitudes
% convert latitude from sinus degree in degree

degr = [-1.00  -0.95  -0.90  -0.85  -0.80  -0.75  -0.70  -0.65  -0.60  -0.55  -0.50  -0.45  -0.40  -0.35  -0.30  -0.25  -0.20  -0.15  -0.10  -0.05   0.00   0.05   0.10   0.15   0.20   0.25   0.30   0.35   0.40   0.45   0.50   0.55   0.60   0.65   0.70   0.75   0.80   0.85   0.90   0.95   1.00];
degr = asind(degr);

% restructuring table into 3-dim matrix

aco2_matr = NaN(41,360,2017);       % 3-dim = lat, lon, time

for r = 1:size(aCO2,1)              % r = index for time in table and matrix
    c2 = 0;                         % c2 = index for latitude in matrix 
    for c = 2:2:size(aCO2,2)-1      % c = index for lat in table
        c2 = c2+1;
        aco2_matr(c2,:,r) = aCO2{r,c};
    end
end

% test = aco2_matr(:,1,:);
% test=permute(test,[1 3 2]);
clear c c2 r jul i aCO2

%% interpolate in space (and average month)
% average months, interpolate in space
yyt = degr';                         % original ylat coordinates
aco2_matr = permute(aco2_matr, [2 1 3]);
xxt = xlon';

% calculate monthly means out of the given days (not interpolated ->
% problem?)
aco2_monthly = NaN(360,41,504);
i = 0;
n=0;
for y = 1979:2021
    for m = 1:12
        i = i + 1;
        mm = month(dates{:,1});
        yy = year(dates{:,1});
        % find index of specific month of specific year
        ind = find(yy == y & mm == m);
%         n= n + size(ind);
%         sprintf('%d %d %d',m,y,n)
        
        current_month=mean(aco2_matr(:,:,ind),3); % mean of specific month (out of 5 days, not interpolated)
        aco2_monthly(:,:,i) = current_month;
    end
end
aco2_monthly(:,:,505:end) = [];
% test = aco2_monthly(:,:,1);
% test = aco2_monthly(:,:,504);


% interpolate space
F=griddedInterpolant({xlon,yyt,1:504},aco2_monthly);
  qlon=(-179.5:179.5);
  qlat=(-89.5:1:89.5);
aco2_final=F({qlon',qlat',1:504});
% test2 = aco2_final(:,:,1);  

% test
% F=griddedInterpolant({xlon,degr',aCO2.Var1},aco2_matr);
%   qlon=(-179.5:179.5);
%   qlat=(-89.5:1:89.5);
%   qtime=(year);
% aco2_final=F({qlon',qlat',qtime});


%% Test plots

[xxt,yyt] = meshgrid(xxt,yyt);
aco2_matr = permute(aco2_matr, [2 1 3]);

% plot original data
figure(1)   
pcolor(xxt,yyt,aco2_matr(:,:,1));
title('Original data - first timestep')
colorbar

figure(2)
pcolor(xxt,yyt,aco2_matr(:,:,2017));
title('Original data - last timestep')
colorbar

% plot interpolated data with new resolution
figure(3)
[xxq,yyq] = ndgrid(qlon,qlat);                    % new mesh
for t = 1:504
    pcolor(xxq,yyq,aco2_final(:,:,t));
    colorbar
%     caxis([334 420])
    title('Atmospheric xCO_2 from 1979 - 2021 (interpolated)')
    subtitle(sprintf('Month %d',t))
    pause(0.2)
end
% cbarrow


%% find indices of years, where no aco2 data are available


mm = month(dates{:,1});
yy = year(dates{:,1});

% socat time period
socat_period = repelem(1970:2020,1,12)'; 
aco2_period = repelem(1979:2020,1,12)'; 

[val, ind] = setdiff(socat_period,aco2_period);

% ind = strfind(socat_period', aco2_period') + 0:length(aco2_period')-1;

% indices of missing years in aco2
miss = socat_period(ismember(socat_period, val));

% aco2_final = permute(aco2_final,[3 2 1]);
aco2dummy = aco2_final;
aco2_final(:,:,1:size(miss,1)) = NaN;
aco2_final(:,:,size(miss,1)+1:end+size(miss,1)) = aco2dummy;

aco2 = aco2_final;
% save('aco2.mat','aco2')

%% final visual test (month 1:108 have to be empty)

aco2_test = aco2;

% [xxq,yyq] = meshgrid(xlon,ylat);
% aco2_test = permute(atm_co2, [3 2 1]);

% plot interpolated data with new resolution
figure(3)
[xxq,yyq] = ndgrid(qlon,qlat);                    % new mesh

for t = 1:109
    pcolor(xxq,yyq,aco2_test(:,:,t));
    colorbar
%     caxis([334 420])
    title('Atmospheric xCO_2 from 1979 - 2021 (interpolated)')
    subtitle(sprintf('Month %d',t))
    pause(0.2)
end


%% add data for 2021 (not yet available)

%  but global growth rate data are available, solution: add data from
%  previous year and month plus growth rate in (ppm)
%  https://gml.noaa.gov/ccgg/trends/gl_gr.html: 
%  global growth rate 2021: 2.54 ppm

load aco2.mat

for mm = size(aco2,3)+1:size(aco2,3)+12
    aco2(:,:,mm) = aco2(:,:,mm-12) + 2.54;
end

