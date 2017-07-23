module Main exposing (main)

import Boid exposing (Boid, boid)
import Collage exposing (collage)
import Element exposing (toHtml)
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (style)
import Task exposing (..)
import Time exposing (Time, every)
import Types exposing (Point)
import Utils exposing (addAxis, wrapPosition)
import Window exposing (Size, size)


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
    , world : ( Int, Int )
    }


type Msg
    = Tick Time
    | UpdateWorld Size


init : ( Model, Cmd Msg )
init =
    ( { boid = Boid ( 50, 50 ) 180
      , world = ( 0, 0 )
      }
    , Task.perform UpdateWorld size
    )


wrapBoidPosition : Boid -> ( Int, Int ) -> Boid
wrapBoidPosition boid ( width, height ) =
    { boid
        | position =
            wrapPosition
                boid.position
                ( toFloat width, toFloat height )
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            let
                nextBoidWithoutRestrictions =
                    Boid.update model.boid

                nextBoid =
                    wrapBoidPosition
                        nextBoidWithoutRestrictions
                        model.world
            in
                ( { model
                    | boid = nextBoid
                  }
                , Cmd.none
                )

        UpdateWorld size ->
            ( { model
                | world = ( size.width, size.height )
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ every 16 Tick
        ]


view : Model -> Html msg
view { boid, world } =
    let
        ( width, height ) =
            world
    in
        div
            [ style
                [ ( "backgroundColor", "black" )
                , ( "color", "white" )
                ]
            ]
            [ div [] [ Html.text (toString boid) ]
            , div [] [ Html.text ("Size: " ++ (toString world)) ]
            , collage
                width
                height
                ([ Boid.boid boid
                 ]
                    |> addAxis width height
                )
                |> toHtml
            ]
