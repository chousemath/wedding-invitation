module Main exposing (main)

import Array exposing (Array)
import Browser
import Debug exposing (log)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)



-- custom types and type aliases go here


type Status
    = Loading
    | Loaded ( List String, Comments )
    | Errored String


type SocialMedia
    = KakaoStory
    | Facebook
    | Twitter
    | GooglePlus
    | Instagram
    | LinkedIn


type Msg
    = CommentSelected Comment
    | ImageSelected String
    | Social SocialMedia
    | SocialSelected String
    | GotPhotos (Result Http.Error InitialData)


type alias Comment =
    { author : String, createdAt : String, content : String }


type alias Comments =
    List Comment


type alias InitialData =
    { comments : List String
    , photos : List String
    }


type alias Model =
    { status : Status
    , comments : Comments
    , selectedImage : String
    , selectedComment : Comment
    }


type alias SocialPlatform =
    { company : SocialMedia, text : String, icon : String }



-- json decoders go here


initialDataDecoder : Decoder InitialData
initialDataDecoder =
    succeed buildInitialData
        |> required "comments" (list string)
        |> required "photos" (list string)


buildInitialData : List String -> List String -> InitialData
buildInitialData comments photos =
    { comments = comments, photos = photos }



-- default data goes here


socialPlatforms : List SocialPlatform
socialPlatforms =
    [ { company = KakaoStory, text = "kakao story", icon = "./images/KakaoStory.png" }
    , { company = Facebook, text = "facebook", icon = "./images/Facebook.png" }
    , { company = Twitter, text = "twitter", icon = "./images/Twitter.png" }
    , { company = GooglePlus, text = "google plus", icon = "./images/GooglePlus.png" }
    , { company = Instagram, text = "instagram", icon = "./images/Instagram.png" }
    , { company = LinkedIn, text = "linkedin", icon = "./images/LinkedIn.png" }
    ]


emptyComment : Comment
emptyComment =
    { author = ""
    , createdAt = ""
    , content = ""
    }



-- helper functions go here


safeGetStr : Int -> Array String -> String
safeGetStr idx arr =
    case Array.get idx arr of
        Just v ->
            v

        Nothing ->
            ""


extractComment : String -> Comment
extractComment com =
    let
        arr =
            com |> String.split "/////" |> Array.fromList

        author =
            safeGetStr 0 arr

        content =
            safeGetStr 1 arr

        createdAt =
            safeGetStr 2 arr
    in
    { author = author, content = content, createdAt = createdAt }


renderName : String -> Html msg
renderName str =
    div [ class "name" ] [ h4 [] [ text str ] ]


renderNameSpacer : String -> Html msg
renderNameSpacer str =
    div [ id "name-spacer" ] [ h4 [] [ text str ] ]


renderSubtitle : String -> Html msg
renderSubtitle str =
    div [ class "subtitle" ] [ h4 [] [ text str ] ]


introText : List (Html msg)
introText =
    [ renderName "최성필"
    , renderNameSpacer "그리고"
    , renderName "최수강"
    ]
        ++ List.map
            renderSubtitle
            [ "2020.04.19 SUN AM 11:00"
            , "서울특별시 종로구 종로1길 50 (중학동)"
            , "더케이트윈타워 A동 LL층 (지하2층)"
            ]


bucket =
    "https://choi-choi"


region =
    "ap-northeast-2.amazonaws.com/"


genLink : String -> String
genLink fname =
    bucket ++ ".s3." ++ region ++ fname


renderComment : Comment -> Html Msg
renderComment cmt =
    div
        [ class "cont-comment", onClick (CommentSelected cmt) ]
        [ div [ class "cont-cmt-top" ]
            [ div [ class "cont-cmt-author" ] [ span [ class "text-author" ] [ text cmt.author ] ]
            , div
                [ class "cont-cmt-created-at" ]
                [ span [ class "text-created-at" ] [ text cmt.createdAt ] ]
            , div
                [ class "cont-cmt-delete" ]
                [ img [ src "./images/close.png", class "icon-delete" ] [] ]
            ]
        , div
            [ class "cont-cmt-btm" ]
            [ text cmt.content ]
        ]


