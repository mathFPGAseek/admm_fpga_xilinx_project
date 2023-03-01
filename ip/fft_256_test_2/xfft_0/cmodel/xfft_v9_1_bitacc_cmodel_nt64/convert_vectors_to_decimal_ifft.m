%-------------------------------------------------------------------------
%
% filename: convert_vectors_to_decimal.m
% engr: rbd
% date: 12/10/22
%
% descr:
% - raison d'etre:
% - Read in a file that is outputted from hardware simulation
% - so that we can compare against Matlab model
%
% - algo example:
% - temp3 = fi(-.0039,1,34,33);
% - temp3_bin = temp3.bin;
% - we get : '1111111110000000001101000110110111'
% - split into a fixed point string :
% - S = strsplit( '0.111111110000000001101000110110111', '.');
% - decimal positive if most sig = 0
% - negative if most sig = 1
%
%--------------------------------------------------------------------------
% declarations
S_dot = ".";
S_array = {};
j = 0; % to make cell array  at zero
rows = 256; % equal column for square image
fixed_point_length = 34;

% Import Table
fft1dmemvectors = importfile("C:\design\phd_ee\fall_2022_fpga_accel_fista_lenless_camera\fista_fpga_matlab\debug_1d_fft\admm_fpga_xilinx_project\ip\fft_256_test_2\xfft_0\cmodel\xfft_v9_1_bitacc_cmodel_nt64\ifft_1d_mem_raw_vectors.txt", [1, Inf]);
size_string = size(fft1dmemvectors,1);

% Split into Real and Imag Strings
[StringSplitArrayImagOut, StringSplitArrayRealOut] = SplitStringArray(fft1dmemvectors,fixed_point_length,size_string);

% convert to decimal - Pass String Array 
[S_imag_array] = ConvStringArray2CellArray(StringSplitArrayImagOut,size_string);
[S_real_array] = ConvStringArray2CellArray(StringSplitArrayRealOut,size_string);

% Write into an array to compare to 2-d fft model
r = size_string/rows;
c = r;
k = 1; % index for cell array
s_imag_numeric_array = zeros(r,c);
s_real_numeric_array = zeros(r,c);
for i = 1 : r
    for j = 1 : c
       s_imag_numeric_array(i,j) = S_imag_array{k};
       s_real_numeric_array(i,j) = S_real_array{k};
       k = k +1;
    end
end

% Assign complex wt to imag components
s_imag_weighted_array = s_imag_numeric_array*1i;

% Create final complex array
complex_image_array = s_real_numeric_array + s_imag_weighted_array;
clearvars -except complex_image_array

debug = 1;
%--------------------------------------------------------------------
%% Functions
%--------------------------------------------------------------------
function [DecimalOut] = Conv2Dec(S)
    intV      = S{1} - '0';
    fracV     = S{2} - '0';
    intValue  = intV  * (2 .^ (numel(intV)-1:-1:0).');
    fracValue = fracV * (2 .^ -(1:numel(fracV)).');
    if intValue == 0
        DecimalOut = fracValue;
    else
        DecimalOut = fracValue -1;
    end
end
function fft1dmemvectors1_r1 = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  FFT1DMEMVECTORS1_R1 = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a string
%  array.
%
%  FFT1DMEMVECTORS1_R1 = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  fft1dmemvectors1_r1 = importfile("C:\design\phd_ee\summer_2022_fpga_accel_admm_lenless_camera\admm_fpga_xilinx_project\ip\fft_256_test_2\xfft_0\cmodel\xfft_v9_1_bitacc_cmodel_nt64\fft_1d_mem_vectors.txt", [1, Inf]);
%
%  See also READMATRIX.
%
% Auto-generated by MATLAB on 10-Dec-2022 11:19:25

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 1);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = "VarName1";
opts.VariableTypes = "string";

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "VarName1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName1", "EmptyFieldRule", "auto");

% Import the data
fft1dmemvectors1_r1 = readmatrix(filename, opts);

end
function[S_array] = ConvStringArray2CellArray(fft1dmemvectors,size_string)
    % declarations
    S_dot = ".";
    S_array = {};
    j = 0; % to make cell array  at zero
    % convert to decimal
    for i = 1 : size_string
        S_string = fft1dmemvectors(i);
        S_dec = insertAfter(S_string,1,S_dot);
        S_format = strsplit(S_dec,'.');
        [DecimalOut] = Conv2Dec(S_format);
        S_array{j+1} = DecimalOut;
        j = j+1; 
    end
end
function[StringSplitArrayImagOut, StringSplitArrayRealOut] = SplitStringArray(StringIn,FixedPointLengthIn,SizeStringIn)
    Sdot = ".";
    k = 0;
    % create cell array
    CellArrayImag = {};
    CellArrayReal = {};
    % create string array
    StringSplitArrayImagOut = strings(SizeStringIn,1);
    StringSplitArrayRealOut = strings(SizeStringIn,1);

    for i = 1 : SizeStringIn
        Stemp = insertAfter(StringIn(i),FixedPointLengthIn,Sdot);
        Ssplit = strsplit(Stemp,Sdot);
        StringSplitImagTemp = Ssplit{1};
        StringSplitRealTemp = Ssplit{2};
        CellArrayImag{k+1} = StringSplitImagTemp;
        CellArrayReal{k+1} = StringSplitRealTemp;
        k = k+1;
    end

    % Create Character array
    CharSplitArrayImagOutTemp = char(CellArrayImag{1:SizeStringIn});
    CharSplitArrayRealOutTemp = char(CellArrayReal{1:SizeStringIn});

    % Create String array
    for i = 1 : SizeStringIn
        % Imag
        CharLineImagTemp = CharSplitArrayImagOutTemp(i,1:FixedPointLengthIn);
        StringLineImagTemp = convertCharsToStrings(CharLineImagTemp);
        StringSplitArrayImagOut(i) = StringLineImagTemp;
        %Real
        CharLineRealTemp = CharSplitArrayRealOutTemp(i,1:FixedPointLengthIn);
        StringLineRealTemp = convertCharsToStrings(CharLineRealTemp);
        StringSplitArrayRealOut(i) = StringLineRealTemp;
    end
end



