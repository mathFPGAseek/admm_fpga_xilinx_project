----------------------------------------------------------------------
-- file_name: debug_x_update_fwd_fft_tb.vhd
-- engineer:
-- date:
-- project: ADMM in FPGA
--
-- Descr: 1st small TB for testing FFT in x_update engine
----------------------------------------------------------------------
library ieee ;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use std.textio.all ;

ENTITY debug_x_update_fwd_fft_module_top_tb IS

end entity;


ARCHITECTURE struct OF debug_x_update_fwd_fft_module_top_tb IS

   -- Architecture declarations

   -- TB control signals
   SIGNAL clk_sig : std_logic := '1';
   SIGNAL nrst_sig : std_logic := '0';
   constant CLOCK_PERIOD_C : time := 10 ns;
   constant RESET_PERIOD_C : time := 5*CLOCK_PERIOD_C ;
   
   
   -- Constants
   constant INPUT_BUFFER_SIZE : integer := 8388608;

   constant STIM_IMG_EST : string := "tbd.txt";



 ----------------------------------------
 -- DUT: FWD FFT
 ----------------------------------------


	-------------------------------------------------
	-- Read From file for image estimate 
	-------------------------------------------------
	readInputStim : process

		file control :text open read_mode is STIM_IMG_EST;
		variable inputLine : line;
		variable data_sample : std_logic_vector(15 downto 0);
		variable I : integer := 0;
	begin
		report "Entered Read input process: " severity note;
		command_loop : while not endfile(control) and I < MAX_NUM_SAMPLE_TO_READ  loop
			readline (control, inputLine); 
			read_from_file(inputLine,data_sample);
			fft_input_data(I) <= data_sample;
			I := I + 1;
		end loop;
		write(OUTPUT, "This is the time: " & to_string(now) & LF) ;
		wait;
	end process ; -- readInputStim
	
	
	
	
	
	END struct;