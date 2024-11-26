#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "Digital differential analyzer";;

(* line joining (0,0) and (1366,768) *)
let x1 = 0;;
let x2 = 1366;;
let y1 = 0;;
let y2 = 768;;

set_color (red)

let plotterx x y x2 y2 m =
  let del_x = 1. in 
  let xn = ref (float x) in 
  let yn = ref (float y) in 
  plot x y;
  while (!xn <= float x2 && !yn <= float y2 ) do 
    xn := !xn +. del_x;
    yn := !yn +. m;
    plot (truncate !xn) (truncate !yn)
  done;;

let plottery x y x1 y2 m = 
  let del_y = 1. in 
  let xn = ref (float x) in 
  let yn = ref (float y) in 
  plot x y;
  while (!xn <= float x2 && !yn <= float y2) do 
    yn := !yn +. del_y;
    xn := !xn +. 1. /. m;
    plot (truncate !xn) (truncate !yn)
  done;;

let line_plotter x1 x2 y1 y2 = 
  let m = (float y2 -. float y1) /. (float x2 -. float x1) in 
  if abs_float m <= 1. then
    begin
      if x1 < x2 then 
        plotterx x1 y1 x2 y2 m
      else
        plotterx x2 y2 x1 y2 m
    end
  else
    begin
      if y1 < y2 then 
        plottery x1 y1 x2 y2 m
      else
        plottery x2 y2 x1 y1 m
    end;;

line_plotter x1 x2 y1 y2;;
set_color yellow;;
line_plotter 1300 1366 500 768;;
set_color cyan;;
line_plotter 0 1366 700 500;;