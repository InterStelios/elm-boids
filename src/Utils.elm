module Utils exposing (addAxis, wrapPosition)

import Collage
import Color
import Math.Vector2 as V2


addAxis : Int -> Int -> List Collage.Form -> List Collage.Form
addAxis width height eles =
    eles ++ [ xAxis width, yAxis height ]


xAxis : Int -> Collage.Form
xAxis width =
    Collage.path
        [ ( toFloat -width / 2, 0 )
        , ( toFloat width / 2, 0 )
        ]
        |> Collage.traced (Collage.dotted Color.white)


yAxis : Int -> Collage.Form
yAxis height =
    Collage.path
        [ ( 0, toFloat -height / 2 )
        , ( 0, toFloat height / 2 )
        ]
        |> Collage.traced (Collage.dotted Color.white)


wrapPosition : V2.Vec2 -> V2.Vec2 -> V2.Vec2
wrapPosition position worldCoordinates =
    let
        nextX =
            V2.getX position

        nextY =
            V2.getY position

        worldX =
            V2.getX worldCoordinates

        worldY =
            V2.getY worldCoordinates
    in
        if (nextX * 2 > worldX) then
            V2.setX (worldX / -2) position
        else if (nextX * 2 < -worldX) then
            V2.setX (worldX / 2) position
        else if (nextY * 2 > worldY) then
            V2.setY (worldY / -2) position
        else if (nextY * 2 < -worldY) then
            V2.setY (worldY / 2) position
        else
            position
