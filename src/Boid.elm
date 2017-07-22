module Boid exposing (Boid, boid, update)

import Basics exposing (degrees)
import Collage exposing (Form, filled, move, polygon, rotate)
import Color exposing (black)
import Types exposing (Point)


type alias Boid =
    { position : Point
    , angle : Float
    }


boid : Boid -> Form
boid { position, angle } =
    polygon
        [ ( 0, 0 )
        , ( 0 - 4, 0 + 5 )
        , ( 0 + 10, 0 )
        , ( 0 - 4, 0 - 5 )
        ]
        |> filled black
        |> rotate (degrees angle)
        |> move position


xDirection : Float -> Float -> Float -> Float
xDirection x angle step =
    step
        * (angle
            |> degrees
            |> cos
          )


yDirection : Float -> Float -> Float -> Float
yDirection y angle step =
    step
        * (angle
            |> degrees
            |> sin
          )


update : Boid -> Boid
update { position, angle } =
    let
        ( x, y ) =
            position

        speed =
            1
    in
        Boid
            ( xDirection x angle speed + x
            , yDirection y angle speed + y
            )
            angle
