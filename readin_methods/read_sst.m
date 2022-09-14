%--------------------------------------------------------------------------
% 1) import sst
%--------------------------------------------------------------------------

close all
clear all
clc
load xlon
load ylat

cd /Users/jacquelinebehncke/Desktop/PhD/Data/SST
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
        % move lon-coordinates by 180° (data seem to have an offset by
        % 180°?) &latcoord
        %--------------------------------------------------------------------------  
        
        sst_dummy = sst;
        klon = repmat(1:360,1,3);
        klon(1:180) = [];
        for k= 1:360
            sst(k,:,:) = sst_dummy(klon(k),:,:);
        end
        sst = fliplr(sst);
       
    end
%% correct format

d_sail = (datetime('01-Jan-1970'):calmonths(1):datetime('16-Dec-2021'));
d_sst = (datetime('01-Dec-1981'):calmonths(1):datetime('01-Mar-2022'));


ind1 = ismember(d_sail,d_sst); % indices of months where I do not need to fill in NaN
ind2 = ismember(d_sst,d_sail); %  indices of months in sst, that I need / no extra months at the end 

dummy = NaN(360,180,624);
dummy(:,:,ind1) = sst(:,:,ind2);

sst = dummy;
%%
% check
sum(~isnan(sst(:,:,143))) % zero bc no values
sum(~isnan(sst(:,:,624))) % 360 bc values

%save('sst.mat','sst')
sst = permute(sst,[2 1 3]);


%% Test Plot
load coastlines.mat
 dotsize=3;
   

    figure(3)
    for mm = 1:10%612
    %replace "fco2_ave_weighted_decade" by variable name to be plotted.--------
    % VARIABLE HAS TO BE 2D. 
    %Here, the last index represents the decade. User can change that too.
%     plotv=MLD_grid(:,:,1)';  
    plotv = sst(:,:,mm);
%--------------------------------------------------------------------------

    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';
%     caxis([mnx mx]);
    caxis([0 33]);
    colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
    hold (gca,'on');
    plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');

    title(sprintf('Month %i',mm))
    pause(0.05)
    
    end
    clear plotv xx yy mx mnx plotvc s hcb  map_height long  ;


%% Comparison with Peters SST (same!!:-) )

sst_JB = sst;
% sst_JB = permute(sst_JB,[2 3 1]);

load('training_data/sst/sst_v2021.mat');

sst_PL = sst;
sst_PL = permute(sst_PL,[2 3 1]);

