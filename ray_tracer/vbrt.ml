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

(* type for sphere *)
(* r - radius *)
(* c - center *)
(* color - color of the sphere *)
(* s - shininess of sphere *)
type sphere = 
  {
    r : float;
    c : point;
    color : int * int * int;
    s : int
  };;

(* type for light *)
(* kind of light is represented by k field - *)
(* p - for point source *)
(* d - for directional light *)
(* a - for ambient source *)
type light = 
  {
    k : char;
    i : float;
    v : point option
  }

let bare (Some p) = p;;
let sub3 p1 p2 = 
  {x = p1.x -. p2.x; y = p1.y -. p2.y; z = p1.z -. p2.z};;

let add3 p1 p2 =
  {x = p1.x +. p2.x; y = p1.y +. p2.y; z = p1.z +. p2.z};;

let scale k {x;y;z} =
  {x= k *. x;y = k *. y;z = k *. z};;

let sproduct p1 p2 =
  p1.x *. p2.x +. p1.y *. p2.y +. p1.z *. p2.z;;

(* norm of a vector *)
let norm v = 
  sqrt (sproduct v v);;

(* normal of sphere at point P on the surface *)
let n_sphere p s =
  sub3 p s.c ;;

(* total light intensity after reflection *)
let rec til_inner normal p o s light_l intensity = 
  match light_l with 
  {k;i;v}::t -> 
    let c_intensity = ref 0. in
    if k = 'a' then c_intensity := i +. !c_intensity 
    else 
      begin
        let l = ref {x=0.;y=0.;z=0.} in
        (if k = 'p' then  l := (sub3 p (bare v)) else  l := bare v);
        let nl = sproduct normal !l in 
        let unitnormal = scale (norm normal) normal in 
        let reflected = sub3 (scale (2. *. sproduct !l unitnormal) unitnormal) !l in 
        let view = sub3 o p in 
        let rv = sproduct reflected view in 
        (if rv > 0. && s > 0 then 
          c_intensity := !c_intensity +. i *. (rv /. (norm reflected *. norm view)) ** (float s));
        (if nl > 0. then 
          c_intensity := !c_intensity +. i *. nl /. (norm !l *. norm normal))
      end;
    til_inner normal p o s t (intensity +. !c_intensity)
  | _ -> intensity;;

let til normal p o s light_l = til_inner normal p o s light_l 0.;;
let p1 = {x=1. ;y= 2. ;z=3. };;

let p2 = {x=2. ;y= 4. ;z=6. };;

let quad a b c = 
  let d = b *. b -. 4. *. a *. c in 
  if d >= 0. then 
    Some ((-. b +. sqrt d) /. (2. *. a)), Some ((-. b -. sqrt d) /. (2. *. a))
  else
    None, None;;

(* clamping function *)
let clamp x =
  if x > 255. then 255
  else if x < 0. then 0
  else truncate x;;

let myrgb (x,y,z) intensity =
  let xi = float x *. intensity in 
  let yi = float y *. intensity in 
  let zi = float z *. intensity in 
  rgb (clamp xi) (clamp yi) (clamp zi);;

let sphere_color sphere intensity =
  match sphere with 
  Some s -> myrgb s.color intensity
  | None -> rgb 255 255 255;; (*Background color is white*)

let plotc x' y' color =
  let x,y =  x' + (size_x ()) / 2, y' + (size_y ()) / 2 in 
  set_color ( color);
  plot x y;;

(* setting width vw and height vh of viewport *)
(* z coordinate of viewport is d *)
let g_to_viewport gx gy =
  let vwidth = 1. in 
  let vheight = 1. in
  let vx = (float gx *. vwidth)  /. float (size_x ()) in 
  let vy = (float gy *. vheight)  /. float (size_y ()) in 
  let d = 1. in 
  {x = vx;y = vy; z = d};;

let intersect_sphere o v s =
  let d = sub3 v o in 
  let co = sub3 o s.c in 
  let a = sproduct d d in 
  let b = 2. *. sproduct d co in 
  let c = sproduct co co -. (s.r *. s.r) in 
  quad a b c;;

(* closest_sphere initially be   ref None *)
(* closest_t should intially be  ref (Some infinity)*)
let rec rtx_inner o v tmin tmax sl ll closest_sphere closest_t =
  match sl with
  s1::sr -> 
    let t1, t2 = intersect_sphere o v s1 in 
    if (t1 >= Some tmin && t1 <= Some tmax) && t1 <= !closest_t then
      begin
      closest_t := t1;
      closest_sphere := Some s1
      end;
    if (t2 >= Some tmin && t2 <= Some tmax) && t2 <= !closest_t then 
      begin
      closest_t := t2; 
      closest_sphere := Some s1
      end;
    rtx_inner o v tmin tmax sr ll closest_sphere closest_t
  |[] ->  
    let intensity = ref 0. in 
    (match !closest_sphere, !closest_t with 
    Some s, Some t -> 
      let d = sub3 v o in
      let p = add3 o (scale t d) in 
      let normal = sub3 p s.c in
      intensity := til normal p o s.s ll
      |_, _ -> ()); 
      sphere_color !closest_sphere !intensity;;

let rtx o v tmin tmax sl ll = rtx_inner o v tmin tmax sl ll (ref None) (ref (Some infinity));;