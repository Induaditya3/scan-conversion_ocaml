#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "Direct use of line equation";;

(* line joining (0,0) and (1366,768) *)
let x1 = 0;;
let x2 = 1366;;
let y1 = 0;;
let y2 = 768;;

set_color (rgb 255 0 0)
(* slope *)
let m = (float y2 -. float y1) /. (float x2 -. float x1)
(* y-intercept *)
let b = float y1 -. m *. float x1;;

if abs_float m <= 1. then 
  begin
    for x = min x1 x2 to max x1 x2 do 
      let y = m *. (float x) +. b in 
      plot x (truncate y)
    done
  end
else
  begin 
    for y = min y1 y2 to max y1 y2 do 
      let x = ((float y) -.  b) /. m in 
      plot (truncate x) y
    done
  end
