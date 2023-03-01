%--------------------------------------------------------------------------
% file: generate_tb_A_1d_ifft.m
% engr: rbd
% date : 2/19/23
% descr/instrs:
% Run this script to generate input complex input for IFFT 1d calc A Matrix
%--------------------------------------------------------------------------
clf;
clearvars 

debug = 1;
% load Hadmard calc A Matrix from Viviado that is adjusted by factor of 4
load('A_fwd_hadmard_2d_seq_matrix_adj_fr_viv_sim.mat'); %'complex_image_array'

% files to be created for test vectors for testbench
fid_real_A_1d_ifft = fopen('real_A_1d_ifft_vectors.txt', 'wt');
fid_imag_A_1d_ifft = fopen('imag_A_1d_ifft_vectors.txt', 'wt');

% Split into real and imaginary portions into input vectors for 2d fft
cols = size(complex_image_array,2);
rows = cols; % rows match
for i = 1 : rows
    for j =  1 : cols 
        % real
        input_sample_real = real(complex_image_array(i,j));
        input_sample_real_fi_num = fi(input_sample_real,1,34,33);
        input_char_array_real    = input_sample_real_fi_num.bin;
        fprintf(fid_real_A_1d_ifft ,'%34s \n',input_char_array_real);
        debug = 1;
        % imag
        input_sample_imag = imag(complex_image_array(i,j));
        input_sample_imag_fi_num = fi(input_sample_imag,1,34,33);
        input_char_array_imag    = input_sample_imag_fi_num.bin;
        fprintf(fid_imag_A_1d_ifft,'%34s \n',input_char_array_imag);
        debug = 1;
    end
end
debug = 1;
