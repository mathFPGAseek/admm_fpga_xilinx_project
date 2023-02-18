%--------------------------------------------------------------------------
% file: check_hadmard_A.m
% engr: rbd
% date : 2/18/23
% descr: Semi-automatic outline to validate fista fpga design
%--------------------------------------------------------------------------

% load matlab sim
load('H.mat'); % 'PreImage'
load('V.mat'); % 'reorderedHdlSim'

% load hdl sim
load('A_fwd_hadmard_2d_seq_matrix_fr_viv_sim.mat'); %'complex_image_array'

% Hadmard product
index  = size(PreImage,1); %symmetrical matrix
for j = 1 : index
    for i = 1 : index
        hadmard_prod_mat(i,j) = PreImage(i,j).*reorderedHdlSim(i,j);
    end
end

%Compare
% compare mag
hadmardMatSimMag  = abs(hadmard_prod_mat);
hadmardHdlSimMag  = abs(complex_image_array);

figure(1);
diff = hadmardMatSimMag  - hadmardHdlSimMag;
surf(diff,'edgecolor','none');

figure(2);
subplot(1,2,1);plot(hadmardMatSimMag(:,5));axis([1 256 0 1e-6])
title('Matlab Hadmard product')
subplot(1,2,2);plot(hadmardHdlSimMag(:,5),'r');axis([1 256 0 1e-6])
title('HDL Hadmard product')
% debug
figure(3);
plot(hadmardMatSimMag(:,5));
axis([1 256 0 1e-6])
grid ON
hold on
plot(4*hadmardHdlSimMag(:,5),'r');
hold off
legend('matlab data','hdl data')
title('Hadmard product- Corrected HDL ')
debug = 1;

