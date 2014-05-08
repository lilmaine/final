Introduction
============

The problem was to recreate the first part of the mario world by redrawing the map and implementing movement for mario. A functionality was to control Mario's movement with a SNES controller.

Implementation
==============

Using the VGA sync code from previous labs and stored memory I was able to display the mario world picture as well as a mario sprite on screen. To store the pictures in ROM I had to first convert the pictures to binary and RGB values respectively and then format them with javascript. The values were stored in 27 column chunks so I created an addressing method that took that into consideration which explains the minor skewin the background picture. Since the background image was black and white I only needed to create a single ROM with a std_logic vector ouput representing black or white. For the Mario character I had to use  ROM for red, green, and blue signals all std_logic_vector (7 downto 0) represetning all 255 color possibilities. The values were all then sent to the top level module and displayed to the monitor. Before running out of time I decided to make the game a little more interactive by having different coins approach at random intervals that mario would have to collect. Unfortunately I only had to draw an object that travels from right to left.

Test/debug
==================

The first major problem I had was trying to convert an image into an array of usable values. Eventually I found the function in matlab to do this with (imread('filename') I discovered that for normal sized images matlab automatically divides it into columns. In order to compensate for this I decided to try the addresing method of 

addr_sig <= to_integer(27*signed(row) + signed(column))when (column <=26) 


but this simply repeated the first 26 columns over and over. And since division is a hassle in VHDL I eventually decided on a rudementary approach of specifying what to do for every 27 columns. By taking the number of pixels in a 27 column by the height of the picture and multiplying that by the numbers of sections that preceded it and then adding that to the first code. This worked but not perfectly as there is still a minor skew to the photo.




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



The next major problem I had was trying to get my picture in color. What I found was that for images larger than a small sprite, outputting standard logic vector values of 8 bits for all three colors was too much for xilinx to handle. I wrote all of the code for this and compiled it for over 2 hours and it never finished generating a bit file.


Conclusion
============

After this lab I have gotten pretty good at creating and manipulating ROM and I am confident that if given more time I could create a game worthy of actual playtime. I have also learned a lot about image processing in matlab and how images are stored.



Video Available at: http://youtu.be/Vrx255XONXM

