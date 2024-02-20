module Model.Event exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Model.Event.Category exposing (EventCategory(..))
import Model.Interval as Interval exposing (Interval)
import Html.Attributes exposing (..)


type alias Event =
    { title : String
    , interval : Interval
    , description : Html Never
    , category : EventCategory
    , url : Maybe String
    , tags : List String
    , important : Bool
    }


categoryView : EventCategory -> Html Never
categoryView category =
    case category of
        Academic ->
            text "Academic"

        Work ->
            text "Work"

        Project ->
            text "Project"

        Award ->
            text "Award"


sortByInterval : List Event -> List Event
sortByInterval events =
    List.sortWith(\x y -> Interval.compare x.interval y.interval) events
    --Debug.todo "Implement Event.sortByInterval"



view : Event -> Html Never
view event =
    div [classList[("event", True), ("event-important", event.important == True)]] [
        h1[class "event-title"][text event.title],
        p[class "event-interval"][Interval.view event.interval],
        p[class "event-description"][event.description],
        p[class "event-category"][categoryView event.category],
        p[class "event-url"][a[href (Maybe.withDefault "" event.url)] [text (Maybe.withDefault "" event.url)]]
    ]
    --Debug.todo "Implement the Model.Event.view function"
