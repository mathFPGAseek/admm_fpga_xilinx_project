%--------------------------------------------------------------------------
% file: fista_fpga_diffuser_cam.m
% engr: rbd
% date : 1/22/23
% descr: Semi-automatic outline to validate fista fpga design
%
%--------------------------------------------------------------------------
%{
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
compare_hdl_sim_2_mat_sim_spec_1d_fft; % Checked Data & fftshift (Also reorders Viv vectors)
pause(15); % Check errors by inspection

close all; clearvars;  

%--------------------------------------------------------------------------
%% Generate 2-D FFT vectors
%--------------------------------------------------------------------------
regenerate_and_reorder_input_vectors_for_2d_fft; % vectors unshifted
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
run_xfft_v9_1_pipe_mex_2d_fft_no_shift_no_shift;

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

%--------------------------------------------------------------------------
%% Pad h and FFT ---> 2D H unshifted & generate vectors
%--------------------------------------------------------------------------
matrix_A_F_H_run_xfft_v9_1_pipe_mex_2d_fft_no_shift;
if exist('2d_real_H_psf_vectors.txt', 'file') && exist('2d_imag_H_psf_vectors.txt', 'file')
     disp(' File generated, H vectors for Hadmard Product');
     close all; clearvars; 
else
     error('Error: File does not exist \n');
end

debug = 1;

%--------------------------------------------------------------------------
%% reload 2D V unshifted & generate vectors
%--------------------------------------------------------------------------
regenerate_A_fwd_V_2d_fft;
generate_tb_fista_input_V_vectors_for_A_hadmard;
if exist('real_A_forward_V_hadmard_vector.txt') && exist('imag_A_forward_V_hadmard_vector.txt', 'file')
     disp(' File generated, V vectors for Hadmard Product');
     close all; clearvars; 
else
     error('Error: File does not exist \n');
end

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------
disp(' Vivado Hadmard Prodcut should have been run ');
debug = 1;
%--------------------------------------------------------------------------
%% Check Hadmard Product simulation
%--------------------------------------------------------------------------
convert_vectors_to_decimal_A_hadmard_2d; % after COPYING from viv wk "hadmard_A_forward_2d_mem_raw_vectors.txt"

% Generate Xilinx MAT data to be checked
if exist('complex_image_array','var')
    disp(' Generate MAT Xilinx file for 2-D Hadmard checking');
    save('A_fwd_hadmard_2d_seq_matrix_fr_viv_sim.mat','complex_image_array');
    clearvars;
else
    error('Error: Could not generate MAT Xilinx file for testing');
end


% Generate Matlab model data to be checked against
gen_H;

if exist('PreImage','var')
    disp(' Generate MAT file for Hadmard checking');
    save('H.mat','PreImage'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end

% Generate Matlab model data to be checked against
gen_V; % alias regenerate_A_fwd_V_2d_fft.m

if exist('reorderedHdlSim','var')
    disp(' Generate MAT file for Hadmard checking');
    save('V.mat','reorderedHdlSim'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end

% Perform Hadmard "A" check
check_hadmard_A;  
pause(15); % Check errors by inspection

close all; clearvars; 

%--------------------------------------------------------------------------
%% Generate 1-D IFFT vectors
%--------------------------------------------------------------------------
generate_tb_A_1d_ifft; % COPY to viv wk

if exist('real_A_1d_ifft_vectors.txt', 'file') && exist('imag_A_1d_ifft_vectors.txt')
     disp(' File generated, vectors for 1-D IFFT');
     close all; clearvars; 
else
     error('Error: Files does not exist \n');
end

%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------
disp(' Vivado 1-D IFFT calc Matrix A should have been run ');
debug = 1;
%--------------------------------------------------------------------------
%% Check 1-D IFFT simulation
%--------------------------------------------------------------------------

convert_vectors_to_decimal_ifft; % after COPYING from viv wk "ifft_1d_mem_raw_vevtors"

% Generate Xilinx MAT data to be checked
if exist('complex_image_array','var')
    disp(' Generate MAT Xilinx file for 1-D IFFT checking');
    save('ifft_1d_seq_matrix_fr_viv_sim.mat','complex_image_array');
    clearvars;
else
    error('Error: Could not generate MAT Xilinx file for testing');
end


% Generate Matlab model data to be checked against
gen_A_ifft_1d; % use 'hadmard_prod_mat' from check_hadmard_A.m;  

if exist('ImgByRow','var')
    disp(' Generate MAT file for 1-D IFFT checking');
    save('ifft_1d_seq_matrix_fr_matlab.mat','ImgByRow'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end

% Perform 1-D FFT check
check_A_ifft_1d; % Checked Data & fftshift (Also reorders Viv vectors)
%pause(15); % Check errors by inspection
debug = 1;
close all; clearvars; 



%--------------------------------------------------------------------------
%% Generate 2-D IFFT vectors
%--------------------------------------------------------------------------
regenerate_and_reorder_input_vectors_for_2d_ifft; % vectors unshifted
generate_tb_fista_input_vectors_for_2d_ifft; % COPY to viv wk
% THIS IS INCORRECT !!: generate_tb_A_2d_ifft;
% ??? Compare these vectors to old vectors to make sure they are different
if exist('real_A_2d_ifft_vectors.txt', 'file') && exist('imag_A_2d_ifft_vectors.txt')
     disp(' File generated, vectors for 2-D IFFT');
     close all; clearvars; 
else
     error('Error: Files does not exist \n');
end
%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------
disp(' Vivado 2-D IFFT calc Matrix A should have been run ');
debug = 1;
%}
%--------------------------------------------------------------------------
%% Check 2-D IFFT simulation
%--------------------------------------------------------------------------

convert_vectors_to_decimal_2d_ifft; % after COPYING from viv wk "ifft_2d_mem_raw_vevtors"

% Generate Xilinx MAT data to be checked
if exist('complex_image_array','var')
    disp(' Generate MAT Xilinx file for 2-D IFFT checking');
    save('ifft_2d_seq_matrix_fr_viv_sim.mat','complex_image_array');
    clearvars;
else
    error('Error: Could not generate MAT Xilinx file for testing');
end


% Generate Matlab model data to be checked against
% ???So, the hadmard should work here; double check and use hadmard( need
% to make change
gen_A_ifft_2d; % same as gen_A_ifft_1d; use 'hadmard_prod_mat' from check_hadmard_A.m; 

if exist('ImgByRow','var')
    disp(' Generate MAT file for 2-D IFFT checking');
    save('ifft_2d_seq_matrix_fr_matlab.mat','PreImage'); %% no fftshift
    close all; clearvars;
else
    error('Error: Could not generate MAT file for testing');
end

% Perform 1-D FFT check
check_A_ifft_2d; % Checked Data & fftshift (Also reorders Viv vectors)
%pause(15); % Check errors by inspection
debug = 1;
close all; clearvars; 
%--------------------------------------------------------------------------
%% Generate Crop vectors
%--------------------------------------------------------------------------
disp(' No crop of vectors ');
%--------------------------------------------------------------------------
%% Run Vivado FPGA simulator; External tool
%--------------------------------------------------------------------------
disp('DO not need to run Vivado to check Crop ');
%--------------------------------------------------------------------------
%% Check Crop simulation
%--------------------------------------------------------------------------
disp(' No crop of vectors ');
%--------------------------------------------------------------------------
%% Completed Calc A
%--------------------------------------------------------------------------
debug = 1;




