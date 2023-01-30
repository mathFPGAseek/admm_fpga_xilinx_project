%--------------------------------------------------------------------------
% file: generate_tb_fista_input_V_vectors_for_A_hadmard.m.
% engr: rbd
% date : 1/29/22
% 
% descr/instrs:
% Run this script to generate input complex input for Hadmard product
% Steps :
%--------------------------------------------------------------------------
clf;

debug = 1;

% files to be created for test vectors for testbench
fid_real_V_forward_hadmard = fopen('real_A_forward_V_hadmard_vector.txt', 'wt');
fid_imag_V_forward_hadmard = fopen('imag_A_forward_V_hadmard_vector.txt', 'wt');

% Split into real and imaginary portions into input vectors for 2d fft
cols = size(reorderedHdlSim,2);
rows = cols; % rows match
for j = 1 : cols
    for i =  1 : rows 
        % real
        input_sample_real = real(reorderedHdlSim(i,j));
        input_sample_real_fi_num = fi(input_sample_real,1,34,33);
        input_char_array_real    = input_sample_real_fi_num.bin;
        fprintf(fid_real_V_forward_hadmard,'%34s \n',input_char_array_real);
        debug = 1;
        % imag
        input_sample_imag = imag(reorderedHdlSim(i,j));
        input_sample_imag_fi_num = fi(input_sample_imag,1,34,33);
        input_char_array_imag    = input_sample_imag_fi_num.bin;
        fprintf(fid_imag_V_forward_hadmard,'%34s \n',input_char_array_imag);
        debug = 1;
    end
end
debug = 1;
