#use "rasterizer.ml"

let main () =
  draw_line (-50, -200) (60, 240) red ;;
  (* draw_poly [|(-50 + (size_x ()) / 2, -200 + (size_y ()) / 2) ;(60 + (size_x ()) / 2, 240 + (size_y ()) / 2)|] *)

let _ = main ()