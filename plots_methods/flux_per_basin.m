% This script: 
% - loads flux estimates and converts in PgC yr-1
% - selects fluxes in Atlantic and SO for each of the 11 runs (1xRunB, 10xRunA)
% - caluculates annual mean of these fluxes (in 480x180x360 fields and 40x1 annual means)
% - calculate standard deviation from 10 Runs (40x1) for Atlantic and SO 
% - plots flux over time for Atlantic and SO

%--------------------------------------------------------------------------
% load flux estimates and convert in Pg C yr-1
%--------------------------------------------------------------------------

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load flux_socatv2022_1.mat
flux1 = flux_est;
load flux_socatv2022_2.mat
flux2 = flux_est;
load flux_socatv2022_3.mat
flux3 = flux_est;
load flux_socatv2022_4.mat
flux4 = flux_est;
load flux_socatv2022_5.mat
flux5 = flux_est;
load flux_socatv2022_6.mat
flux6 = flux_est;
load flux_socatv2022_7.mat
flux7 = flux_est;
load flux_socatv2022_8.mat
flux8 = flux_est;
load flux_socatv2022_9.mat
flux9 = flux_est;
load flux_socatv2022_11.mat
flux11 = flux_est;
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunB
load flux_socatv2022-sail.mat
fluxB = flux_est;

cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021
load area.mat
oc_area = area;   
clear area
yyears = repelem(1982:2021,1,12);

cd /Users/jacquelinebehncke/Desktop/PhD/Codes

%--------------------------------------------------------------------------
% flux conversion from mol C yr-1 m-2 in Pg C yr-1
%--------------------------------------------------------------------------
for i = 1:480
    flux1_PgC(i,:,:) = squeeze(flux1(i,:,:)).*oc_area.*12.*10^-15; % mol C yr-1 m-2 flux multiplied by area, atomic mass and Peta to convert in Pg C yr-1
    flux2_PgC(i,:,:) = squeeze(flux2(i,:,:)).*oc_area.*12.*10^-15;
    flux3_PgC(i,:,:) = squeeze(flux3(i,:,:)).*oc_area.*12.*10^-15;
    flux4_PgC(i,:,:) = squeeze(flux4(i,:,:)).*oc_area.*12.*10^-15;
    flux5_PgC(i,:,:) = squeeze(flux5(i,:,:)).*oc_area.*12.*10^-15;
    flux6_PgC(i,:,:) = squeeze(flux6(i,:,:)).*oc_area.*12.*10^-15;
    flux7_PgC(i,:,:) = squeeze(flux7(i,:,:)).*oc_area.*12.*10^-15;
    flux8_PgC(i,:,:) = squeeze(flux8(i,:,:)).*oc_area.*12.*10^-15;
    flux9_PgC(i,:,:) = squeeze(flux9(i,:,:)).*oc_area.*12.*10^-15;
    flux11_PgC(i,:,:) = squeeze(flux11(i,:,:)).*oc_area.*12.*10^-15;
    fluxB_PgC(i,:,:) = squeeze(fluxB(i,:,:)).*oc_area.*12.*10^-15;
end

clear flux2 flux3 flux4 flux5 flux6 flux7 flux8 flux9 flux11

