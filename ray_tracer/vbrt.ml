#use "topfind";;
#require "graphics";;
open Graphics;;

open_graph "";;
resize_window 1366 768;;
set_window_title "ray tracer";;

type point = 
  {
    x : float;
    y : float;
    z : float
  };;

type sphere = 
  {
    r : float;
    c : point;
    color : int * int * int
  };;

let sub3 p1 p2 = 
  {x = p1.x -. p2.x; y = p1.y -. p2.y; z = p1.z -. p2.z};;

let sproduct p1 p2 =
  p1.x *. p2.x +. p1.y *. p2.y +. p1.z *. p2.z;;

let p1 = {x=1. ;y= 2. ;z=3. };;

let p2 = {x=2. ;y= 4. ;z=6. };;

let quad a b c = 
  let d = b *. b -. 4. *. a *. c in 
  if d >= 0. then 
    Some ((-. b +. sqrt d) /. (2. *. a)), Some ((-. b -. sqrt d) /. (2. *. a))
  else
    None, None;;

let myrgb (x,y,z) =
  rgb x y z;;

let sphere_color s =
  match s with 
  Some s -> myrgb s.color
  | None -> rgb 255 255 255;; (*Background color is white*)

let plotc x' y' color =
  let x,y = x' + (size_x () / 2), y' + (size_y () / 2) in 
  set_color ( color);
  plot x y;;

(* setting width vw and height vh of viewport *)
(* z coordinate of viewport is d *)
let g_to_viewport gx gy =
  let vwidth = 1. in 
  let vheight = 1. in
  let vx = float gx *. vwidth  /. float (size_x ()) in 
  let vy = float gy *. vheight  /. float (size_y ()) in 
  let d = 1. in 
  {x = vx;y = vy; z = d};;

let intersect_sphere o v s =
  let d = sub3 v o in 
  let co = sub3 s.c o in 
  let a = sproduct d d in 
  let b = 2. *. sproduct d co in 
  let c = sproduct co co -. s.r *. s.r in 
  quad a b c;;

(* closest_sphere initially be   ref None *)
(* closest_t should intially be  ref (Some infinity)*)
let rec rtx o v tmin tmax sl closest_sphere closest_t =
  match sl with
  s1::sr -> 
    let t1, t2 = intersect_sphere o v s1 in 
    if (t1 <= Some tmin && t1 <= Some tmax) && t1 <= !closest_t then
      begin
      closest_t := t1;
      closest_sphere := Some s1
      end;
    if (t2 <= Some tmin && t2 <= Some tmax) && t2 <= !closest_t then 
      begin
      closest_t := t2; 
      closest_sphere := Some s1
      end;
    rtx o v tmin tmax sr closest_sphere closest_t
  |[] ->  
      sphere_color !closest_sphere;;

