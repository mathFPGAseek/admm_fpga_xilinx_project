%--------------------------------------------------------------------------
% file: fista_fpga_diffuser_cam.m
% engr: rbd
% date : 1/22/23
% descr: Semi-automatic outline to validate fista fpga design
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% General check of MEX FFT core
%--------------------------------------------------------------------------
run_xfft_v9_1_pipe_mex;

pause(15); % check that we get star pattern from small aperture of light

close all; clearvars; clc;           
%--------------------------------------------------------------------------
%% Generate 1-D FFT vectors
%--------------------------------------------------------------------------
generate_tb_fista_base_vectors; % COPY to viv wk

 if exist('real_psf_vectors.txt', 'file')
     disp(' File generated, vectors for 1-D FFT');
     close all; clearvars; 
 else
     error('Error: File does not exist \n');
 end

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------
disp(' Vivado 1D FFT should have been run ');
%--------------------------------------------------------------------------
%% Check 1-D FFT simulation
%--------------------------------------------------------------------------
convert_vectors_to_decimal; % after COPYING from viv wk "fft_1d_mem_raw_vevtors"

% Generate Xilinx MAT data to be checked
if exist('complex_image_array','var')
    disp(' Generate MAT Xilinx file for 1-D FFT checking');
    save('fft_1d_seq_matrix_fr_viv_sim.mat','complex_image_array');
    clearvars;
else
    error('Error: Could not generate MAT Xilinx file for testing');
end


% Generate Matlab model data to be checked against
run_xfft_v9_1_pipe_mex_1d_fft_no_shift;

if exist('ImgByRow','var')
    disp(' Generate MAT file for 1-D FFT checking');
    save('fft_1d_seq_matrix_fr_matlab.mat','ImgByRow'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end

% Perform 1-D FFT check
compare_hdl_sim_2_mat_sim_spec_1d_fft; % Checked Data & fftshift
pause(15); % Check errors by inspection

close all; clearvars;  

%--------------------------------------------------------------------------
%% Generate 2-D FFT vectors
%--------------------------------------------------------------------------
% rerun check to generate non-shifted vectors
compare_hdl_sim_2_mat_sim_spec_1d_fft_DEBUG;

generate_tb_fista_input_vectors_for_2d_fft; % COPY to viv wk

if exist('real_A_forward_2d_psf_vectors.txt', 'file') && exist('imag_A_forward_2d_psf_vectors.txt')
     disp(' File generated, vectors for 2-D FFT');
     close all; clearvars; 
else
     error('Error: Files does not exist \n');
end
%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------
disp(' Vivado 2D FFT should have been run ');
%--------------------------------------------------------------------------
%% Check 2-D FFT simulation
%--------------------------------------------------------------------------
convert_vectors_to_decimal_A_fwd_2d_fft; % after COPYING from viv wk "fft_A_forward_2d_mem_raw_vectors"

% Generate Xilinx MAT data to be checked
if exist('complex_image_array','var')
    disp(' Generate MAT Xilinx file for 2-D FFT checking');
    save('A_fwd_fft_2d_seq_matrix_fr_viv_sim.mat','complex_image_array');
    clearvars;
else
    error('Error: Could not generate MAT Xilinx file for testing');
end


% Generate Matlab model data to be checked against
run_xfft_v9_1_pipe_mex_2d_fft_no_shift_DEBUG;

if exist('ImgByRow','var')
    disp(' Generate MAT file for 2-D FFT checking');
    save('A_fwd_fft_2d_seq_matrix_fr_matlab.mat','PreImage'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end

% Perform 2-D FFT check
compare_hdl_sim_2_mat_sim_spec_A_fwd_2d_fft;  % Checked Data & fftshift
pause(15); % Check errors by inspection

close all; clearvars; 

debug = 1;
%--------------------------------------------------------------------------
%% Pad h and FFT ---> 2D H unshifted & generate vectors
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% reload 2D V unshifted & generate vectors
%--------------------------------------------------------------------------
load('A_fwd_fft_2d_seq_matrix_fr_viv_sim.mat');

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Check Hadmard Product simulation
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Generate 1-D IFFT vectors
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Check 1-D IFFT simulation
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Generate 2-D IFFT vectors
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Check 2-D IFFT simulation
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Generate Crop vectors
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Check Crop simulation
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%% Completed Calc A
%--------------------------------------------------------------------------





