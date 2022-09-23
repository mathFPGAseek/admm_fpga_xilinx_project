------------------------------------------------
-- Created By: RBD
-- filename: resource_test_top.vhd
-- Initial Date: 2/6/22
-- Descr: Resource Test for ADMM FPGA for lenless
-- camera.
------------------------------------------------
library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;


ENTITY resource_test_top is

    PORT (
    -- input
    clk_i                   			: in std_logic;
    resetn_i                  	 	: in std_logic;
    s_axis_config_tdata_i   			: in std_logic_vector( 15 downto 0);
    s_axis_config_tvalid_i  			: in std_logic;
    s_axis_data_tdata_i     			: in std_logic_vector( 79 downto 0);
    s_axis_data_tvalid_i    			: in std_logic;
    s_axis_data_tlast_i     			: in std_logic;
    m_axis_data_tready_i    			: in std_logic;

    -- output
    s_axis_config_tready_o  			: out std_logic;
    s_axis_data_tready_o    			: out std_logic;  
    m_axis_data_tvalid_o    			: out std_logic;
    m_axis_data_tlast_o     			: out std_logic;
    m_axis_data_tdata_sig_o       : out std_logic_vector( 79 downto 0);
    event_frame_started_o   			: out std_logic;
    event_tlast_unexpected_o 	  	: out std_logic;
    event_tlast_missing_o     		: out std_logic;
    event_status_channel_halt_o 	: out std_logic;
    event_data_in_channel_halt_o  : out std_logic;
    event_data_out_channel_halt_o : out std_logic    

);

END resource_test_top;


architecture struct of  resource_test_top is


BEGIN
   -- Architecture concurrent statements

  -----------------------------------------
  -- FFT Engine
  -----------------------------------------
  U1: entity work.xfft_0 
  PORT MAP ( 
  	--input
    aclk =>  clk_i,--in STD_LOGIC;
    aresetn => resetn_i,--in STD_LOGIC;  
    s_axis_config_tdata =>  s_axis_config_tdata_i, --in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axis_config_tvalid => s_axis_config_tvalid_i,--in STD_LOGIC;
    s_axis_data_tdata => s_axis_data_tdata_i, --in STD_LOGIC_VECTOR ( 79 downto 0 );
    s_axis_data_tvalid => s_axis_data_tvalid_i, --in STD_LOGIC;
    s_axis_data_tlast => s_axis_data_tlast_i, --in STD_LOGIC;
    m_axis_data_tready => m_axis_data_tready_i, --in STD_LOGIC;
    
    
    --output
    s_axis_config_tready => s_axis_config_tready_o, --out STD_LOGIC;
    s_axis_data_tready => s_axis_data_tready_o, --out STD_LOGIC;
    m_axis_data_tvalid => m_axis_data_tvalid_o, --out STD_LOGIC;
    m_axis_data_tlast => m_axis_data_tlast_o, --out STD_LOGIC;    
    m_axis_data_tdata => m_axis_data_tdata_sig_o, --out STD_LOGIC_VECTOR ( 79 downto 0 );  
    event_frame_started => event_frame_started_o, --out STD_LOGIC;
    event_tlast_unexpected => event_tlast_unexpected_o, --out STD_LOGIC;
    event_tlast_missing => event_tlast_missing_o, --out STD_LOGIC;
    event_status_channel_halt => event_status_channel_halt_o, --out STD_LOGIC;
    event_data_in_channel_halt => event_data_in_channel_halt_o, --out STD_LOGIC;
    event_data_out_channel_halt => event_data_out_channel_halt_o --out STD_LOGIC
  );

  -----------------------------------------
  -- Div Engine
  -----------------------------------------
  --U2: entity work.div_gen_0
  --PORT MAP ( 
  --  aclk => clk_i,--in STD_LOGIC;
  --  aresetn => resetn_i,--in STD_LOGIC;
  --  s_axis_divisor_tvalid => s_axis_divisor_tvalid_i,--in STD_LOGIC;
  --  s_axis_divisor_tdata => s_axis_divisor_tdata_i,--in STD_LOGIC_VECTOR ( 23 downto 0 );
  --  s_axis_dividend_tvalid => s_axis_dividend_tvalid_i,--in STD_LOGIC;
  --  s_axis_dividend_tdata => s_axis_dividend_tdata_i,--in STD_LOGIC_VECTOR ( 23 downto 0 );
  --  m_axis_dout_tvalid => m_axis_dout_tvalid_o,--out STD_LOGIC;
  --  m_axis_dout_tdata =>  m_axis_dout_tdata_sig--out STD_LOGIC_VECTOR ( 47 downto 0 )
  --);
  
  --mux_out : process(sel_dbg_i)
  --begin
  --  if( sel_dbg_i = '1') then
  --     mux_dbg_o <= m_axis_data_tdata_sig;
  --  else
  --     mux_dbg_o <= m_axis_dout_tdata_sig;
  --  end if;
  --end process mux_out;

END architecture struct;