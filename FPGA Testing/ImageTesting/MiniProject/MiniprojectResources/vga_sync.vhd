
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY VGA_SYNC IS
	PORT(	clock_25Mhz		: IN	STD_LOGIC;
			red, green, blue : IN STD_LOGIC_VECTOR(3 downto 0);
			horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
			red_out, green_out, blue_out : OUT STD_LOGIC_VECTOR(3 downto 0);
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END VGA_SYNC;

ARCHITECTURE a OF VGA_SYNC IS
	SIGNAL horiz_sync, vert_sync : STD_LOGIC;
	SIGNAL video_on, video_on_v, video_on_h : STD_LOGIC;
	SIGNAL h_count, v_count :STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL video_on_four: STD_LOGIC_VECTOR(3 downto 0);

BEGIN

-- video_on is high only when RGB data is displayed
video_on <= video_on_H AND video_on_V;



PROCESS
BEGIN
	WAIT UNTIL(clock_25Mhz'EVENT) AND (clock_25Mhz='1');

--Generate Horizontal and Vertical Timing Signals for Video Signal
-- H_count counts pixels (640 + extra time for sync signals)
-- 
--  Horiz_sync  ------------------------------------__________--------
--  H_count       0                640             659       755    799
--
	IF (h_count = 799) THEN
   		h_count <= "0000000000";
	ELSE
   		h_count <= h_count + 1;
	END IF;

--Generate Horizontal Sync Signal using H_count
	IF (h_count <= 755) AND (h_count >= 659) THEN
 	  	horiz_sync <= '0';
	ELSE
 	  	horiz_sync <= '1';
	END IF;

--V_count counts rows of pixels (480 + extra time for sync signals)
--  
--  Vert_sync      -----------------------------------------------_______------------
--  V_count         0                                      480    493-494          524
--
	IF (v_count >= 524) AND (h_count >= 699) THEN
   		v_count <= "0000000000";
	ELSIF (h_count = 699) THEN
   		v_count <= v_count + 1;
	END IF;

-- Generate Vertical Sync Signal using V_count
	IF (v_count <= 494) AND (v_count >= 493) THEN
   		vert_sync <= '0';
	ELSE
  		vert_sync <= '1';
	END IF;

-- Generate Video on Screen Signals for Pixel Data
	IF (h_count <= 639) THEN
   		video_on_h <= '1';
   		pixel_column <= h_count;
	ELSE
	   	video_on_h <= '0';
	END IF;

	IF (v_count <= 479) THEN
   		video_on_v <= '1';
   		pixel_row <= v_count;
	ELSE
   		video_on_v <= '0';
	END IF;
	
	if (video_on = '1') then
		video_on_four <= "1111";
	else 
		video_on_four <= "0000";
	end if;


-- Put all video signals through DFFs to elminate any delays that cause a blurry image
		-- Put all video signals through DFFs to eliminate any delays that cause a blurry image
		red_out <= red AND video_on_four;
		green_out <= green AND video_on_four;
		blue_out <= blue AND video_on_four;
		horiz_sync_out <= horiz_sync;
		vert_sync_out <= vert_sync;

END PROCESS;
END a;