makeThumbnail : String -> String -> Html Msg
makeThumbnail selected link =
    div
        [ class
            (if selected == link then
                "thumbnail-selected"

             else
                "thumbnail"
            )
        , style "background" ("url(" ++ link ++ ") no-repeat center")
        , onClick (ImageSelected link)
        ]
        []


defaultComments : List Comment
defaultComments =
    [ { author = "Mom", createdAt = "2020-01-15", content = "Hi I am a mom" }
    , { author = "Dad", createdAt = "2020-01-15", content = "Hi I am a dad" }
    ]


displayComment : Comment -> List (Html Msg)
displayComment c =
    if c.author /= "" then
        [ div [ id "selected-cmt-content", onClick (CommentSelected emptyComment) ] [ text c.author ] ]

    else
        []


displaySocial : SocialPlatform -> Html Msg
displaySocial s =
    div
        [ class "cont-social" ]
        [ text s.text ]


viewLoaded : List String -> List (Html Msg)
viewLoaded gallery =
    [ div
        [ id "cont-thumbnails" ]
        (List.map (makeThumbnail "") gallery)
    ]


displayOpt : String -> SocialPlatform -> Html Msg
displayOpt url social =
    div
        [ class "cont-opt", onClick (SocialSelected url) ]
        [ img [ src social.icon, class "cont-opt-icon" ] [] ]


displaySelectedImage : String -> Html Msg
displaySelectedImage url =
    if url == "" then
        div [] []

    else
        div
            [ id "cont-selected"
            , style "background" ("url(" ++ url ++ ") no-repeat center")
            ]
            [ div
                [ id "cont-selected-close" ]
                [ div
                    [ id "cont-selected-close-in", onClick (ImageSelected "") ]
                    [ img [ src "./images/close.png", class "cont-selected-close-icon" ] [] ]
                ]
            , div [ id "options-spacer" ] []
            , div [ id "options-bar" ] <| List.map (displayOpt url) socialPlatforms
            ]


loader =
    [ div
        [ class "cont-loader" ]
        [ img [ src "./images/loader.gif", class "loader" ] [] ]
    ]


initialCmd : Cmd Msg
initialCmd =
    Http.get
        { url = "https://raw.githubusercontent.com/chousemath/wedding-invitation/master/response.json"
        , expect = Http.expectJson GotPhotos initialDataDecoder
        }


initialModel : Model
initialModel =
    { status = Loading
    , comments = defaultComments
    , selectedComment = emptyComment
    , selectedImage = ""
    }


renderGallery : Status -> List (Html Msg)
renderGallery status =
    case status of
        Loaded ( gallery, _ ) ->
            viewLoaded gallery

        Loading ->
            loader

        Errored err ->
            [ div [] [ text err ] ]


renderComments : Status -> List (Html Msg)
renderComments status =
    case status of
        Loaded ( _, comments ) ->
            List.map renderComment comments

        Loading ->
            loader

        Errored err ->
            [ div [] [ text err ] ]


view : Model -> Html Msg
view model =
    div [ id "cont-main" ]
        [ div
            [ id "cont-flower" ]
            [ img [ id "flower-border", src "https://i.imgur.com/IcVqiOb.png" ] []
            , div [ id "cont-flower-text" ] introText
            ]
        , div [ class "cont-loaded" ] <| renderGallery model.status
        , displaySelectedImage model.selectedImage
        , div [ id "cont-comments" ] <| renderComments model.status
        , div [ id "cont-selected-comment" ] <| displayComment model.selectedComment
        , div [ id "cont-map" ] [ div [ id "map" ] [] ]
        , div [ id "cont-socials" ] <| List.map displaySocial socialPlatforms
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ImageSelected url ->
            ( { model | selectedImage = url }
            , Cmd.none
            )

        CommentSelected c ->
            ( { model | selectedComment = c }
            , Cmd.none
            )

        Social platform ->
            ( model
            , Cmd.none
            )

        SocialSelected url ->
            ( model, Cmd.none )

        GotPhotos (Ok initialData) ->
            let
                comments =
                    List.map extractComment initialData.comments

                photos =
                    List.map genLink initialData.photos
            in
            ( { model | status = Loaded ( photos, comments ) }, Cmd.none )

        GotPhotos (Err httpError) ->
            ( { model | status = Errored "Internal Server Error" }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, initialCmd )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
