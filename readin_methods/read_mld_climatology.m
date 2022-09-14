%% Import monthly MLD-climatology
% https://cerweb.ifremer.fr/deboyer/mld/Surface_Mixed_Layer_Depth.php

% !!! is not correct, use Peters mld below !!!!

%% Import 2° x 2° mld climatology

close all
clear all
clc
addpath /Users/jacquelinebehncke/Desktop/PhD/Data/MLD
load xlon
load ylat

mld_clim = NaN(180,90,12);
%--------------------------------------------------------------------------
% Step 1: find all gridded .nc files in the folder
%--------------------------------------------------------------------------
    D = dir('*.nc');
    if ~isempty(D)
    
    %D = dir('*.nc');
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
        
        dflt=[3,4]; % default ticks
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
    
        %--------------------------------------------------------------------------
        % move lon-coordinates by 180° (data seem to have an offset by 180°?)
        %--------------------------------------------------------------------------            
        mld_dummy = mld;
        klon = repmat(1:180,1,3);
        klon(1:90) = [];
        for k= 1:180
            mld(k,:,:) = mld_dummy(klon(k),:,:);
        end

        %--------------------------------------------------------------------------
        % save .nc-file in matrix
        %--------------------------------------------------------------------------
        
        mld_clim(:,:,:) = mld;

    end

%save('chl.mat','chl')

%% regridding and interpolation 


[xx,yy] = meshgrid(xlon,ylat);                  % new mesh
lat_grid=lat';
lon_grid=lon';
lon_grid = lon_grid-180;
[xxt,yyt] = ndgrid(lon_grid,lat_grid);          % original grid
%mld_grid = permute(pco2_grid,[2 1 3]);

% mld_clim = permute(mld_clim,[2 1 3]);

mld = NaN(180,360,12);

for mm = 1:12
    F = griddedInterpolant(xxt,yyt,squeeze(mld_clim(:,:,mm)));      % create interpolation
    [Xq,Yq] = ndgrid(-179.5:1:179.5,-89.5:1:89.5);     % define grid with finer resolution
    

    Vq = F(Xq,Yq);
    % plot original and finer resolution
    figure()   
    pcolor(Xq,Yq,Vq); title(sprintf('Finer resolution - Month %i',mm))
    colorbar
%     caxis([280 480])
    figure()
    pcolor(xxt,yyt,squeeze(mld_clim(:,:,mm))); title(sprintf('Original resolution - Month %i',mm))
    colorbar
%     caxis([280 480])

% Vq = inpaintn(Vq);

    figure(3)
    pcolor(xx,yy,permute(Vq, [2 1])); title(sprintf('Final (finer) resolution - Month %i',mm))
    colormap jet
    colorbar 
%     caxis([280 480])

    mld(:,:,mm) = permute(Vq, [2 1]);

    
end

%% change 1.0000e+09 in NaNs

for i = 1:180
    for j = 1:360
        for k = 1:12
            if mld(i,j,k) >= 2000 || mld(i,j,k) <= 0
                mld(i,j,k) = NaN;
            end
        end
    end
end


%% Test plot


dotsize=3;
load coastlines.mat

for mm = 1:12
    
    figure()
    plotv = mld(:,:,mm);
    %plotv = squeeze(mld(mm,:,:)); % Peters mld
    
        [xx,yy] = meshgrid(xlon,ylat);
        mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
        s=pcolor(xx,yy,plotv); title(sprintf('Month %i',mm))
        s.EdgeColor='none';
%         caxis([mnx mx]);
%         caxis([15 500])
        colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
        hold (gca,'on');
        plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');
end
  
    clear plotv mx mnx plotvc s ;

%% one year for all months
mld_dummy = mld;

for i = 1:12:624
    mld(:,:,i:i+11) = mld_dummy(:,:,1:12);
end

mld_clim = permute(mld,[2 1 3]);

save('mld_clim.mat','mld_clim')





%% Peters mld

load('training_data/mld/mld_clim_v2021.mat');

mld(493:624,:,:) = mld(1:132,:,:);

mld_clim = mld;
save('mld_clim.mat','mld_clim')


