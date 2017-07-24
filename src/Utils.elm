module Utils exposing (addAxis, wrapPosition)

import Collage exposing (Form, dotted, path, traced)
import Color exposing (white)
import Math.Vector2 exposing (Vec2, getY, getX, setX, setY)


addAxis : Int -> Int -> List Form -> List Form
addAxis width height eles =
    eles ++ [ xAxis width, yAxis height ]


xAxis : Int -> Form
xAxis width =
    path
        [ ( toFloat -width / 2, 0 )
        , ( toFloat width / 2, 0 )
        ]
        |> traced (dotted white)


yAxis : Int -> Form
yAxis height =
    path
        [ ( 0, toFloat -height / 2 )
        , ( 0, toFloat height / 2 )
        ]
        |> traced (dotted white)


wrapPosition : Vec2 -> Vec2 -> Vec2
wrapPosition position worldCoordinates =
    let
        nextX =
            getX position

        nextY =
            getY position

        worldX =
            getX worldCoordinates

        worldY =
            getY worldCoordinates
    in
        if (nextX * 2 > worldX) then
            setX (worldX / -2) position
        else if (nextX * 2 < -worldX) then
            setX (worldX / 2) position
        else if (nextY * 2 > worldY) then
            setY (worldY / -2) position
        else if (nextY * 2 < -worldY) then
            setY (worldY / 2) position
        else
            position
