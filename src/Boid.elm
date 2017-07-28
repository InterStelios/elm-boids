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


xDirection : Float -> Float -> Int -> Float
xDirection x angle step =
    (toFloat step)
        * (angle
            |> degrees
            |> cos
          )


yDirection : Float -> Float -> Int -> Float
yDirection y angle step =
    (toFloat step)
        * (angle
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
                    (xDirection x (toFloat angle) speed + x)
                    (yDirection y (toFloat angle) speed + y)
                )
                angle
                speed
                colour
    in
        nextBoid
            |> wrapBoidPosition boundaries
