module Boid exposing (Boid, boid, update)

import Collage exposing (..)
import Color exposing (..)
import Basics


type alias Point =
    ( Float, Float )


type alias Boid =
    { position : Point
    , angle : Int
    }


boid : Point -> Form
boid ( x, y ) =
    polygon
        [ ( x, y )
        , ( x + 20, y - 25 )
        , ( x, y + 50 )
        , ( x - 20, y - 25 )
        ]
        |> filled black


update : Boid -> Point
update { position, angle } =
    let
        ( x, y ) =
            position

        speed =
            10
    in
        ( ((speed * angle |> toFloat |> radians |> cos ) + x)
        , (speed * angle |> toFloat |> radians |> sin) + y
        )
