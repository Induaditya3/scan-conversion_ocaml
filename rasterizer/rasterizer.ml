#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "rasterizer";;

(* two dimensional point *)
type point_2 =
  {
    x : float;
    y : float
  }

(* shifting origin to center of graphics window and setting color *)
let plotc x' y' color =
  let x,y =  truncate x' + (size_x ()) / 2, truncate y' + (size_y ()) / 2 in 
  set_color color;
  plot x y

(* to generate a list of dependents d corresponding to independents i between i0 and i1 *)
(* m is the slope *)
(* ld is the list of dependents *)
let rec interpolate_inner i0 d i1 m ld =
  if i0 = i1 then ld else interpolate_inner (i0 +. 1.) (d+.m)  i1 m ((d+.m) :: ld)

(* wrapper function *)
let interpolate i0 d0 i1 d1 = 
  if i0 = i1 then [d0]
    else 
      (  let m = (d1 -. d0) /. (i1 -. i0) in
      interpolate_inner i0 d0 i1 m [] )

let rec draw_inner i0 ld color w =
  match ld, w with 
  h::t , 'x'-> plotc i0 h color; draw_inner (i0-.1.)  t color w
  | h::t , 'y'-> plotc h i0 color; draw_inner (i0-.1.)  t color w
  | _ -> ()

let draw_line {x=x0;y=y0} {x=x1;y=y1} color =
  if abs_float (x1 -. x0) > abs_float (y1 -. y0) then
    (* line makes angle of less than 45 with horizontal axis *)
    begin
      if x0 < x1 then 
        (let ly = interpolate x0 y0 x1 y1 in 
        draw_inner x1 ly color 'x')
      else
        (let ly = interpolate x1 y1 x0 y0 in 
        draw_inner x0 ly color 'x')
    end
  else
    (* line makes angle of 45 or more with horizontal axis *)
    begin
      if y0 < y1 then 
        (let lx = interpolate y0 x0 y1 x1 in 
        draw_inner y1 lx color 'y')
      else
        (let lx = interpolate y1 x1 y0 x0 in 
        draw_inner y0 lx color 'y')
    end