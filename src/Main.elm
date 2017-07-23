module Main exposing (main)

import Boid exposing (Boid, boid, wrapBoidPosition)
import Collage exposing (collage)
import Element exposing (toHtml)
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (style)
import List
import Task 
import Time exposing (Time, every)
import Utils exposing (addAxis)
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
    { boids : List Boid
    , world : ( Int, Int )
    }


type Msg
    = Tick Time
    | UpdateWorld Size


init : ( Model, Cmd Msg )
init =
    ( { boids =
            [ Boid ( 50, 50 ) 180
            , Boid ( 0, 0 ) 90
            ]
      , world = ( 0, 0 )
      }
    , Task.perform UpdateWorld size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model
                | boids =
                    List.map
                        (Boid.update model.world)
                        model.boids
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
view { boids, world } =
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
                (List.map Boid.boid boids
                    |> addAxis width height
                )
                |> toHtml
            ]
