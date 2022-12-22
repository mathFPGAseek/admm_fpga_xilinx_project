%--------------------------------------------------------------------------
% file: compare_hdl_sim_2_mat_sim_1d_fft.m
% engr: rbd
% date : 12/21/22
% raison d'etre: match vectors hdl sim to matlab
% descr/instrs:
% Rearrange sims from hdl sim and matlab to compare.
% Steps :
% 0. Copy fft_1d_mem_raw_vectors.txt to this working directory.
% 1. Run convert_vectors_to_decimal.m ... This converts the HDL sim text
% file in binary to decimal values in an array called complex_image_array
% 2. Copy 'complex_image_array' to mat file called:
% 'fft_1d_seq_matrix_fr_viv_sim.mat'
% 3. Run run_xfft_v9_1_pipe_mex_1d_fft_no_shift.m up to generation of rows
% with no shift
% 4. Run clearvars -except ImgByRow
% 5. Copy ImgByRow to mat file called:
% 'fft_1d_seq_matrix_fr_matlab.mat'
% 6. Run this file
% Expected Results:
% HDL is sequenced from 1 to 256
% Matlab is sequenced from 1 to 256 because no fftshift
% error is less than 2 *10^-3
%--------------------------------------------------------------------------

% load hdl sim and matlab sim
load('fft_1d_seq_matrix_fr_viv_sim.mat');
load('fft_1d_seq_matrix_fr_matlab.mat');

% rename arrays
ImgByRowFrHdlSimSeq = complex_image_array; % import fft-1d from hdl sim
ImgByRowFrMatSimSeq = ImgByRow; % import fft-1d from matlab

clear vars complex_image_array ImgByRow

% reorder array conversion from hdl sim

hdl_sim_order = [0 128 64 192	32	160	96	224	16	144	80	208	48	176	112	240	8	136	72	200	40	168	104	232	24	152	88	216	56	184	120	248 ...
      4	132 68 196	36	164	100 228	20	148	84	212	52	180	116	244	12	140	76	204	44	172	108	236	28	156	92	220	60	188	124	252 ...
      2	130 66 194	34	162	98	226	18	146	82	210	50	178	114	242	10	138	74	202	42	170	106	234	26	154	90	218	58	186	122	250 ...
      6	134 70 198	38	166	102 230	22	150	86	214	54	182	118	246	14	142	78	206	46	174	110	238	30	158	94	222	62	190	126	254 ...
      1	129 65 193	33	161	97	225	17	145	81	209	49	177	113	241	9	137	73	201	41	169	105	233	25	153	89	217	57	185	121	249 ...
      5 133 69 197	37	165	101 229	21	149	85	213	53	181	117	245	13	141	77	205	45	173	109	237	29	157	93	221	61	189	125	253 ...
      3	131 67 195	35	163	99	227	19	147	83	211	51	179	115	243	11	139	75	203	43	171	107	235	27	155	91	219	59	187	123	251 ...
      7	135 71 199	39	167	103 231	23	151	87	215	55	183	119	247	15	143	79	207	47	175	111	239	31	159	95	223	63	191	127	255];

% init
rows = size(ImgByRowFrHdlSimSeq,1);
col = rows;
reorderedHdlSim = zeros(rows,col);


% reorder hdlsim for comparison
k = 1;
index = 0;
for i = 1 : rows
    for j = 1 : col
        index = hdl_sim_order(k);
        index = index + 1; % matlab does not like zero
        value_to_write = ImgByRowFrHdlSimSeq(i,j);
        reorderedHdlSim(i,index) = value_to_write;
        k = k + 1;
    end
    k = 1;
end


% reorder array from matlab sim
%{
mat_sim_order = [128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159
      160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191
      192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223
      224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 222 245 246 247 248 249 250 251 252 253 254 255
        0   1   2  3    4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31
       32  33  34 35   36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  61  62  63
       64  65 66  67   68  69  70  71  72  73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90  91  92  93  94  95
       96  97 98  99  100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 ];
%}
% init
reorderedMatSim = zeros(rows,col);


% reorder matlab sim for comparison
k = 1;
for i = 1 : rows
    for j = 1 : col
        %index = mat_sim_order(k);
        %index = index + 1; % matlab does not like zero
        value_to_write = ImgByRowFrMatSimSeq(i,j);
        reorderedMatSim(i,k) = value_to_write;
        k = k + 1;
    end
    k = 1;
end

% arrange sequences as columns
TransposeImgByRowFrHdlSimSeq = reorderedHdlSim(120,:)';
TransposeImgByRowFrMatSimSeq = reorderedMatSim(120,:)';

debug = 1;

% compare mag
reorderedMatSimMag  = abs(reorderedMatSim);
reorderedHdlSimMag  = abs(reorderedHdlSim);

diff = reorderedMatSimMag  - reorderedHdlSimMag;
surf(diff,'edgecolor','none');



debug = 1;
