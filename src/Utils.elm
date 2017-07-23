module Utils exposing (addAxis, wrapPosition)

import Collage exposing (Form, dotted, path, traced)
import Color exposing (black)
import Types exposing (Point)


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


wrapPosition : Point -> Point -> Point
wrapPosition position worldCoordinates =
    let
        ( nextX, nextY ) =
            position

        ( worldX, worldY ) =
            worldCoordinates
    in
        if (nextX * 2 > worldX) then
            ( (worldX / -2), nextY )
        else if (nextX * 2 < -worldX) then
            ( (worldX / 2), nextY )
        else if (nextY * 2 > worldY) then
            ( nextX, (worldY / -2) )
        else if (nextY * 2 < -worldY) then
            ( 0, worldY / 2 )
        else
            position
