module Boid exposing (Boid, boid, update, wrapBoidPosition)

import Basics exposing (degrees)
import Math.Vector2 exposing (Vec2, vec2, getX, getY, toTuple)
import Collage exposing (Form, filled, move, polygon, rotate)
import Color exposing (white)
import Utils exposing (wrapPosition)


type alias Boid =
    { position : Vec2
    , angle : Int
    , speed : Int
    }


boid : Boid -> Form
boid { position, angle } =
    polygon
        [ ( 0, 0 )
        , ( 0 - 4, 0 + 5 )
        , ( 0 + 10, 0 )
        , ( 0 - 4, 0 - 5 )
        ]
        |> filled white
        |> rotate (degrees (toFloat angle))
        |> move (toTuple position)


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
            wrapPosition
                boid.position
                (vec2 (toFloat width) (toFloat height))
    }


update : ( Int, Int ) -> Boid -> Boid
update boundaries { position, angle, speed } =
    let
        x =
            getX position

        y =
            getY position

        nextBoid =
            Boid
                (vec2
                    (xDirection x (toFloat angle) speed + x)
                    (yDirection y (toFloat angle) speed + y)
                )
                angle
                speed
    in
        nextBoid
            |> wrapBoidPosition boundaries
