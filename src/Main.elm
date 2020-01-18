port module Main exposing (main)

import Array exposing (Array)
import Browser
import Css exposing (..)
import Debug exposing (log)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, class, css, href, id, src, style)
import Html.Styled.Events exposing (onClick)
import Json.Decode exposing (Decoder, int, list, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)
import MyStyles exposing (sty)
import Url.Builder as UBuild



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
    | SocialSelected String SocialPlatform
    | ToggleSidebar
    | AlterFont Int
    | GotWindowSize WindowSize


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
    , fontSize : Int
    , windowSize : WindowSize
    }


type alias SocialPlatform =
    { company : SocialMedia, text : String, icon : String }


port shareLink : LinkShare -> Cmd msg


type alias LinkShare =
    { url : String
    , platform : Int
    }


port resizeWindow : (WindowSize -> msg) -> Sub msg


type alias WindowSize =
    { width : Int
    , height : Int
    }


type alias KeyVal =
    { key : String
    , val : String
    }



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


fontSizes : List { value : Int, viewValue : String }
fontSizes =
    [ { value = 2, viewValue = "가장 큰 글꼴 크기로 변경" }
    , { value = 1, viewValue = "일반 글꼴 크기로 변경" }
    ]


socialPlatforms : List SocialPlatform
socialPlatforms =
    [ { company = KakaoStory, text = "kakao story", icon = "./images/KakaoStory.png" }
    , { company = Facebook, text = "facebook", icon = "./images/Facebook.png" }
    ]


emptyComment : Comment
emptyComment =
    { author = ""
    , createdAt = ""
    , content = ""
    }


hallInfo : List KeyVal
hallInfo =
    [ { key = "예식간격", val = "1시간 30분" }
    , { key = "예식시간", val = "오전 11시" }
    , { key = "전화번호", val = "02-730-0230" }
    , { key = "주소", val = "서울특별시 종로구 종로1길 50 (중학동), 더케이트윈타워 A동 LL층 (지하2층)" }
    ]



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
    [ div [ css sty.contNames ]
        [ renderName "최성필"
        , renderNameSpacer "(그리고)"
        , renderName "최수강"
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
    li [ class "glide__slide" ]
        [ div
            [ css (backgroundImage (url link) :: sty.thumbnail)
            , onClick (ImageSelected link)
            ]
            []
        ]


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


renderGallerySpacer : String -> Html Msg
renderGallerySpacer imgSrc =
    div
        [ css sty.gallerySpacer ]
        [ img [ css sty.gallerySpacerImg, src imgSrc ] [] ]


flowerImg =
    "https://img.icons8.com/office/16/000000/flower.png"


renderGallery : List String -> List (Html Msg)
renderGallery links =
    [ renderGallerySpacer flowerImg
    , div
        [ class "glide" ]
        [ div
            [ class "glide__track"
            , attribute "data-glide-el" "track"
            ]
            [ ul
                [ class "glide__slides" ]
                (List.map makeThumbnail links)
            ]
        , div
            [ class "glide__arrows", attribute "data-glide-el" "controls" ]
            [ button
                [ class "glide__arrow glide__arrow--left", attribute "data-glide-dir" "<" ]
                [ text "이전" ]
            , button
                [ class "glide__arrow glide__arrow--right", attribute "data-glide-dir" ">" ]
                [ text "다음" ]
            ]
        ]
    , renderGallerySpacer flowerImg
    ]


displayOpt : String -> SocialPlatform -> Html Msg
displayOpt url social =
    div
        [ css sty.contOpt, onClick (SocialSelected url social) ]
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
                    [ img [ src "./images/close.png", css sty.iconCloseOverlay ] []
                    , div
                        [ css sty.contOptions ]
                        (List.map (displayOpt link) socialPlatforms)
                    ]
                ]
            ]


loader =
    [ div
        [ css sty.contLoader ]
        [ img [ src "./images/loader.gif", css sty.iconLoader ] [] ]
    ]


initialModel : Model
initialModel =
    { status = Loading
    , comments = defaultComments
    , selectedComment = emptyComment
    , selectedImage = ""
    , sideOpen = False
    , fontSize = 1
    , windowSize =
        { width = 812
        , height = 375
        }
    }


renderComments : Status -> List (Html Msg)
renderComments status =
    case status of
        Loaded ( _, comments ) ->
            List.map renderComment comments

        Loading ->
            loader

        Errored err ->
            [ div [] [ text err ] ]


renderSideOpt : { value : Int, viewValue : String } -> Html Msg
renderSideOpt opt =
    div
        [ css sty.contSideOpt, onClick (AlterFont opt.value) ]
        [ div
            [ css sty.sideOptText ]
            [ text opt.viewValue ]
        ]


gallery =
    [ "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00673_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00514_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00864_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00451_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00948_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00789_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00934_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00806_Resize.jpg"
    , "https://choi-choi.s3.ap-northeast-2.amazonaws.com/DSC00579_Resize.jpg"
    ]


