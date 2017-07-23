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
    , world : Point
    , env : { window : Size }
    }


type Msg
    = Tick Time
    | UpdateSize Size


init : ( Model, Cmd Msg )
init =
    ( { boid = Boid ( 50, 50 ) 180
      , world = (0, 0)
      , env = { window = Size 0 0 }
      }
    , Task.perform UpdateSize size
    )


wrapBoidPosition : Boid -> Point -> Boid
wrapBoidPosition boid worldCoordinates =
    { boid
        | position = wrapPosition boid.position worldCoordinates
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

        UpdateSize size ->
            let
                { env } =
                    model

                newEnv =
                    { env | window = size }
            in
                ( { model
                    | env = newEnv
                  }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ every 16 Tick
        ]


view : Model -> Html msg
view { boid, world, env } =
    let
        ( width, height ) =
            world
    in
        div
            [ style
                [ ( "backgroundColor", "white" )
                ]
            ]
            [ div [] [ Html.text (toString boid) ]
            , div [] [ Html.text ("Size: " ++ (toString env.window)) ]
            , collage
                (round width)
                (round height)
                ([ Boid.boid boid
                 ]
                    |> addAxis (round width) (round height)
                )
                |> toHtml
            ]
