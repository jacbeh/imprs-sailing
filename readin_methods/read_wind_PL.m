clear all
% !!! I changed line 33 and l.112 and 154

%====================== add path to some tools ============================
cd /Users/jacquelinebehncke/Desktop/PhD/Codes

addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions/m_map/   % mapping tool for plots
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes_templates/mexcdf/ %% to read file info and variables in matlab
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes_templates/mexcdf/snctools/ % idem dito
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes_templates/nansuite/ % mean ignoring nan
addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions/
mm_ind = 492+12; % Peter used months from 1980-2020, I want to add 2021


%nc_dump([path file])
%nc_dump([path file2])

%%%%%%%%
for yxc=1%1:39 % years

    
cd_dir_get = ['/Users/jacquelinebehncke/Desktop/PhD/Data/Wind/'];
    %['/Users/peter/Documents/MPI/MPI-SOM-FFN/data/ERA5/ensemble-daily/']; 

startyear=yxc+1981;
endyear=yxc+1981;
year2find=startyear;
%year2find=2020;


D = dir([cd_dir_get '*.nc']);

% file=D(1).name % because I only have one wind-nc.file
file=D(yxc).name
%file=D(39).name

path=([cd_dir_get]);

%nc_dump([path file])
%nc_dump([path file2])

uwnd_temp=nc_varget([path file],'u10');
vwnd_temp=nc_varget([path file],'v10');

if ndims(uwnd_temp)>3
    
    uwnd_temp=squeeze(nanmean(uwnd_temp,2));
    vwnd_temp=squeeze(nanmean(vwnd_temp,2));
    
end

ddqq=size(uwnd_temp);


count=1;

for qq=1:4:ddqq(1)

   wind(count,:,:)=nanmean(vwnd_temp(qq:qq+3,:,:).*vwnd_temp(qq:qq+3,:,:)+uwnd_temp(qq:qq+3,:,:).*uwnd_temp(qq:qq+3,:,:));
    
   count=count+1;

end

clear uwnd_temp
clear vwnd_temp

% speed
%wind=vwnd.*vwnd+uwnd.*uwnd;
clear uwnd vwnd D file2 cd_dir_get 

count=1;


  for month=1:12  
    if year2find==2020 || year2find==2016 || year2find==2012 || year2find==2008 || year2find==2004 || year2find==2000 || year2find==1996 || year2find==1992 || year2find==1988 || year2find==1984 || year2find==1980
    day1=[31 29 31 30 31 30 31 31 30 31 30 31];      
    else
    day1=[31 28 31 30 31 30 31 31 30 31 30 31];     
    end

    wind_ave(count,:,:)=mean(wind(1:day1(month),:,:));  %mod(sum(wind(1:day1(month),:,:)),360)./numel(wind(1:day1(month)));       %mean(wind(1:day1(month),:,:));
    wind(1:day1(month),:,:)=[];
    
    count=count+1;
  end
  year2find
  size(wind)
  size(wind_ave)


%array=zeros(120,181,360);

%array(25:end,:,:)=wind_ave(37:end,:,:);
array=wind_ave;
clear wind wind_ave

if yxc==1 % yxc==40
wind1=array;
% load /Users/jacquelinebehncke/Desktop/PhD/Data/Wind/wind_PL_492.mat
% wind1=[wind_PL_492; array];
else
wind1=[wind1; array];
end
clear array count wind

%%%%%%%%%%%%
end

wind=zeros(mm_ind,361,720);
wind(:,:,:)=NaN;
wind=wind1;         %wind(25:end,:,:)=wind1; % 25 bc Jahre vor 1982 eh empty??
clear wind1


w=zeros(mm_ind,180,360);
w(:,:,:)=NaN;

lat=nc_varget('/Users/jacquelinebehncke/Desktop/PhD/Data/Wind/ERA5_wind_2021.nc','latitude');%('/Users/peter/Documents/MPI/MPI-SOM-FFN/data/ERA5/ensemble-daily/1982.nc','latitude');
lon=nc_varget('/Users/jacquelinebehncke/Desktop/PhD/Data/Wind/ERA5_wind_2021.nc','longitude');%('/Users/peter/Documents/MPI/MPI-SOM-FFN/data/ERA5/ensemble-daily/1982.nc','longitude');

