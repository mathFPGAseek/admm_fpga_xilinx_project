%--------------------------------------------------------------------------
% file: generate_tb_fista_input_vectors_for_2d_fft.m
% engr: rbd
% date : 12/26/22
% raison d'etre: input vectors generated after fft row processing
% descr/instrs:
% Run this script to generate input complex input 
% Steps :
%--------------------------------------------------------------------------
clf;
clearvars -except reorderedHdlSim;

debug = 1;

% files to be created for test vectors for testbench
fid_real_A_forward_2d_psf = fopen('real_A_forward_2d_psf_vectors.txt', 'wt');
fid_imag_A_forward_2d_psf = fopen('imag_A_forward_2d_psf_vectors.txt', 'wt');

% Split into real and imaginary portions into input vectors for 2d fft
cols = size(reorderedHdlSim,2);
rows = cols; % rows match
for j = 1 : cols
    for i =  1 : rows 
        % real
        input_sample_real = real(reorderedHdlSim(i,j));
        input_sample_real_fi_num = fi(input_sample_real,1,34,33);
        input_char_array_real    = input_sample_real_fi_num.bin;
        fprintf(fid_real_A_forward_2d_psf,'%34s \n',input_char_array_real);
        debug = 1;
        % imag
        input_sample_imag = imag(reorderedHdlSim(i,j));
        input_sample_imag_fi_num = fi(input_sample_imag,1,34,33);
        input_char_array_imag    = input_sample_imag_fi_num.bin;
        fprintf(fid_imag_A_forward_2d_psf,'%34s \n',input_char_array_imag);
        debug = 1;
    end
end
debug = 1;
