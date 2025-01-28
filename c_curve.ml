#use "topfind";;
#use "float.ml";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "C curve";;

let rec cn x y len alpha n =
  let a = x +. len *. cos alpha in 
  let b = y +. len *. sin alpha in 
  if n = 0 then 
    draw_poly_line [|(truncate x,truncate y);(truncate a,truncate b)|]
  else
    begin
      cn x y (len /. sqrt 2.) (alpha +. pi /. 4.) (n-1);
      cn (x +. len /. (sqrt 2.) *. cos (alpha +. pi /. 4.)) (y +. len /. (sqrt 2.) *. sin (alpha +. pi /. 4.)) (len /. sqrt 2.) (alpha -. pi /. 4. ) (n-1)
    end;;

cn 600. 190. 300. (pi /. 2.) 15;;
(* for i = 0 to 20 do 
  cn 600. 190. 300. (pi /. 2.) i;
  if i <> 20 then   clear_graph ();
  Printf.printf "\nDONE %i\n" i
done;; *)
