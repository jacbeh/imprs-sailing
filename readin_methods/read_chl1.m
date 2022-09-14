% This is an updated matlab code to load SOCAT V3-V2020 netcdf files into matlab.
% There are several gridded files available (decadal, monthly, etc.), so
% this code willl ask the user in a first step to select the desired 
% file and in a second step to pick the variables desired for the file chosen. 
% This code is based on read_SOCAT from Denis Pierrot (denis.pierrot@noaa.gov
% and has been adjusted to read gridded files 
% by Peter Landschutzer 2013-06-16 (peter.landschuetzer@usys.ethz.ch)

% clear all

%--------------------------------------------------------------------------
% Step 0: create empty matrix for storing all .nc files
%--------------------------------------------------------------------------

chl = NaN(360,180,624);

 
d = datetime('01-Jan-1970'):calmonths(1):datetime('16-Dec-2021');
d = yyyymmdd(d);
%--------------------------------------------------------------------------
% Step 1: find all gridded .nc files in the folder
%--------------------------------------------------------------------------
for mm =1:624
    D = dir(sprintf('*_%i-*.nc',d(mm)));
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
%         uiwait(fig);
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
%         uiwait(fig);
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
        
    % save .nc-file in matrix
    
    chl(:,:,mm) = CHL1_mean;

    end
end

chl = fliplr(chl);
chl = log(chl); % log transformed


%% create monthly chlorophyll climatology from 1998 - 2013 for each year before 09/1997
%  concerns months 1:332     (189wrong)
%  real chlorophyll values available from 09/1997

yyears = 1970:2021;  
yyears = repelem(yyears,1,12);

% STEP0_JB
chl = permute(chl,[3 2 1]);

% select months from whhich we create climatology (years 1998 - 2013)
ind1 = find(yyears==1998);
ind2 = find(yyears==2002);
chl_dummy = chl(ind1(1):ind2(end),:,:); % years 1998 - 2013
chl_clim = nan(12,180,360);

% ideal (mean) months: Okt - Sept
for uu=1:12 
  chl_clim(uu,:,:)=mean(chl_dummy(uu:12:end,:,:),'omitnan');
end

% chl_clim = chl_clim([4:12,1:3],:,:); % change from oct - sept to jan to dec


% add chl climatology to chl matrix
test = chl;
ind = find(yyears == 1997);
for i = 1:12:ind(end)
    test(i:i+11,:,:) = chl_clim;

end
% ind = find(yyears== 1997);
% test(ind(1):ind(9),:,:) = chl_clim(1:9,:,:);

chl = test;

%save('chl.mat','chl')


%% is there any month that does not contain chl values?

for mm = 1:624 % what months do not contain chl values? (month index)
    plotv=squeeze(chl(mm,:,:)); 
    if sum(~isnan(plotv),'all') < 1
        mm
    end
end

isequaln(chl(1,:,:),chl(13,:,:))    % does monthly climatology work?
%% Test plot
close all
runcode=1;
load coastlines;
if runcode==1
%     close all;
    dotsize=3;
   

    figure(2)
    for mm = 100:624%188%333%:612
    %replace "fco2_ave_weighted_decade" by variable name to be plotted.--------
    % VARIABLE HAS TO BE 2D. 
    %Here, the last index represents the decade. User can change that too.
    cla
    plotv=squeeze(chl(mm,:,:));
%     plotv=flipud(permute(CHL1_mean,[2 1]));
%--------------------------------------------------------------------------

    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    plotvc=plotv/mx;
%     figure
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';
%     caxis([mnx mx]);
%     caxis([mnx 1]);
    colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
    hold (gca,'on');
    plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');

    title(sprintf('Month %i',mm)) 
    pause(0.02)

%     3 dimensional plot:
%     figure
%     mesh(plotv);
%     hold (gca,'on');
% 
%     long=coastlon+180;lat=coastlat+90;
%     map_height=mean(plotv(~isnan(plotv))); % average of plotted data 
%     %plot3(long,lat,zeros(size(long,1),1)+map_height,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');
%     plot(long,lat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');   
%     colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');

    
    end
    clear xx yy mx mnx plotvc s hcb  map_height long  ;
end
hold off


%save('chl.mat','chl')

