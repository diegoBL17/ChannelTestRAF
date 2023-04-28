sub init()
    m.carouselTitle = m.top.findNode("carouselTitle")
    m.carouselContainer = m.top.findNode("carouselContainer")

    m.top.observeField("focusedChild", "onFocus")

    m.transRightAnimation = m.top.FindNode("transRightAnimation")
    m.transGroupRight = m.top.findNode("transGroupRight")
    m.transRightAnimation.observeField("state", "onAnimationRightSlideState")

    m.transLeftAnimation = m.top.FindNode("transLeftAnimation")
    m.transGroupLeft = m.top.findNode("transGroupLeft")
    m.transLeftAnimation.observeField("state", "onAnimationLeftSlideState")

    m.navigationTimer = m.top.findNode("navigationTimer")
    m.navigationTimer.observeField("fire", "navigationTimerHanlder")
    
    m.amountElements = 0
    m.currentElementPos = 0
    m.widthElement = 0
    m.flagClick = true
end sub

sub onFocus()
    'Focus first element, this happens after content is loaded. 
    'How do I know? in Home controller the data is set first.
    if (m.top.hasFocus())
        m.carouselContainer.getChild(0).setFocus(true)
    end if
end sub

sub onContentUpdate()
    m.content = m.top.content
    m.carouselTitle.text = m.content.name

    date = CreateObject("roDateTime")
    xPosition = 0

    for each item in m.content.videos
        itemC = CreateObject("roSGNode", "carouselItem")
        itemC.id = xPosition.toStr() + "carouselItem"

        carouselItemBounding = itemC.boundingRect()
        m.widthElement = carouselItemBounding["width"]
        
        itemC.content = item
        itemC.translation = [(m.widthElement + 20) * xPosition, 0] ' +20 so there will be a space between
        xPosition += 1

        m.carouselContainer.appendChild(itemC)
    end for
    m.amountElements = xPosition

    ' First value for animation
    translationOfCarousel = m.carouselContainer.translation
    newX = translationOfCarousel[0] - m.widthElement
    m.transGroupRight.keyValue = [translationOfCarousel, [ newX, translationOfCarousel[1] ]]
end sub

sub navigationTimerHanlder()
    ' After the second pass, flag is reseted
    m.flagClick = true
end sub

function onAnimationRightSlideState(event as object)
    state = event.getData()

    ' Calculate next position of animation
    if (state = "stopped")

        m.currentElementPos +=1
        m.carouselContainer.getChild(m.currentElementPos).setFocus(true)
        ' Calculate value of next Right position
        translationOfCarousel = m.carouselContainer.translation
        newX = translationOfCarousel[0] - m.widthElement - 20 '-20 due a set of 20 extra pixels to seperate items
        m.transGroupRight.keyValue = [translationOfCarousel, [ newX, translationOfCarousel[1] ]]

        ' Calculate value of next Left position
        newX = translationOfCarousel[0] + m.widthElement + 20 '-20 due a set of 20 extra pixels to seperate items
        m.transGroupLeft.keyValue = [translationOfCarousel, [ newX, translationOfCarousel[1] ]]
    end if
end function

function onAnimationLeftSlideState(event as object)
    state = event.getData()

    ' Calculate next position of animation
    if (state = "stopped")

        m.currentElementPos -=1
        m.carouselContainer.getChild(m.currentElementPos).setFocus(true)

        ' Calculate value of next Left position
        translationOfCarousel = m.carouselContainer.translation
        newX = translationOfCarousel[0] + m.widthElement + 20 '-20 due a set of 20 extra pixels to seperate items
        m.transGroupLeft.keyValue = [translationOfCarousel, [ newX, translationOfCarousel[1] ]]

        ' Calculate value of next Right position
        newX = translationOfCarousel[0] - m.widthElement - 20 '-20 due a set of 20 extra pixels to seperate items
        m.transGroupRight.keyValue = [translationOfCarousel, [ newX, translationOfCarousel[1] ]]
    end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if(press)
        if (key="right")

            ' Check position of element
            if (m.currentElementPos < m.amountElements - 1 and m.flagClick = true)
                m.flagClick = false
                m.navigationTimer.control = "start"
                m.transRightAnimation.control = "start"
            end if
            
            handled = true
        end if

        if (key="left")

            ' Check position of element
            if (m.currentElementPos > 0 and m.flagClick = true)
                m.flagClick = false
                m.navigationTimer.control = "start"
                m.transLeftAnimation.control = "start"
            end if
            
            handled = true
        end if
    end if

    return handled
end function