lat=double(lat);
lon=double(lon);

    
    earthellipsoid = referenceSphere('earth','km');
    for tt=1:length(lat)-1
        for zz=1:length(lon)-1
            
            area(tt, zz) = areaquad(lat(tt),lon(zz),lat(tt+1),lon(zz+1),earthellipsoid);
    
        end
    end
    
    area(:,end+1)=area(:,1);
    area(end+1,:)=area(end,:);

    a1=zeros(4,180,360);
    a1(:,:,:)=NaN;
    
    a1(1,:,:)=(area(1:2:end-1,1:2:end));
    a1(2,:,:)=(area(1:2:end-1,2:2:end));
    a1(3,:,:)=(area(2:2:end,1:2:end));
    a1(4,:,:)=(area(2:2:end,2:2:end));
    
    asum(1:180,1:360)=squeeze(sum(a1,1));
    
    a1rel(1,:,:)=squeeze(a1(1,:,:))./asum;
    a1rel(2,:,:)=squeeze(a1(2,:,:))./asum;
    a1rel(3,:,:)=squeeze(a1(3,:,:))./asum;
    a1rel(4,:,:)=squeeze(a1(4,:,:))./asum;
    
    
for uu=1:12%mm_ind
   
    a=zeros(4,180,360);
    a(:,:,:)=NaN;
    
    a(1,:,:)=squeeze(wind(uu,1:2:end-1,1:2:end));
    a(2,:,:)=squeeze(wind(uu,1:2:end-1,2:2:end));
    a(3,:,:)=squeeze(wind(uu,2:2:end,1:2:end));
    a(4,:,:)=squeeze(wind(uu,2:2:end,2:2:end));
    
    %w(uu,:,:)=squeeze(nanmean(a,1));
    
    w(uu,:,:)=(squeeze(a(1,:,:)).*squeeze(a1rel(1,:,:)) + squeeze(a(2,:,:)).*squeeze(a1rel(2,:,:)) + squeeze(a(3,:,:)).*squeeze(a1rel(3,:,:)) +squeeze(a(4,:,:)).*squeeze(a1rel(4,:,:)));

    
    clear a
end

clear wind

wind=w;

clear w

wind2=flip(wind,2);

clear wind
wind=wind2;
clear wind2

 uu=size(wind);
 
 wind_ex(1:uu(1),1:uu(2),1:uu(3))=wind(:,:,:);
 wind_ex(1:uu(1),1:uu(2),uu(3)+1:2*uu(3))=wind(:,:,:);
 clear wind
 wind=wind_ex(:,:,end/4+1:end*3/4);
 clear wind_ex


lon_new=-179.5:1:179.5;
lat_new=-89.5:1:89.5;


wind2=wind;

clear wind;

wind=wind2;

save('ERA5_component_wind_v2021.mat','wind');


figure(7);clf; 
m_proj('equidistant','lon',[-180 180],'lat',[-90 90]);
h=m_pcolor(lon_new,lat_new,squeeze(nanmean(wind)));
set(h,'edgecolor','none');
colorbar('hori');caxis([0 150]);
%colormap(redblue);
m_coast('patch','w');
m_grid('xtick',[ -135 -90 -45 0 45 90 135], ...
    'ytick',[-90 -60 -30 0 30 60 90],'fontsize',10);


%% merge new-2021 data and data from before 2020

wind_dummy = nan(mm_ind,180,360);
wind_dummy(end-11:end,:,:) = wind(1:12,:,:);
load /Users/jacquelinebehncke/Desktop/PhD/Data/Wind/wind_PL_492.mat
wind_dummy(1:492,:,:) = wind_PL_492;

wind_dummy(1:24,:,:) = [];

wind = wind_dummy;
% save('wind.mat','wind')
