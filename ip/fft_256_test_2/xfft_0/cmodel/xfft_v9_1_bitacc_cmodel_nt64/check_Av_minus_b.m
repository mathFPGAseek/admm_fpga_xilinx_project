%--------------------------------------------------------------------------
% file: check_Av_minus_.m
% engr: rbd
% date : 3/30/23
% descr: Av minus b check of matlab versus Vivado
%--------------------------------------------------------------------------
% Generate Av from Matlab simulation
check_A_ifft_2d;
if exist('PreImage','var')
    disp(' Generate MAT file for Av');
    save('Av.mat','PreImage'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end


debug = 1;

% load b ( equivalent) matlab sim
load('Av.mat'); % Named PreImage
rescale_Av; %refactor
load('H.mat');  % equivalent to b
rename_to_b;

clearvars -except Av b; % cleanup of workspace


% load hdl sim
load('Av_minus_b_fr_viv_sim.mat');
Av_minus_b_hdl_sim = complex_image_array;
debug = 1;


%Calculate Av-b
index  = size(Av,1); %symmetrical matrix
for j = 1 : index
    for i = 1 : index
        Av_minus_b_mat_sim(i,j) = Av(i,j)-b(i,j);
    end
end

debug = 1; 


%Compare
% compare mag
AvMinusbMatSimMag  = abs(Av_minus_b_mat_sim);
AvMinusbHdlSimMag  = abs(Av_minus_b_hdl_sim);
clearvars -except AvMinusbMatSimMag AvMinusbHdlSimMag ...
                  Av_minus_b_mat_sim Av_minus_b_hdl_sim

debug = 1; 

%
%{
figure(1);
diff = AvMinusbMatSimMag  - AvMinusbHdlSimMag ;
surf(diff,'edgecolor','none');
figure(2);
subplot(1,2,1);plot(AvMinusbMatSimMag(1,:));axis([1 256 0 1e-6])
title('Matlab Av-b')
subplot(1,2,2);plot(AvMinusbHdlSimMag(1,:),'r');axis([1 256 0 1e-6])
title('HDL Av-b')
%}
% debug
figure(1);
plot(AvMinusbMatSimMag(1,:));
axis([1 256 0 .01])
grid ON
hold on
plot(AvMinusbHdlSimMag(1,:),'r');
hold off
legend('matlab data','hdl data')
title('Av-b Simul ')

debug = 1;


