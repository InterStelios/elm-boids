module Boid exposing (Boid, boid, update, wrapBoidPosition)

import Basics exposing (degrees)
import Collage exposing (Form, filled, move, polygon, rotate)
import Color exposing (white)
import Types exposing (Point)
import Utils exposing (wrapPosition)


type alias Boid =
    { position : Point
    , angle : Float
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
        |> rotate (degrees angle)
        |> move position


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
                ( toFloat width, toFloat height )
    }


update : ( Int, Int ) -> Boid -> Boid
update boundaries { position, angle, speed } =
    let
        ( x, y ) =
            position

        nextBoid =
            Boid
                ( xDirection x angle speed + x
                , yDirection y angle speed + y
                )
                angle
                speed
    in
        nextBoid
            |> wrapBoidPosition boundaries
