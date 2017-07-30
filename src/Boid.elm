module Boid exposing (Boid, boid, update, wrapBoidPosition)

import Basics
import Math.Vector2 as V2
import Collage
import Color exposing (Color)
import Utils


type alias Boid =
    { position : V2.Vec2
    , angle : Int
    , speed : Int
    , colour : Color
    }


boid : Boid -> Collage.Form
boid { position, angle, colour } =
    Collage.polygon
        [ ( 0, 0 )
        , ( 0 - 4, 0 + 5 )
        , ( 0 + 10, 0 )
        , ( 0 - 4, 0 - 5 )
        ]
        |> Collage.filled colour
        |> Collage.rotate (Basics.degrees (toFloat angle))
        |> Collage.move (V2.toTuple position)


xDirection : Int -> Int -> Float
xDirection angle step =
    (toFloat step)
        * (angle
            |> toFloat
            |> degrees
            |> cos
          )


yDirection : Int -> Int -> Float
yDirection angle step =
    (toFloat step)
        * (angle
            |> toFloat
            |> degrees
            |> sin
          )


wrapBoidPosition : ( Int, Int ) -> Boid -> Boid
wrapBoidPosition ( width, height ) boid =
    { boid
        | position =
            Utils.wrapPosition
                boid.position
                (V2.vec2 (toFloat width) (toFloat height))
    }


update : ( Int, Int ) -> Boid -> Boid
update boundaries { position, angle, speed, colour } =
    let
        x =
            V2.getX position

        y =
            V2.getY position

        nextBoid =
            Boid
                (V2.vec2
                    (xDirection angle speed + x)
                    (yDirection angle speed + y)
                )
                angle
                speed
                colour
    in
        nextBoid
            |> wrapBoidPosition boundaries
