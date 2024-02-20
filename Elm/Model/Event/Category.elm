module Model.Event.Category exposing (EventCategory(..), SelectedEventCategories, allSelected, eventCategories, isEventCategorySelected, set, view)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (checked, class, style, type_)
import Html.Events exposing (onCheck)


type EventCategory
    = Academic
    | Work
    | Project
    | Award


eventCategories =
    [ Academic, Work, Project, Award ]


{-| Type used to represent the state of the selected event categories
-}
type SelectedEventCategories
    = SelectedEventCategories { 
        ac : Bool,
        wk : Bool,
        pj : Bool, 
        aw : Bool
    }


{-| Returns an instance of `SelectedEventCategories` with all categories selected

    isEventCategorySelected Academic allSelected --> True

-}
allSelected : SelectedEventCategories
allSelected =
    SelectedEventCategories{ac = True,wk = True, pj = True, aw = True}
    -- Debug.todo "Implement Model.Event.Category.allSelected"

{-| Returns an instance of `SelectedEventCategories` with no categories selected

-- isEventCategorySelected Academic noneSelected --> False

-}
noneSelected : SelectedEventCategories
noneSelected = 
    SelectedEventCategories{ac = False,wk = False, pj = False, aw = False}
    --Debug.todo "Implement Model.Event.Category.noneSelected"

{-| Given a the current state and a `category` it returns whether the `category` is selected.

    isEventCategorySelected Academic allSelected --> True

-}
isEventCategorySelected : EventCategory -> SelectedEventCategories -> Bool
isEventCategorySelected category current = 
                    let
                        (SelectedEventCategories selectedEvent) = current
                    in
                    case category of
                            Academic -> selectedEvent.ac
                            Work -> selectedEvent.wk
                            Project -> selectedEvent.pj
                            Award -> selectedEvent.aw 
    --Debug.todo "Implement Model.Event.Category.isEventCategorySelected"


{-| Given an `category`, a boolean `value` and the current state, it sets the given `category` in `current` to `value`.

    allSelected |> set Academic False |> isEventCategorySelected Academic --> False

    allSelected |> set Academic False |> isEventCategorySelected Work --> True

-}
set : EventCategory -> Bool -> SelectedEventCategories -> SelectedEventCategories
set category value current =
                    let
                        (SelectedEventCategories selectedEvent) = current
                    in
                    case category of
                            Academic -> SelectedEventCategories{ac = value,wk = selectedEvent.wk, pj = selectedEvent.pj, aw = selectedEvent.aw}
                            Work -> SelectedEventCategories{ac = selectedEvent.ac,wk = value, pj = selectedEvent.pj, aw = selectedEvent.aw}
                            Project -> SelectedEventCategories{ac = selectedEvent.ac,wk = selectedEvent.wk, pj = value, aw = selectedEvent.aw}
                            Award -> SelectedEventCategories{ac = selectedEvent.ac,wk = selectedEvent.wk, pj = selectedEvent.pj, aw = value} 
    --Debug.todo "Implement Model.Event.Category.set"


checkbox : String -> Bool -> EventCategory -> Html ( EventCategory, Bool )
checkbox name state category =
    div [ style "display" "inline", class "category-checkbox" ]
        [ input [ type_ "checkbox", onCheck (\c -> ( category, c )), checked state ] []
        , text name
        ]

view : SelectedEventCategories -> Html ( EventCategory, Bool )
view model =
    let
        (SelectedEventCategories selectedEvent) = model
    in
    div [] [
        div [] [checkbox ("Academic") (selectedEvent.ac) (Academic)],
        div [] [checkbox ("Work") (selectedEvent.pj) (Project)],
        div [] [checkbox ("Project") (selectedEvent.wk) (Work)],
        div [] [checkbox ("Award") (selectedEvent.aw) (Award)]
    ]
    --Debug.todo "Implement the Model.Event.Category.view function"