showHallInfo : KeyVal -> Html Msg
showHallInfo info =
    div
        [ css sty.contHallInfo ]
        [ div [ css sty.hallInfoLeft ] [ text info.key ]
        , div [ css sty.hallInfoRight ] [ text info.val ]
        ]


adjustBBox : WindowSize -> List Style
adjustBBox wsize =
    let
        portrait =
            wsize.height > wsize.width
    in
    if portrait then
        sty.contMain

    else
        sty.contMain


view : Model -> Html Msg
view model =
    div [ css sty.boundingBox ]
        [ div
            [ class "snap-container", css sty.contMain ]
            [ section
                [ class "snap-child", css sty.contFlower ]
                [ div
                    [ css sty.lightBg ]
                    [ div [ css sty.contFlowerText ] introText
                    ]
                ]
            , section
                [ class "snap-child", css sty.contGifs ]
                [ renderGallerySpacer flowerImg
                , div
                    [ css sty.gifMsg ]
                    [ p [ css sty.gifText ] [ text "베이징에서 북한으로 들어가는 모습이 목격돼 관심을 모으고 있습니다. 미국의 NK뉴스는 평양의 소식통들을 인용해 리용호 북한 외무상이 교체됐으며 후임이 누구인지는 파악되지 않았다고 현지시각 18일 보도했습니다." ]
                    ]
                , div
                    [ css sty.contGif ]
                    [ div
                        [ css sty.contGifImg ]
                        [ img [ src "./images/sk.gif", css sty.gifImg ] [] ]
                    , div
                        [ css sty.contGifText ]
                        [ div [ css sty.contGifText ] [ p [ css sty.gifName ] [ text "최수강 (신부)" ] ]
                        ]
                    ]
                , div
                    [ css sty.contGif ]
                    [ div
                        [ css sty.contGifImg ]
                        [ img [ src "./images/sk.gif", css sty.gifImg ] [] ]
                    , div
                        [ css sty.contGifText ]
                        [ div [ css sty.contGifText ] [ p [ css sty.gifName ] [ text "최성필 (신랑)" ] ]
                        ]
                    ]
                , div
                    [ css sty.gifMsg ]
                    [ p [ css sty.gifText ] [ text "2020년 4월 19일 일요일 오전 11시" ]
                    ]
                , div
                    [ css sty.gifMsg ]
                    [ p [ css sty.gifText ] [ text "서울특별시 종로구 종로1길 50 (중학동)," ]
                    ]
                , div
                    [ css sty.gifMsg ]
                    [ p [ css sty.gifText ] [ text "더케이트윈타워 A동 LL층 (지하2층)" ]
                    ]
                ]
            , section
                [ class "snap-child", css sty.contGallery ]
              <|
                renderGallery gallery
            , section [ class "snap-child", css sty.sectionMap ]
                [ div
                    [ css sty.contMap ]
                    [ div [ id "map", css sty.map ] []
                    ]
                , div
                    [ css sty.contWeddingHall ]
                  <|
                    [ div [ css sty.hallTitle ] [ text "아펠가모 광화문점" ]
                    , div
                        [ css sty.contMapButtons ]
                        [ div [ css sty.contMapButtonLeft ]
                            [ a
                                [ css sty.mapButtonLeft
                                , href "https://m.map.naver.com/map.nhn?pinId=31738014&pinType=site&lat=&lng=&dlevel=&mapMode="
                                ]
                                [ text "네이버지도" ]
                            ]
                        , div [ css sty.contMapButtonRight ]
                            [ a
                                [ css sty.mapButtonRight
                                , href "https://place.map.kakao.com/m/20000428"
                                ]
                                [ text "카카오맵" ]
                            ]
                        ]
                    ]
                        ++ List.map showHallInfo hallInfo
                ]
            , displaySelectedImage model.selectedImage
            ]
        ]


buildImgLink : String -> String
buildImgLink url =
    "https://chousemath.github.io"
        ++ UBuild.absolute
            [ "wedding-invitation" ]
            [ UBuild.string "imageURL" url ]


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

        SocialSelected url soc ->
            case soc.company of
                KakaoStory ->
                    let
                        link =
                            buildImgLink url
                    in
                    ( model, shareLink { url = link, platform = 1 } )

                Facebook ->
                    ( model, shareLink { url = url, platform = 2 } )

                _ ->
                    ( model, Cmd.none )

        ToggleSidebar ->
            ( { model | sideOpen = not model.sideOpen }, Cmd.none )

        AlterFont size ->
            ( { model | fontSize = size }, Cmd.none )

        GotWindowSize wsize ->
            ( { model | windowSize = wsize }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    resizeWindow GotWindowSize



{-
   init : WindowSize -> (Model, Cmd Msg)
   init flags =
       ({initialModel | windowSize = flags}, initialCmd)
-}
