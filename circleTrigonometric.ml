#use "topfind";;
#require "graphics";;
open Graphics;;
open_graph "";;
resize_window 1366 768;;
set_color black;;
set_window_title "Circle using trigonometry";;

for x = 0 to size_x () - 1 do
  for y = 0 to size_y () -1 do
    plot x y
  done
done;;

set_color white;;

let plot_sym_points (x, y) dimx dimy =
  plot (dimx+x) (dimy+y);
  plot (dimx+y) (dimy+x);
  plot (dimx+y) (dimy-x);
  plot (dimx+x) (dimy-y);
  plot (dimx-x) (dimy-y);
  plot (dimx-y) (dimy-x);
  plot (dimx-y) (dimy+x);
  plot (dimx-x) (dimy+y);;

let circle r dimx dimy n =
  for i = 0 to truncate (n *. atan 1.0) do
    plot_sym_points 
    ((truncate (r *. cos (float i /. n))), (truncate (r *. sin (float i /. n)))) 
    dimx dimy 
  done;;

circle 300. 700 330 10.;;
circle 30. 700 330 100.;;
circle 310. 700 330 100.;;