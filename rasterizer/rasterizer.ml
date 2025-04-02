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

(* temporary data structure for storing hue value as h associated with a point *)
type point_s =
  {
    x : float;
    y : float;
    h : float
  }
(* shifting origin to center of graphics window and setting color *)
let plotc x' y' color =
  let x,y =  x' + ((size_x ()) / 2), y' + ((size_y ()) / 2) in 
  set_color color;
  plot x y

(* to generate a list of dependents d corresponding to independents i between i0 and i1 *)
(* m is the slope *)
(* ld is the list of dependents *)
let rec interpolate_inner i0 d i1 m ld =
  if i0 > i1 then ld else interpolate_inner (i0 +. 1.) (d+.m)  i1 m ((d+.m) :: ld)

(* wrapper function *)
let interpolate i0 d0 i1 d1 = 
  if i0 = i1 then [d0]
    else 
      (  let m = (d1 -. d0) /. (i1 -. i0) in
      d0 :: List.rev (interpolate_inner i0 d0 i1 m [])@ [d1] )

(* helper function for plotting points of list based on whether x is independent or y  *)
let rec draw_inner i0 ld color w =
  match ld, w with 
  h::t , 'x'-> plotc (truncate i0) (truncate h) color; draw_inner (i0+.1.)  t color w
  | h::t , 'y'-> plotc (truncate h) (truncate i0) color; draw_inner (i0+.1.)  t color w
  | _ -> ()

let draw_line {x=x0;y=y0} {x=x1;y=y1} color =
  if abs_float (x1 -. x0) > abs_float (y1 -. y0) then
    (* line makes angle of less than 45 with horizontal axis *)
    begin
      if x0 < x1 then 
        (let ly = interpolate x0 y0 x1 y1 in 
        draw_inner x0 ly color 'x')
      else
        (let ly = interpolate x1 y1 x0 y0 in 
        draw_inner x1 ly color 'x')
    end
  else
    (* line makes angle of 45 or more with horizontal axis *)
    begin
      if y0 < y1 then 
        (let lx = interpolate y0 x0 y1 x1 in 
        draw_inner y0 lx color 'y')
      else
        (let lx = interpolate y1 x1 y0 x0 in 
        draw_inner y1 lx color 'y')
    end

(* draws borders of triangle *)
let outline_triangle a b c color =
  draw_line a b color;
  draw_line b c color;
  draw_line c a color

(* helper function for drawing horizontal lines from lists of abcissas *)
let fill_triangle_inner left_abcissa right_abcissa lower_ordinate higher_ordinate color =
  for y =  lower_ordinate to  higher_ordinate do
    let left = List.nth left_abcissa (y - lower_ordinate ) in 
    let right = List.nth right_abcissa (y - lower_ordinate ) in 
    for x = left to right do 
      plotc x y color;      
    done;
  done

let cmp a b =
  truncate (a.y -. b.y)

let fill_triangle a b c color =
  let sorted = List.sort cmp [a;b;c] in 
  match sorted with 
  [p0;p1;p2] -> 
    let lx = List.map truncate (interpolate p0.y p0.x p2.y p2.x) in 
    let lx2 = List.map truncate (List.tl (interpolate p0.y p0.x p1.y p1.x) @  interpolate p1.y p1.x p2.y p2.x) in 
    if List.nth lx (List.length lx / 2) < List.nth lx2 (List.length lx2 / 2) then 
      fill_triangle_inner lx lx2 (truncate p0.y) (truncate p2.y) color
    else
      fill_triangle_inner lx2 lx (truncate p0.y) (truncate p2.y) color
  | _ -> ()

let shade_triangle_inner (left_abcissa, left_h) (right_abcissa, right_h) lower_y higher_y (r,g,b) =
  for y = lower_y to higher_y do
    let left = List.nth left_abcissa (y - lower_y) in 
    let right = List.nth right_abcissa (y - lower_y) in 
    let left_h1 = List.nth left_h (y - lower_y) in 
    let right_h1 = List.nth right_h (y - lower_y) in 
    let interpolated_h = interpolate left left_h1 right right_h1 in 
    for x = (truncate left) to (truncate right) do
      begin 
        let h = List.nth interpolated_h (x - (truncate left)) in 
        let color = rgb (truncate (float r *. h)) (truncate (float g *. h)) (truncate (float b *. h)) in 
        plotc x y color
      end
    done;
  done;;
    
let shade_triangle a1 a2 a3 (r,g,b) =
  let sorted = List.sort cmp [a1;a2;a3] in 
  match sorted with 
  [p0;p1;p2] -> 
    let lx = (interpolate p0.y p0.x p2.y p2.x) in
    let hy =  (interpolate p0.y p0.h p2.y p2.h) in 
    let lx2 =  (interpolate p0.y p0.x p1.y p1.x @ (List.tl (interpolate p1.y p1.x p2.y p2.x))) in
    let hy2 =  (interpolate p0.y p0.h p1.y p1.h @ (List.tl (interpolate p1.y p1.h p2.y p2.h))) in
    if List.nth lx (List.length lx / 2) < List.nth lx2 (List.length lx2 / 2) then 
      shade_triangle_inner (lx, hy) (lx2, hy2) (truncate p0.y) (truncate p2.y) (r,g,b)
    else
      shade_triangle_inner (lx2, hy2) (lx, hy) (truncate p0.y) (truncate p2.y) (r,g,b)
  | _ -> ()