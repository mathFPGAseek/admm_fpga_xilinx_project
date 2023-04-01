%--------------------------------------------------------------------------
% file: check_Av_minus_.m
% engr: rbd
% date : 3/30/23
% descr: Av minus b check of matlab versus Vivado
%--------------------------------------------------------------------------

% load matlab sim
load('PreImage_fr_ifft_2d_check.mat'); % Av from check_A_ifft_2d.m
load('H.mat');  % equivalent to b

% load hdl sim
load('ifft_2d_seq_matrix_fr_viv_sim.mat');%???? We NEED AV-b from viv
% THE above is not correct, since this is AV

debug = 1;


%Calculate Av-b
index  = size(PreImage,1); %symmetrical matrix
for j = 1 : index
    for i = 1 : index
        Av_minus_b(i,j) = PreImage_fr_ifft_2d_check(i,j)-PreImage(i,j);
    end
end

debug = 1; 

% ???? Stoped here and fix  Av 2d ifft problem

% Save Matlab A for input verification downstream
save('hadmard_A_matlab_sim.mat','hadmard_prod_mat');

% adjust hdl hadmard 
complex_image_array = 4*complex_image_array;


%Compare
% compare mag
hadmardMatSimMag  = abs(hadmard_prod_mat);
hadmardHdlSimMag  = abs(complex_image_array);

figure(1);
diff = hadmardMatSimMag  - hadmardHdlSimMag;
surf(diff,'edgecolor','none');

figure(2);
%subplot(1,2,1);plot(hadmardMatSimMag(:,5));axis([1 256 0 1e-6])
subplot(1,2,1);plot(hadmardMatSimMag(1,:));axis([1 256 0 1e-6])
title('Matlab Hadmard product')
%subplot(1,2,2);plot(hadmardHdlSimMag(:,5),'r');axis([1 256 0 1e-6])
subplot(1,2,2);plot(hadmardHdlSimMag(1,:),'r');axis([1 256 0 1e-6])
title('HDL Hadmard product')
% debug
figure(3);
%plot(hadmardMatSimMag(:,5));
plot(hadmardMatSimMag(1,:));
axis([1 256 0 1e-6])
grid ON
hold on
%plot(4*hadmardHdlSimMag(:,5),'r');
%plot(4*hadmardHdlSimMag(1,:),'r');
plot(hadmardHdlSimMag(1,:),'r');
hold off
legend('matlab data','hdl data')
title('Hadmard product- Simul ')
debug = 1;

% save vectors for next stage hdl sim
clearvars -except complex_image_array
save('A_fwd_hadmard_2d_seq_matrix_adj_fr_viv_sim.mat','complex_image_array');

