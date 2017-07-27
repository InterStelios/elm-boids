module Main exposing (main)

import Boid exposing (Boid)
import Collage
import Element
import Html
import Html.Attributes
import List
import Seed
import Task
import Time
import Utils
import Window


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
    = Tick Time.Time
    | UpdateWorld Window.Size
    | BoidsGenerated (List Boid)


init : ( Model, Cmd Msg )
init =
    ( { boids = []
      , world = ( 0, 0 )
      }
    , Task.perform UpdateWorld Window.size
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updateBoid =
            Boid.update model.world

        nextBoids =
            List.map updateBoid model.boids
    in
        case msg of
            Tick _ ->
                ( { model
                    | boids = nextBoids
                  }
                , Cmd.none
                )

            UpdateWorld size ->
                ( { model
                    | world = ( size.width, size.height )
                  }
                , Seed.generateBoids BoidsGenerated 1500 ( 0, 0 )
                )

            BoidsGenerated generatedBoids ->
                ( { model
                    | boids = generatedBoids
                  }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every 16 Tick
        ]


view : Model -> Html.Html msg
view { boids, world } =
    let
        ( width, height ) =
           world
    in
        Html.div
            [ Html.Attributes.style
                [ ( "backgroundColor", "black" )
                , ("width", "100%")
                , ("height", "100%")
                , ( "color", "white" )
                ]
            ]
            [ Collage.collage
                width 
                height
                (List.map Boid.boid boids
                    |> Utils.addAxis width height
                )
                |> Element.toHtml
            ]
