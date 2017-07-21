module Environment exposing (addAxis)

import Collage exposing (..)
import Color exposing (..)


addAxis : Int -> Int -> List Form -> List Form
addAxis width height eles =
    eles ++ [ xAxis width, yAxis height ]


xAxis : Int -> Form
xAxis width =
    path
        [ ( toFloat -width / 2, 0 )
        , ( toFloat width / 2, 0 )
        ]
        |> traced (dotted black)


yAxis : Int -> Form
yAxis height =
    path
        [ ( 0, toFloat -height / 2 )
        , ( 0, toFloat height / 2 )
        ]
        |> traced (dotted black)
