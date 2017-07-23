module Main exposing (main)

import Boid exposing (Boid, boid)
import Collage exposing (collage)
import Element exposing (toHtml)
import Html exposing (Html, div, text)
import Time exposing (Time, every)
import Types exposing (Point)
import Utils exposing (addAxis, wrapPosition)


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
