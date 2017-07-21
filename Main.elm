module Main exposing (..)

import Html exposing (..)
import Element exposing (..)
import Collage exposing (..)
import Time exposing (..)
import Environment exposing (addAxis)
import Boid exposing (Boid, boid)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { boid : {position: Point, angle: Int}
    , world : ( Int, Int )
    }


type alias Point =
    ( Float, Float )


type Msg
    = Tick Time


init : ( Model, Cmd Msg )
init =
    ( { boid = { position = ( 0, 0 ), angle= 90}
      , world = ( 750, 500 )
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model
                | boid = {
                    angle= model.boid.angle,
                    position = Boid.update model.boid.position
                }
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every second Tick


view : Model -> Html.Html msg
view { boid } =
    div []
        [ Html.text (toString boid)
        , collage
            750
            500
            ([ Boid.boid boid.position
             ]
                |> addAxis 750 500
            )
            |> toHtml
        ]
