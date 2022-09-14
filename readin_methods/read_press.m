% Pressure
% https://psl.noaa.gov/data/gridded/data.ncep.reanalysis.html

addpath /Users/jacquelinebehncke/Desktop/PhD/Codes/Functions

%--------------------------------------------------------------------------
% Step 0: find  and open all folder in Pressure (year after year)
%--------------------------------------------------------------------------

cd /Users/jacquelinebehncke/Desktop/PhD/Data/Pressure

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

slp = fliplr(slp);


%% Temporal and spatial coverage

% 1948/01/01 to 2022/07/17
% 2.5 degree x 2.5 degree global grids (144x73)
% 0.0E to 357.5E, 90.0N to 90.0S

cd /Users/jacquelinebehncke/Desktop/PhD/Codes
load xlon 
load ylat

yyears = 1948:2022;  
yyears = repelem(yyears,1,12);
yyears(end-5:end) = [];

%--------------------------------------------------------------------------
% regridding and interpolation 
%--------------------------------------------------------------------------

[xx,yy] = meshgrid(xlon,ylat);                  % new mesh
lat_grid=-90:2.5:90;
lon_grid=0:2.5:357.5;
lon_grid = lon_grid-180;
% lon_grid = [180:2.5:359 0:2.5:179];
[xxt,yyt] = ndgrid(lon_grid,lat_grid);          % original mesh

press = NaN(180,360,12);

ind1 = find(yyears== 1970);
ind2 = find(yyears== 2021);

% ind1 = find(yyears== 2020);
% ind2 = find(yyears== 2020);

k = 0;
for mm = ind1(1):ind2(end)
    k = k + 1;
    slpm = slp([73:144 1:72],:,mm);                        % shift from 0:360 to -180-180 [180:2.5:359 0:2.5:179
    F = griddedInterpolant(xxt,yyt,slpm(:,:));             % create interpolation
    [Xq,Yq] = ndgrid(-179.5:1:179.5,-89.5:1:89.5);         % define grid with finer resolution


    Vq = F(Xq,Yq);
    % Plot original resolution
%     figure()
%     pcolor(xxt,yyt,slpm); title(sprintf('Original resolution - Month %i',mm))
%     colormap jet
%     colorbar
%     caxis([980 1040])


    Vq = inpaintn(Vq);
    % Plot finer resolution
%     figure()
%     pcolor(xx,yy,permute(Vq, [2 1])); title(sprintf('Final (finer) resolution - Month %i',mm))
%     colormap jet
%     colorbar 
%     caxis([980 1040])

    press(:,:,k) = permute(Vq, [2 1]);

    
end

pressure = press;
%save('pressure.mat','pressure')


%% visual test: compare with Peters pressure data 
%  should be the same
 
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/training_data/pressure/
load pres_v2021
load coastlines.mat
m_str = {'January','February','March','April','May','June','July',...
    'August','September','October','November','December'};
m_str = repmat(m_str,1,51);

figure()
for mm = 492
    plotv=squeeze(pressure(mm,:,:)); 

    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';
    caxis([980 1040]);
    colormap jet; 
    hold (gca,'on');
    plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',3, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');
    hold off
    title(sprintf('Month %i - %s',mm, m_str{mm}))
    pause(0.3)
end
cbarrow
clear xx yy mx mnx plotvc s hcb  map_height long  ;

