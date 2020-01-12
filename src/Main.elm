module Main exposing (main)

import Array exposing (Array)
import Browser
import Css exposing (..)
import Debug exposing (log)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, href, id, src, style)
import Html.Styled.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)
import MyStyles exposing (sty)



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
    | ToggleSidebar


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
    , sideOpen : Bool
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



-- commonly used styles go here
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
    div
        [ css sty.contName ]
        [ h4 [] [ text str ] ]


renderNameSpacer : String -> Html msg
renderNameSpacer str =
    div
        [ css sty.contNameSpacer ]
        [ h4 [] [ text str ] ]


renderSubtitle : String -> Html msg
renderSubtitle str =
    div
        [ css sty.contSubtitle ]
        [ h4 [] [ text str ] ]


introText : List (Html Msg)
introText =
    [ div
        [ css sty.contOptions ]
        [ div
            [ css sty.boxOptions, onClick ToggleSidebar ]
            [ img [ src "./images/font.png", css sty.fontImg ] [] ]
        ]
    ]
        ++ [ div [ css sty.contNames ]
                [ div [ css sty.flexGrowX ] []
                , renderName "최성필"
                , renderNameSpacer "그리고"
                , renderName "최수강"
                , div [ css sty.flexGrowX ] []
                ]
           ]
        ++ List.map
            renderSubtitle
            [ "- 2020.04.19 SUN AM 11:00 -"
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
        [ css sty.contComment, onClick (CommentSelected cmt) ]
        [ div
            [ css sty.commentInner ]
            [ div
                [ css sty.flexStart ]
                [ span [ css sty.textAuthor ] [ text cmt.author ]
                ]
            , div
                [ css sty.flexStart ]
                [ span [ css sty.contAuthor ] [ text cmt.createdAt ] ]
            , div
                [ css sty.contClose ]
                [ img [ src "./images/close.png", css sty.iconClose ] [] ]
            ]
        , div [ css sty.textContent ] [ text cmt.content ]
        ]


makeThumbnail : String -> Html Msg
makeThumbnail link =
    div
        [ css (backgroundImage (url link) :: sty.thumbnail)
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
        [ div [ css sty.displayComment, onClick (CommentSelected emptyComment) ] [ text c.author ] ]

    else
        []


displaySocial : SocialPlatform -> Html Msg
displaySocial s =
    div [ css sty.contSocial ] [ text s.text ]


viewLoaded : List String -> List (Html Msg)
viewLoaded gallery =
    [ div [ css sty.contLoaded ] (List.map makeThumbnail gallery) ]


displayOpt : String -> SocialPlatform -> Html Msg
displayOpt url social =
    div
        [ css sty.contOpt, onClick (SocialSelected url) ]
        [ img [ src social.icon, css sty.iconSocial ] [] ]


displaySelectedImage : String -> Html Msg
displaySelectedImage link =
    if link == "" then
        div [] []

    else
        div
            [ css (backgroundImage (url link) :: sty.contSelectedImage) ]
            [ div
                [ css sty.contOverlay ]
                [ div
                    [ css sty.contOverlayClose, onClick (ImageSelected "") ]
                    [ img [ src "./images/close.png", css sty.iconCloseOverlay ] [] ]
                ]
            , div [ css sty.fgrow ] []
            , div [ css sty.contSocialOverlay ] <| List.map (displayOpt link) socialPlatforms
            ]


loader =
    [ div
        [ css sty.contLoader ]
        [ img [ src "./images/loader.gif", css sty.iconLoader ] [] ]
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
    , sideOpen = False
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


renderSideOpt =
    div [ css sty.contSideOpt ] [ text "asdf fdss deff" ]


renderSidebar : Bool -> Html Msg
renderSidebar sideOpen =
    div
        [ css
            (sty.contSidebar
                ++ [ left
                        (vw
                            (if sideOpen then
                                0

                             else
                                -75
                            )
                        )
                   ]
            )
        ]
        [ renderSideOpt
        , renderSideOpt
        ]


view : Model -> Html Msg
view model =
    div
        [ css sty.contMain ]
        [ div
            [ id "cont-greeting", css sty.contFlower ]
            [ div [ css sty.contFlowerText ] introText
            ]
        , div [ id "cont-gallery", css sty.contGallery ] <| renderGallery model.status
        , displaySelectedImage model.selectedImage
        , div [ css sty.contComments ] <| renderComments model.status
        , div [ css sty.contSelectedComment ] <| displayComment model.selectedComment
        , div [ id "cont-map", css sty.sectionMap ]
            [ div
                [ css sty.contMap ]
                [ div [ id "map", css sty.map ] [] ]
            ]
        , div [] <| List.map displaySocial socialPlatforms
        , renderSidebar model.sideOpen
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

        ToggleSidebar ->
            ( { model | sideOpen = not model.sideOpen }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, initialCmd )
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \model -> Sub.none
        }
