module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


renderName str =
    div
        [ class "name" ]
        [ h4 [] [ text str ] ]


renderNameSpacer str =
    div
        [ id "name-spacer" ]
        [ h4
            [ style "font-size" "14px"
            , style "color" "#000"
            ]
            [ text str ]
        ]


renderSubtitle str =
    div
        [ class "subtitle" ]
        [ h4 [] [ text str ] ]


view model =
    div
        [ id "container-flower" ]
        [ img [ id "flower-border", src "https://i.imgur.com/IcVqiOb.png" ] []
        , div
            [ id "container-flower-text" ]
            [ renderName "최성필"
            , renderNameSpacer "그리고"
            , renderName "최수강"
            , div [ style "width" "100%", style "height" "25px" ] []
            , renderSubtitle "2020.04.19 SUN AM 11:00"
            , renderSubtitle "서울특별시 종로구 종로1길 50 (중학동)"
            , renderSubtitle "더케이트윈타워 A동 LL층 (지하2층)"
            ]
        ]


main =
    view "no model yet"
