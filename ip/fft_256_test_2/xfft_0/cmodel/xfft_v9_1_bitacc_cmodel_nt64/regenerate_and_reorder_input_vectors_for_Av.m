%--------------------------------------------------------------------------
% file: regenerate_and_reorder_input_vectors_for_Av.m
% engr: rbd
% date : 3/12/23
% descr: Convert MAT file from last stage to a variable that will
% be converted into a fixed point number to be tested by next stage
% Extra note: MAT file from 2D IFFT(last stage) is a:
% 1. Unordered ( Do ordereing in a column major fashion since vectors are
% from a 2D IFFT
% 2. Complex numeric
%--------------------------------------------------------------------------

% load hdl sim
load('ifft_2d_seq_matrix_fr_viv_sim.mat');

% rename arrays
ImgByRowFrHdlSimSeq = complex_image_array; % import ifft-1d from hdl sim

clear vars complex_image_array 

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


%% reorder hdlsim as sequence
k = 1;
index = 0;
for i = 1 : col
    for j = 1 : rows
        index = hdl_sim_order(k);
        index = index + 1; % matlab does not like zero
        value_to_write = ImgByRowFrHdlSimSeq(i,j);
        reorderedHdlSim(i,index) = value_to_write;
        k = k + 1;
    end
    k = 1;
end



debug = 1;
