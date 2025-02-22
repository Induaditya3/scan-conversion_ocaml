type point = { x : float; y : float; z : float; }
type sphere = { r : float; c : point; color : int * int * int; }
val sub3 : point -> point -> point
val sproduct : point -> point -> float
val p1 : point
val p2 : point
val quad : float -> float -> float -> float option * float option
val myrgb : 'a * 'b * 'c -> 'd
val sphere_color : sphere option -> 'a
val plotc : int -> int -> 'a * 'b * 'c -> 'd
val g_to_viewport : int -> int -> point
val intersect_sphere :
  point -> point -> sphere -> float option * float option
val rtx :
  point ->
  point ->
  float ->
  float -> sphere list -> sphere option ref -> float option ref -> 'a
