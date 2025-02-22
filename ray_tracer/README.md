# Very Basic Ray Tracer (in progress)

## coordinate system

In OCaml standard graphics library, origin of drawing window is situated at bottom left corner of it. For convenience we want it in middle of the window. So we need wrapper function 

```Ocaml
let plotc x' y' color =
    let x,y = x' + (size_x ()) / 2, y' + (size_y ()) / 2 in 
    set_color (rgb color);
    plot x y;;
```
It translates origin to middle of the graphics window.

## colors

We use additive color model (RGB model), obviously.
With each color channel represented by 8 bit positive integer. So, range is [0,255]. We can treat triplet of RGB values as a vector. Then, adding two colors together we get new color. And mutiplying a color by scalar just increases brightness , i.e.

$$k (r, g, b) = (kr, kg, kb) $$

There is a chance that any of channel value goes out of range [0,255], while manipulating colors. We can handle this as follows:

Suppose there is channel value $x$
- If $x > 255 $,
 then we set $x = 255$
- If $x <0$ then we set $x = 0$ 

This is called **clamping**.

## scene

The scene is simply set of objects that we want render on the screen.

For representing objects in a scene, we need use 3D coordinate system which uses real numbers to represent  continous values, then map that to discrete 2D graphics window while drawing.

![3D cordinate](./figs/3Dcoodinate.png)

It's clear from figure which axes point in which direction.

Viewing position from where we look at the scene is called **camera position**. We assume that camera is fixed and occupies single point in space which often will be origin $O(0,0,0)$. 

**Camera orientation** is the direction in which camera points, or from where rays enter the camera. We will assume camera orientation to be $Z_+$, positive z axis. 

Frame has dimension $V_w$ and $V_h$ and is frontal to camera (perpendicular to camera orientation irrespective of camera position, in our case perpendicular to $Z_+$ ) and $d$ distance away from camera.
Technically, it's called **viewport**.

Angle visible from *camera* is called **field of view** (FOV). It depends on distance $d$ from camera to viewport and dimensions of viewport $V_w$ and $V_h$. 

In our case, we assume 

$$V_w = V_h = d = 1 \implies FOV \approx 53 \degree$$ 

We will represent coordinate of viewport as $(V_x,V_y)$ in worldly units and graphics window as $(G_x,G_y)$ in pixels.
So conversion is 

$$V_x = G_x \times \frac{V_w}{G_w}$$

$$V_y = G_y \times \frac{V_h}{G_h}$$

where $G_w$ and $G_h$ are maximum width and height of graphics window, respectively.

```OCaml
let g_to_viewport gx gy =
    let vw = 1. in (* setting width and height of viewport *)
    let vh = 1. in
    let vx = (float gx) .* vw /. float (size_x ()) in 
    let vy = (float gy) .* vh /. float (size_y ()) in 
    let d = 1 in (* z coordinate of viewport *)
    vx, vy, d;;
```

But we know that viewport is in the 3D space, so it also has $V_z = d$ for every point on this viewport (in math term called *projection plane*).

So, for every pixel  $(G_x, G_y)$ on graphics window we can calculate the corresponding $(V_x,V_y,V_z)$ of viewport.

## rays

The rays are just the straight lines emanating from origin $O$ and passing through various point of viewport and finally intersecting the objects of the scene.

We will represent straight line using parametric form as 

$$P = O + t(V-O) $$

Here
- $P$ is any point on the line
- $O$ is the origin (where camera is positioned)
- $V$ is any point on the viewport
- $t$ is the parameter, $-\infty < t < \infty$ 

We vary $t$ to get various point on the straight line.

Also note that
- $t < 0$, then $P$ is behind the camera
- $0 \leq t \leq 1$ , then $P$ lies between camera and viewport
- $ t > 1 $ , then $P$ is in front of viewport 

## sphere 

It is the simplest geometric object and will use as a object of the scene.

We represent sphere as 

$$\langle P - C, P - C  \rangle = r^2 $$

Here
- P is point on the surface of sphere
- C is the center of the sphere
- r is the radius of the sphere

## rays intersect objects in scene

Currently, we just have sphere.

### intersection of straight line and sphere

Let $P$ be point of intersection then it is common point to both ray and sphere.

Equation of ray is 

$$P = O + t \vec{D} $$

where $ \vec{D} = V - O $ is the direction of ray

Equation of sphere is

$$ \langle P - C, P - C  \rangle = r^2 $$

So we can substitute value of $P$ in equation of sphere we get

(Before we get into calculation, we need remmember that, for vectors defined over real numbers, $ \langle \vec{a}, \vec{b} \rangle = \langle \vec{b}, \vec{a} \rangle $ . In general case, one would be complex conjugate of the other. )

$$ \langle O + t \vec{D} - C , O + t \vec{D} - C \rangle = r^2 $$

$$\langle t \vec{D} + \vec{CO}, t \vec{D} + \vec{CO} \rangle = r^2 $$

$$\langle t \vec{D} + \vec{CO}, t \vec{D} \rangle + \langle t \vec{D} + \vec{CO}, \vec{CO} \rangle= r^2 
$$

$$ \langle t \vec{D}, t \vec{D} \rangle + \langle t \vec{D} , \vec{CO} \rangle + \langle \vec{CO} , t \vec{D} \rangle + \langle \vec{CO} , \vec{CO} \rangle= r^2 $$

Finally

$$at^2 + bt + c = 0 $$

where 
- $ a = \| \vec{D} \| $
- $ b = 2 \langle \vec{D}, \vec{CO} \rangle $
- $ c = \| \vec{CO} \| - r^2 $

This makes sense because ray can intersect a sphere either at 0, 1 or 2 points.

We can now find value of $t$ from same old quadratic formula.

$$ t_{1,2} = \frac{-b \pm \sqrt{b^2-4ac}}{2a} $$

After finding value of $t$ we can substitute in equation of ray to find point $P$. We should be careful to take  closest point $P$ (the one which is visible to camera) and for which $t > 1$ (objects are in front of viewport).

## rendering

We iterate over every pixels of graphics window and find corresponding point on the viewport and shoot out a ray from camera through that point on viewport. If that ray intersect an object in the scene then we calculate the color and then set that pixel to that color.

```Ocaml
let o = (0,0,0);; (* the origin O*)
let gw, gh = size_x (), size_y ();; (*max width and height of graphics window *)
for x = -gw/2 to gw/2 do 
    for y = -gh/2 to gh/2 do 
        let v = g_to_viewport x y in
        let c = rtx o v 1 infty in 
        plotc x y c
    done;
done;;
```