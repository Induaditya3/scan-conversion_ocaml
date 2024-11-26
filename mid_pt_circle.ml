#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_color green;;
set_window_title "Circle using Bresenham's algorithm";;


let r = 234;;    
let plot_sym_points x y dimx dimy =
  plot (dimx+x) (dimy+y);
  plot (dimx+y) (dimy+x);
  plot (dimx+y) (dimy-x);
  plot (dimx+x) (dimy-y);
  plot (dimx-x) (dimy-y);
  plot (dimx-y) (dimy-x);
  plot (dimx-y) (dimy+x);
  plot (dimx-x) (dimy+y);;


let rec circle_inner x y d dimx dimy =
  if d < 0 && y > x then
    begin
      plot_sym_points (x+1) y dimx dimy;
      circle_inner (x+1) y (d+4*(x+1)+6) dimx dimy
    end
  else if d >= 0 && y > x then
    begin
      plot_sym_points (x+1) (y-1) dimx dimy;
      circle_inner (x+1) (y-1) (d+4*(x-y+2)+10) dimx dimy
    end
  else
    ();;

let circle r centerx centery =
  let d1 = 3 - 2 * r in 
  plot_sym_points 0 r centerx centery;
  circle_inner 0 r d1 centerx centery;;

circle r 500 500;;
