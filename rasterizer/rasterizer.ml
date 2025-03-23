#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "rasterizer";;


type point_2 =
  {
    x : int;
    y : int
  }

let plotc x' y' color =
  let x,y =  x' + (size_x ()) / 2, y' + (size_y ()) / 2 in 
  set_color color;
  plot x y

(* uses y = mx + c *)
(* increments smaller abcissa till it reachs bigger abcissa *)
(* to find subsequent ordinate - inital ordinate + slope *)
let rec draw_line_inner {x = x0;y = y0} {x = x1;y = y1} slope color =
  if x0 = x1 then ()
  else 
    begin
      plotc x0 y0 color;
      draw_line_inner {x = x0+1;y = y0+slope} {x = x1;y = y1} slope color
    end
(* wrapper function *)
(* passes slope and interchanges points so that first point has smaller abcissa compared to second's*)
let draw_line (x0,y0) (x1,y1) color = 
  if x0 > x1 then 
    draw_line_inner {x = x1;y = y1} {x = x0;y = y0} (truncate (float (y1 - y0) /. float (x1 - x0))) color
  else
    draw_line_inner {x = x0;y = y0} {x = x1;y = y1} (truncate (float (y1 - y0) /. float (x1 - x0))) color