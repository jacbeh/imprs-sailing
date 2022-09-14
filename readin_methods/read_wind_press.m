% Wind speed
% https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels-monthly-means?tab=overview


addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions

%--------------------------------------------------------------------------
% Step 0: find  and open all folder in SSS (year after year)
%--------------------------------------------------------------------------

cd /Users/jacquelinebehncke/Desktop/PhD/Data/Wind

%--------------------------------------------------------------------------
% Step 1: find all gridded .nc files in the folder (month after month)
%--------------------------------------------------------------------------

D = dir('*.nc');

if ~isempty(D)

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




%% determine strength of wind vector and select relevant months (01/1970 - 12/2020)

ws = sqrt(u10.^2+v10.^2);

wind = ws(:,:,1:612);

press = sp(:,:,1:612);
% wind_dummy = reshape(wind,[],1);
% max(wind_dummy)
% min(wind_dummy)

%% regrid MLD-data from 0.25 grid 
   
longitudex=[180:0.25:359.75 0:0.25:179.75]';
[yylat,xxlon] = meshgrid(latitude,longitudex);

wind_grid = NaN(180,360,612);
press_grid = NaN(180,360,612);
lat=reshape(yylat,[],1);
lon=reshape(xxlon,[],1);



for mm = 1:612    
    count=0;
    countlat=1;    
%     wi=reshape(wind(:,:,mm),[],1);
    sp=reshape(press(:,:,mm),[],1);
    
    for uu=-90:1:89
        
        ind=find(lat>uu & lat< uu+1);
        
        if ~isempty(ind)
        
            londummy=lon(ind);
            latdummy=lat(ind);
%             wind_dummy=wi(ind);
            press_dummy=sp(ind);
            
            countlon=1;
        
            for zz=0:1:359%-180:1:179
                
                ind2=find(londummy>zz & londummy<zz+1);
                
                londummy2=londummy(ind2);
                latdummy2=latdummy(ind2);
%                 wind_dummy2=wind_dummy(ind2);
                press_dummy2=press_dummy(ind2);
                
                if ~isempty(ind2)
                    
%                     finwind=mean(wind_dummy2,'omitnan');
%     
%                     finwind=mean(finwind,'all');
%                     
%                     wind_grid(countlat,countlon,mm)=finwind;

                    finpress=mean(press_dummy2,'omitnan');
    
                    finpress=mean(finpress,'all');
                    
                    press_grid(countlat,countlon,mm)=finpress;
                    
                    count=count+1;
                    
                end
                
                countlon=countlon+1;
                
            end
            
        end
        
        countlat=countlat+1;
        
    end
    mm
end

% windspeed = wind_grid;
% windspeed = permute(windspeed, [2 1 3]);

pressure = permute(press_grid, [2 1 3]);

%% Plot

%
% close all
load coastlines;
load xlon 
load ylat
dotsize=3;

figure()
%--------------------------------------------------------------------------
    % replace "plotv" by variable name to be plotted.
    % VARIABLE HAS TO BE 2D. 
    % Here, the last index represents the month. User can change that too.
%--------------------------------------------------------------------------

for mm = 1:12%:612% 1:612                            % month by month  
    plotv=pressure(:,:,mm)'; 
    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';
%     caxis([0 10]);
    caxis([50000 100000]);
    colormap jet; 
    hold (gca,'on');
    plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');
    title(sprintf('Month %i',mm))
    pause(0.1)
    
end
hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
cbarrow
clear plotv xx yy mx mnx plotvc s hcb  map_height long  ;

%%
max(reshape(windspeed,[],1))
max(reshape(pressure,[],1))
min(reshape(pressure,[],1))

wind=windspeed;
% save('wind.mat','wind')
% save('pressure.mat','pressure')