#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_window_title "horizontal, vertical, diagonal Lines";;

(* horizontal line through the middle - color red *)
let clr = rgb 255 0 0;;
set_color clr;;
let width = size_x ();;
let height = size_y ();;

for i = 0 to width -1 do plot i (height/2) done;;

(* vertical line through the middle - color green *)
set_color (rgb 0 255 0);;
for j = 0 to height -1 do plot (width/2) j done;;

(* main diagonal - color blue *)
set_color blue;;
for i = 0 to width -1 do 
  for j = 0 to height -1 do
    if i = j then plot i j
  done;
done;;
(* other diagonal - cyan *)
set_color (rgb 155 155 155);;
for i = 0 to width - 1 do 
  for j = height -1 downto 0 do
    if i + j = height -1 then plot i j
  done;
done;;

plot 500 500;;