%--------------------------------------------------------------------------
% calculate mean fluxA (out of 10 fluxA's)
%--------------------------------------------------------------------------
% for i = 1:size(flux1,1)
%     i
%     for j = 1:size(flux1,2)
%         for k =1:size(flux1,3) 
%             val = [flux1_PgC(i,j,k),flux2_PgC(i,j,k),flux3_PgC(i,j,k),...
%                 flux4_PgC(i,j,k),flux5_PgC(i,j,k),flux6_PgC(i,j,k),flux7_PgC(i,j,k),...
%                 flux8_PgC(i,j,k),flux9_PgC(i,j,k),flux11_PgC(i,j,k)];
%             fluxA_PgC(i,j,k) = mean(val,'omitnan');
%         end
%     end
% end
cd /Users/jacquelinebehncke/Desktop/PhD/Codes/v2021/output/flux/RunA
load fluxA_PgC
cd /Users/jacquelinebehncke/Desktop/PhD/Codes
%--------------------------------------------------------------------------
% select fluxes in Atlantic and SO for each of the 11 runs (1xRunB, 10xRunA)
%--------------------------------------------------------------------------

atlantic_fluxB = select_Atlantic(fluxB_PgC);
southern_fluxB = select_SO(fluxB_PgC);
front_fluxB = select_front(fluxB_PgC);

atlantic_fluxA = select_Atlantic(fluxA_PgC);
southern_fluxA = select_SO(fluxA_PgC);
front_fluxA = select_front(fluxA_PgC);


atlantic_flux_A1  = select_Atlantic(flux1_PgC);
southernflux_A1  = select_SO(flux1_PgC);
front_fluxA1 = select_front(flux1_PgC);


atlantic_flux_A2  = select_Atlantic(flux2_PgC);
southernflux_A2  = select_SO(flux2_PgC);
front_fluxA2 = select_front(flux2_PgC);


atlantic_flux_A3  = select_Atlantic(flux3_PgC);
southernflux_A3  = select_SO(flux3_PgC);
front_fluxA3 = select_front(flux3_PgC);


atlantic_flux_A4  = select_Atlantic(flux4_PgC);
southernflux_A4  = select_SO(flux4_PgC);
front_fluxA4 = select_front(flux4_PgC);


atlantic_flux_A5  = select_Atlantic(flux5_PgC);
southernflux_A5  = select_SO(flux5_PgC);
front_fluxA5 = select_front(flux5_PgC);


atlantic_flux_A6  = select_Atlantic(flux6_PgC);
southernflux_A6  = select_SO(flux6_PgC);
front_fluxA6 = select_front(flux6_PgC);


atlantic_flux_A7  = select_Atlantic(flux7_PgC);
southernflux_A7  = select_SO(flux7_PgC);
front_fluxA7 = select_front(flux7_PgC);


atlantic_flux_A8  = select_Atlantic(flux8_PgC);
southernflux_A8  = select_SO(flux8_PgC);
front_fluxA8 = select_front(flux8_PgC);


atlantic_flux_A9  = select_Atlantic(flux9_PgC);
southernflux_A9  = select_SO(flux9_PgC);
front_fluxA9 = select_front(flux9_PgC);


atlantic_flux_A11  = select_Atlantic(flux11_PgC);
southernflux_A11  = select_SO(flux11_PgC);
front_fluxA11 = select_front(flux11_PgC);

%%
%--------------------------------------------------------------------------
% caluculate annual mean (in 480x180x360 fields and 40x1 annual means)
%--------------------------------------------------------------------------

[atlantic_flux_B_3dim,atlantic_flux_B] = annual_flux_mean(atlantic_fluxB);
[southern_flux_B_3dim,southern_flux_B]= annual_flux_mean(southern_fluxB);
[atlantic_flux_A_3dim,atlantic_flux_A] = annual_flux_mean(atlantic_fluxA);
[southern_flux_A_3dim,southern_flux_A]= annual_flux_mean(southern_fluxA);
[~,front_flux_A]= annual_flux_mean(front_fluxA);
[~,front_flux_B]= annual_flux_mean(front_fluxB);


[atlantic_flux_A1_3dim,atlantic_flux_A1]  = annual_flux_mean(atlantic_flux_A1);
[atlantic_flux_A2_3dim,atlantic_flux_A2]  = annual_flux_mean(atlantic_flux_A2);
[atlantic_flux_A3_3dim,atlantic_flux_A3]  = annual_flux_mean(atlantic_flux_A3);
[atlantic_flux_A4_3dim,atlantic_flux_A4]  = annual_flux_mean(atlantic_flux_A4);
[atlantic_flux_A5_3dim,atlantic_flux_A5]  = annual_flux_mean(atlantic_flux_A5);
[atlantic_flux_A6_3dim,atlantic_flux_A6]  = annual_flux_mean(atlantic_flux_A6);
[atlantic_flux_A7_3dim,atlantic_flux_A7]  = annual_flux_mean(atlantic_flux_A7);
[atlantic_flux_A8_3dim,atlantic_flux_A8]  = annual_flux_mean(atlantic_flux_A8);
[atlantic_flux_A9_3dim,atlantic_flux_A9]  = annual_flux_mean(atlantic_flux_A9);
[atlantic_flux_A11_3dim,atlantic_flux_A11]  = annual_flux_mean(atlantic_flux_A11);

[southernflux_A1_3dim,southernflux_A1]  = annual_flux_mean(southernflux_A1);
[southernflux_A2_3dim,southernflux_A2]  = annual_flux_mean(southernflux_A2);
[southernflux_A3_3dim,southernflux_A3]  = annual_flux_mean(southernflux_A3);
[southernflux_A4_3dim,southernflux_A4]  = annual_flux_mean(southernflux_A4);
[southernflux_A5_3dim,southernflux_A5]  = annual_flux_mean(southernflux_A5);
[southernflux_A6_3dim,southernflux_A6]  = annual_flux_mean(southernflux_A6);
[southernflux_A7_3dim,southernflux_A7]  = annual_flux_mean(southernflux_A7);
[southernflux_A8_3dim,southernflux_A8]  = annual_flux_mean(southernflux_A8);
[southernflux_A9_3dim,southernflux_A9]  = annual_flux_mean(southernflux_A9);
[southernflux_A11_3dim,southernflux_A11]  = annual_flux_mean(southernflux_A11);

[~,front_flux_A1]  = annual_flux_mean(front_fluxA1);
[~,front_flux_A2]  = annual_flux_mean(front_fluxA2);
[~,front_flux_A3]  = annual_flux_mean(front_fluxA3);
[~,front_flux_A4]  = annual_flux_mean(front_fluxA4);
[~,front_flux_A5]  = annual_flux_mean(front_fluxA5);
[~,front_flux_A6]  = annual_flux_mean(front_fluxA6);
[~,front_flux_A7]  = annual_flux_mean(front_fluxA7);
[~,front_flux_A8]  = annual_flux_mean(front_fluxA8);
[~,front_flux_A9]  = annual_flux_mean(front_fluxA9);
[~,front_flux_A11]  = annual_flux_mean(front_fluxA11);
%%
%--------------------------------------------------------------------------
% calculate standard deviation from 10 Runs (40x1) 
% for Atlantic and SO 
%--------------------------------------------------------------------------

standdev_atl = nan(1,40);
standdev_SO = nan(1,40);
standdev_front = nan(1,40);


for i=1:size(unique(yyears),2)
    val_atl = [atlantic_flux_A1(i),atlantic_flux_A2(i),atlantic_flux_A3(i),...
        atlantic_flux_A4(i),atlantic_flux_A5(i),atlantic_flux_A6(i),...
        atlantic_flux_A7(i),atlantic_flux_A8(i),atlantic_flux_A9(i),atlantic_flux_A11(i)];
    val_SO = [southernflux_A1(i),southernflux_A2(i),southernflux_A3(i),...
        southernflux_A4(i),southernflux_A5(i),southernflux_A6(i),...
        southernflux_A7(i),southernflux_A8(i),southernflux_A9(i),southernflux_A11(i)];
    val_front = [front_flux_A1(i),front_flux_A2(i),front_flux_A3(i),...
        front_flux_A4(i),front_flux_A5(i),front_flux_A6(i),...
        front_flux_A7(i),front_flux_A8(i),front_flux_A9(i),front_flux_A11(i)];
    standdev_atl(i)= std(val_atl);
    standdev_SO(i)= std(val_SO);
    standdev_front(i)= std(val_front);
end
%%
% check if code above works also for mean_atl and mean SO (is it the same
% as atlantic_fluxA and ...?)
val_atl = [atlantic_flux_A1',atlantic_flux_A2',atlantic_flux_A3',...
        atlantic_flux_A4',atlantic_flux_A5',atlantic_flux_A6',...
        atlantic_flux_A7',atlantic_flux_A8',atlantic_flux_A9',atlantic_flux_A11']';
mean_atl = mean(val_atl);
% yes, it is exactly the same as atlantic_flux_A

%--------------------------------------------------------------------------
% plots flux over time for Atlantic and SO
%--------------------------------------------------------------------------
yyears = 1982:2021;

figure()
plot(yyears,atlantic_flux_A','LineStyle','-.','Color','b','LineWidth',1.5)
hold on
plot(yyears,atlantic_flux_B','LineStyle','-.','Color','r','LineWidth',1.5)
plot(yyears,southern_flux_A','LineStyle','--','Color','b','LineWidth',1.5)
plot(yyears,southern_flux_B','LineStyle','--','Color','r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [atlantic_flux_A+standdev_atl, fliplr(atlantic_flux_A+standdev_atl.*(-1))];
fill(x2, inBetween, [.9 .9 .9], 'FaceAlpha',0.5);
x2 = [yyears, fliplr(yyears)];
inBetween = [southern_flux_A+standdev_SO, fliplr(southern_flux_A+standdev_SO.*(-1))];
fill(x2, inBetween, [.9 .9 .9], 'FaceAlpha',0.5);
legend('Atlantic Ocean (SOCAT+sail)','Atlantic Ocean (SOCAT-sail)',...
    'Southern Ocean (SOCAT+sail)','Southern Ocean (SOCAT-sail)','FontSize',14,'Location','southwest')
hold off
grid on
%xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xlim([1982 2021])
ylim([-0.85 0.003])
% ylim([-0.15 -0.025])
yticks(fliplr([0 -0.25 -.5 -.75]))


a = mean(southern_flux_A);
b = mean(southern_flux_B);
mean(standdev_SO)
diff([a,b])

a = mean(atlantic_flux_A);
b = mean(atlantic_flux_B);
mean(standdev_atl)
diff([a,b])

mean(fluxA_PgC)

%% plot Front

figure()
plot(yyears,front_flux_A','LineStyle','-','Color','b','LineWidth',1.5)
hold on
plot(yyears,front_flux_B','LineStyle','-','Color','r','LineWidth',1.5)
x2 = [yyears, fliplr(yyears)];
inBetween = [front_flux_A+standdev_front, fliplr(front_flux_A+standdev_front.*(-1))];
fill(x2, inBetween, [.9 .9 .9], 'FaceAlpha',0.3);
legend('Southern Ocean (SOCAT+sail)','Southern Ocean (SOCAT-sail)','FontSize',14,'Location','southwest')
hold off
%grid on
%xlabel('Time [Year]')
ylabel('Carbon flux [Pg C yr^{-1}]')
set(gca,'FontSize',18)
xlim([1982 2021])
% ylim([-0.85 0.003])
yticks(fliplr([.1 0 -0.1 -0.2 -.3]))
title('50°S - 60°S')

sum(front_flux_A)
sum(standdev_front)
sum(front_flux_B)

