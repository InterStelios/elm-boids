module Main exposing (main)

import Boid exposing (Boid, boid)
import Collage exposing (collage)
import Element exposing (toHtml)
import Html exposing (Html, div, text)
import Time exposing (Time, every)
import Types exposing (Point)
import Utils exposing (addAxis)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { boid : { position : Point, angle : Float }
    , world : Point
    }


type Msg
    = Tick Time


init : ( Model, Cmd Msg )
init =
    ( { boid = Boid ( 50, 50 ) 180
      , world = ( 500, 500 )
      }
    , Cmd.none
    )


wrapBoidPosition : ( Float, Float ) -> Boid -> Boid
wrapBoidPosition world nextBoid =
    let
        ( nextX, nextY ) =
            nextBoid.position

        ( worldX, worldY ) =
            world
    in
        if (nextX * 2 > worldX) then
            ({ nextBoid
                | position = ( (worldX / -2), nextY )
             }
            )
        else if (nextX * 2 < -worldX) then
            ({ nextBoid
                | position = ( (worldX / 2), nextY )
             }
            )
        else if (nextY * 2 > worldY) then
            ({ nextBoid
                | position = ( nextX, (worldY / -2) )
             }
            )
        else if (nextY * 2 < -worldY) then
            ({ nextBoid
                | position = ( 0, worldY / 2 )
             }
            )
        else
            nextBoid


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            let
                nextBoidAttrs =
                    Boid.update model.boid

                nextBoid =
                    wrapBoidPosition model.world nextBoidAttrs
            in
                ( { model
                    | boid = nextBoid
                  }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions _ =
    every 16 Tick


view : Model -> Html msg
view { boid, world } =
    let
        ( width, height ) =
            world
    in
        div []
            [ Html.text (toString boid)
            , collage
                (round width)
                (round height)
                ([ Boid.boid boid
                 ]
                    |> addAxis (round width) (round height)
                )
                |> toHtml
            ]
