module MyStyles exposing (..)

import Css exposing (..)


flexCenterX =
    [ displayFlex, justifyContent center, alignItems center ]


flexColX =
    [ displayFlex, flexDirection column, flex (num 1) ]


flexEndX =
    [ displayFlex, flex (num 1), justifyContent flexEnd, alignItems center ]


flexRowX =
    [ displayFlex, flexDirection row ]


flexStartX =
    [ displayFlex, flex (num 1), justifyContent flexStart, alignItems center ]


sty =
    { contName =
        flexCenterX
            ++ [ height (px 40)
               , fontSize (px 36)
               , flex (num 1)
               ]
    , flexGrowX = [ displayFlex, flexGrow (num 1) ]
    , contNameSpacer =
        flexCenterX
            ++ [ fontSize (px 12)
               , margin2 (px 0) (px 8)
               ]
    , contNames =
        flexRowX
            ++ [ width (pct 100)
               , marginBottom (px 16)
               ]
    , contSubtitle = flexCenterX ++ [ width (pct 100), fontSize (px 16), height (px 30) ]
    , contComment = flexColX ++ [ marginBottom (px 16), padding4 (px 0) (px 16) (px 0) (px 16) ]
    , commentInner = flexRowX ++ [ marginBottom (px 8) ]
    , flexStart = flexStartX
    , textAuthor =
        [ whiteSpace noWrap
        , textOverflow ellipsis
        , fontWeight bold
        , fontSize (px 18)
        ]
    , contClose = flexEndX ++ [ width (px 30) ]
    , contAuthor = [ fontWeight lighter, fontSize (px 14), color (hex "bbded6") ]
    , iconClose = [ width (px 25), height (px 25) ]
    , textContent = [ fontSize (px 14) ]
    , thumbnail =
        [ width (vw 100)
        , height (vh 50)
        , backgroundPosition center
        , backgroundRepeat noRepeat
        ]
    , displayComment = [ width (pct 100) ]
    , contSocial = [ width (pct 100) ]
    , contLoaded =
        [ width (pct 100)
        , height (vh 50)
        ]
    , contOpt = flexCenterX ++ [ flex (num 1) ]
    , iconSocial = [ width (px 30), height (px 30) ]
    , contSelectedImage =
        flexColX
            ++ [ width (pct 100)
               , height (vh 100)
               , position fixed
               , top (px 0)
               , left (px 0)
               , backgroundPosition center
               , backgroundRepeat noRepeat
               , zIndex (int 99)
               , overflow hidden
               ]
    , contOverlay =
        [ displayFlex
        , justifyContent flexEnd
        , alignItems center
        , width (pct 100)
        , height (px 50)
        ]
    , contOverlayClose =
        flexCenterX
            ++ [ marginTop (px 16)
               , marginRight (px 8)
               , width (px 50)
               , height (px 50)
               , borderRadius (pct 50)
               , backgroundColor (rgba 241 241 246 0.8)
               ]
    , iconCloseOverlay = [ width (px 30), height (px 30) ]
    , fgrow = [ flexGrow (num 1) ]
    , contSocialOverlay = flexRowX ++ [ width (pct 100), height (px 75), backgroundColor (rgba 0 0 0 0.8) ]
    , contLoader = flexCenterX ++ [ width (pct 100) ]
    , iconLoader = [ maxHeight (px 150) ]
    , contMain =
        [ width (vw 100)
        , height (vh 100)
        , overflow scroll
        ]
    , contFlower =
        flexCenterX
            ++ [ width (pct 100)
               , height (vh 100)
               , position relative
               , textAlign center
               , backgroundColor (hex "#729FB2")
               , backgroundImage (url "./images/bg2.jpg")
               , backgroundPosition center
               , backgroundRepeat noRepeat
               ]
    , contFlowerText =
        flexColX
            ++ [ paddingTop (px 32)
               ]
    , lightBg =
        [ width (calc (vw 100) minus (px 32))
        , height (calc (vh 100) minus (px 32))
        , backgroundColor (rgba 255 255 255 0.25)
        , borderRadius (px 10)
        ]
    , contGallery =
        flexColX
            ++ [ width (vw 100)
               , backgroundColor (hex "#ffffff")
               ]
    , contComments = flexColX ++ [ width (pct 100), float left ]
    , contSelectedComment = [ padding (px 16) ]
    , contMap =
        flexCenterX
            ++ [ height (vh 40), overflow hidden ]
    , sectionMap =
        flexColX
            ++ [ width (vw 100)
               , height (vh 100)
               , paddingBottom (px 50)
               ]
    , map = [ width (pct 100), height (px 400) ]
    , contProgress = flexCenterX ++ [ width (vw 100), height (vh 20), backgroundColor (hex "f6eec7") ]
    , contOptions =
        flexStartX
            ++ [ width (vw 30)
               , height (px 70)
               , position fixed
               , left (px 0)
               , top (px 0)
               ]
    , boxOptions = flexStartX ++ [ width (px 50), height (px 50) ]
    , fontImg = [ width (px 20), height (px 20) ]
    , contSidebar =
        flexColX
            ++ [ width (vw 75)
               , height (vh 100)
               , backgroundColor (rgba 255 255 255 0.9)
               , position fixed
               , top (vw 0)
               ]
    , contSideOpt =
        [ width (pct 100)
        , height (px 50)
        , displayFlex
        , justifyContent flexStart
        , alignItems center
        , boxSizing borderBox
        , border3 (px 1) solid (hex "#5b5656")
        , borderWidth4 (px 0) (px 0) (px 1) (px 0)
        ]
    , sideOptText =
        [ marginLeft (px 16) ]
    , contSideClose =
        [ width (pct 100)
        , height (px 50)
        , displayFlex
        , justifyContent flexStart
        , alignItems center
        , boxSizing borderBox
        , border3 (px 1) solid (hex "#5b5656")
        , borderWidth4 (px 0) (px 0) (px 1) (px 0)
        ]
    , closeSidebar = [ marginLeft (px 16) ]
    , contGifs =
        flexColX
            ++ [ width (vw 100)
               ]
    , contGif =
        flexRowX
            ++ [ width (pct 100)
               , height (px 75)
               , paddingLeft (vw 20)
               ]
    , contGifImg =
        flexCenterX
            ++ [ width (px 75)
               , height (px 75)
               ]
    , contGifText =
        flexCenterX
            ++ [ color (hex "#000000")
               ]
    , gifImg = [ height (px 75) ]
    , gifName = [ fontSize (px 18) ]
    , gifDesc =
        [ fontSize (px 18)
        , width (pct 100)
        ]
    , boundingBox =
        flexCenterX
            ++ [ width (vw 100)
               , height (vh 100)
               ]
    , contWeddingHall =
        flexColX
            ++ [ flexGrow (num 1)
               , padding2 (px 8) (px 16)
               ]
    , contHallInfo = flexRowX ++ [ flex (num 1) ]
    , hallInfoLeft =
        [ flex (num 1)
        , displayFlex
        , justifyContent flexStart
        , alignItems flexStart
        , fontWeight bold
        , fontSize (px 18)
        ]
    , hallInfoRight =
        [ flex (num 2)
        , displayFlex
        , justifyContent flexStart
        , alignItems flexStart
        , fontSize (px 18)
        ]
    , hallTitle =
        flexCenterX
            ++ [ fontSize (px 20)
               , fontWeight bold
               , width (pct 100)
               , height (px 40)
               ]
    , contMapButtons =
        flexRowX
            ++ [ width (pct 100)
               , height (px 33)
               , margin4 (px 16) (px 0) (px 32) (px 0)
               ]
    , contMapButtonLeft =
        flexStartX
            ++ [ flex (num 1)
               ]
    , contMapButtonRight =
        flexEndX
            ++ [ flex (num 1)
               ]
    , mapButtonLeft =
        flexCenterX
            ++ [ width (pct 95)
               , height (pct 100)
               , fontSize (px 20)
               , fontWeight bold
               , color (hex "#ffffff")
               , backgroundColor (hex "#2CAE00")
               , borderRadius (px 8)
               , textDecoration none
               ]
    , mapButtonRight =
        flexCenterX
            ++ [ width (pct 95)
               , height (pct 100)
               , fontSize (px 20)
               , fontWeight bold
               , color (hex "#000000")
               , backgroundColor (hex "#F8DC03")
               , borderRadius (px 8)
               , textDecoration none
               ]
    , gallerySpacer =
        flexCenterX
            ++ [ width (pct 100)
               , height (px 75)
               ]
    , gallerySpacerImg = [ width (px 30), height (px 30) ]
    , gifMsg =
        [ width (calc (pct 100) minus (px 64))
        , textAlign center
        , lineHeight (px 36)
        , paddingLeft (px 32)
        ]
    , gifText =
        [ fontSize (px 18)
        ]
    }
