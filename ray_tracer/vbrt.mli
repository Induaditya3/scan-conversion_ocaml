type point = { x : float; y : float; z : float; }
type sphere = { r : float; c : point; color : int * int * int; }
type light = { k : char; i : float; v : point option; }
val bare : 'a option -> 'a
val sub3 : point -> point -> point
val add3 : point -> point -> point
val scale : float -> point -> point
val sproduct : point -> point -> float
val norm : point -> float
val n_sphere : point -> sphere -> point
val til_inner : point -> point -> light list -> float -> float
val til : point -> point -> light list -> float
val p1 : point
val p2 : point
val quad : float -> float -> float -> float option * float option
val clamp : float -> int
val myrgb : int * int * int -> float -> 'a
val sphere_color : sphere option -> float -> 'a
val plotc : int -> int -> 'a -> 'b
val g_to_viewport : int -> int -> point
val intersect_sphere :
  point -> point -> sphere -> float option * float option
val rtx_inner :
  point ->
  point ->
  float ->
  float ->
  sphere list -> light list -> sphere option ref -> float option ref -> 'a
val rtx : point -> point -> float -> float -> sphere list -> light list -> 'a
