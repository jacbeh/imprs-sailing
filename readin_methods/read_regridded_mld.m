%%--------------------------------------------------------------------------
%% 2) import mld
%--------------------------------------------------------------------------
% addpath MLD_0.5grid

%--------------------------------------------------------------------------
% Step 0: create empty matrix for storing all .nc files
%--------------------------------------------------------------------------

mld = NaN(360,180,612);

%%
d = datetime('01-Jan-1970'):calmonths(1):datetime('16-Dec-2020');
d = num2str(yyyymmdd(d));
dvec = split(d,'  ');

k = 0;
for i = 1:10:length(d)
    k = k + 1;
    dvec{k,1} = sprintf('%s-%s',d(i:(3+i)),d((4+i):(5+i)));% in 10er Schritten
end


%--------------------------------------------------------------------------
% Step 1: find all gridded .nc files in the folder
%--------------------------------------------------------------------------
for mm = 1:612
    D = dir(sprintf('*_%s_*.nc',dvec{mm}));
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
        if i<=20    
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
           % regrid MLD-data from 0.25 grid 
%--------------------------------------------------------------------------
    
            
            MLD_grid=NaN(180,360);
            
            [yylat,xxlon] = meshgrid(latitude,longitude);
            lat = yylat;
            lon = xxlon;
            
            count=0;
                    
            
            countlat=1;
            
            for uu=-90:1:89
                
                ind=find(lat>uu & lat< uu+1);
                
                if ~isempty(ind)
                
                    londummy=lon(ind);
                    latdummy=lat(ind);
                    MLDdummy=MXLDEPTH(ind);
                    
                    countlon=1;
                
                    for zz=-180:1:179
                        
                        ind2=find(londummy>zz & londummy<zz+1);
                        
                        londummy2=londummy(ind2);
                        latdummy2=latdummy(ind2);
                        MLDdummy2=MLDdummy(ind2);
                        
                        if ~isempty(ind2)
                            
                            finMLD=mean(MLDdummy2,'omitnan');
            
                            finMLD=mean(finMLD,'all');
                            
                            MLD_grid(countlat,countlon)=finMLD;
                            
                            count=count+1;
                            
                        end
                        
                        countlon=countlon+1;
                        
                    end
                    
                end
                
                countlat=countlat+1;
                
            end
    MLD_grid = permute(MLD_grid,[2 1]);
    mld(:,:,mm) = MLD_grid;
    end
end

%%

% check: are there data in mld?
sum(~isnan(mld),'all') % if not zero, then yes

%save('mld.mat','mld')

%% Test Plot
 load coastlines;

 dotsize=3;
   

    figure(3)
    for mm = 261:612
    %replace "fco2_ave_weighted_decade" by variable name to be plotted.--------
    % VARIABLE HAS TO BE 2D. 
    %Here, the last index represents the decade. User can change that too.
    plotv=mld(:,:,mm)';  

%--------------------------------------------------------------------------

    [xx,yy] = meshgrid(xlon,ylat);
    mx=max(max(plotv));mnx=min(min(plotv));    %plotvc=plotv/mx;
    s=pcolor(xx,yy,plotv);
    s.EdgeColor='none';
%     caxis([mnx mx]);
%     caxis([0 300]);
    colormap jet; hcb=colorbar; set(hcb,'location','eastoutside','yaxislocation','right');
    hold (gca,'on');
    plot(coastlon,coastlat,'Parent',gca, 'Marker','none', 'MarkerSize',dotsize, 'MarkerEdgeColor','b', 'MarkerFaceColor','none','LineStyle','-');

    title(sprintf('Month %i',mm))
    pause(.05)
    
    end
    clear plotv xx yy mx mnx plotvc s hcb  map_height long  ;
