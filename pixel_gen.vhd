----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:31:46 01/29/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM; 
use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity pixel_gen is
    Port ( row : in  unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           blank : in  STD_LOGIC;
			  clk: in std_logic;
			  paddle_y : in unsigned(10 downto 0);
			  ball_x : in unsigned(10 downto 0);
			  ball_y : in unsigned(10 downto 0);				  
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end pixel_gen;

architecture Behavioral of pixel_gen is

	constant paddle_width, ball_radius: unsigned(4 downto 0) := "01000";
	constant  paddle_height: unsigned(4 downto 0) := "11100";
	constant  pic_size: integer := 92160;	 
	signal data_sig : STD_LOGIC;
	signal r_sig, g_sig, b_sig : STD_LOGIC_VECTOR (7 downto 0);
	signal red_sig, green_sig, blue_sig : STD_LOGIC_VECTOR (7 downto 0);
	
	signal addr_sig : integer range 0 to pic_size ;	
	signal red_addr_sig, green_addr_sig, blue_addr_sig : integer range 0 to 2759;

	signal count_reg: integer range 0 to pic_size:= 0;
	signal count_next: integer range 0 to pic_size;
	signal position: integer := 7776;
begin

	--count register
	process(clk)
	begin
		if rising_edge(clk) and (blank = '0') then
			count_reg <= count_next;
		else
			count_reg <= count_reg;
		end if;
	end process;	

	count_next <= 	0 when count_reg >= 2759 else 
						count_reg + 1;

Inst_memory: entity work.memory(arch) PORT MAP(
		clk => clk ,
		addr => addr_sig,
		data => data_sig
	);

Inst_red_mem: entity work.red_mem(arch) PORT MAP(
		clk => clk ,
		addr => red_addr_sig,
		red => r_sig
	);
	
Inst_green_mem: entity work.green_mem(arch) PORT MAP(
		clk => clk ,
		addr => green_addr_sig,
		green => g_sig
	);
	
Inst_blue_mem: entity work.blue_mem(arch) PORT MAP(
		clk => clk ,
		addr => blue_addr_sig,
		blue => b_sig
	);

--Inst_red_mario: entity work.red_mario(arch) PORT MAP(
--		clk => clk ,
--		addr => addr_sig,
--		red => red_sig
--	);
--	
--Inst_green_mario: entity work.green_mario(arch) PORT MAP(
--		clk => clk ,
--		addr => addr_sig,
--		green => green_sig
--	);
--	
--Inst_blue_mario: entity work.blue_mario(arch) PORT MAP(
--		clk => clk ,
--		addr => addr_sig,
--		blue => blue_sig
--	);


	addr_sig <= to_integer(27*signed(row) + signed(column))when (column <=26) else
					to_integer(27*signed(row) + signed(column) +position*1 ) when (column > 26 and column <= 53) else
					to_integer(27*signed(row) + signed(column) +position*2 ) when (column > 53 and column <= 80) else
					to_integer(27*signed(row) + signed(column) +position*3 ) when (column > 80 and column <= 107) else
					to_integer(27*signed(row) + signed(column) +position*4 ) when (column > 107 and column <= 134) else
					to_integer(27*signed(row) + signed(column) +position*5 ) when (column > 134 and column <= 161) else
					to_integer(27*signed(row) + signed(column) +position*6 ) when (column > 161 and column <= 188) else
					to_integer(27*signed(row) + signed(column) +position*7 ) when (column > 188 and column <= 215) else
					to_integer(27*signed(row) + signed(column) +position*8 ) when (column > 215 and column <= 242) else
					to_integer(27*signed(row) + signed(column) +position*9) when (column > 242 and column <= 269) else
					to_integer(27*signed(row) + signed(column) +position*10) when (column > 269 and column <= 296) else
					to_integer(23*signed(row) + signed(column) +position*11) when (column > 296 and column <= 320) else
					0;
					
	red_addr_sig <= to_integer(46*signed(row) + signed(column));
	green_addr_sig <= to_integer(46*signed(row) + signed(column));
	blue_addr_sig <= to_integer(46*signed(row) + signed(column));
		
--	red_addr_sig <= count_reg;
--	green_addr_sig <= count_reg;
--	blue_addr_sig <= count_reg;
	
	process(clk, data_sig, blank)
	begin
			r <= "00000000";		
			g <= "00000000";		
			b <= "00000000";
		if(column <320  and row < 288) then
			if (column <= 45) and (row >= paddle_y and row <= paddle_y+60) then
				r <= r_sig;	
				g <= g_sig;	
				b <= b_sig;
--Ball					
			elsif(row >= ball_y and column >=ball_x and column <= ball_x + ball_radius and row <= ball_y+ ball_radius) then
					g <= (others => '0');
					r <= "11111111";						
					b <= "11111111";						
			elsif(data_sig = '1') then
				r <= "11111111";		
				g <= "11111111";		
				b <= "11111111";		
			else	
				r <= "00000000";		
				g <= "00000000";		
				b <= "00000000";
			end if;		 
		end if;
	end process;




end Behavioral;



