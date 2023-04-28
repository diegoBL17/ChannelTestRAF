function GetHomeMediator() as object
    if (m._homeMediatorSingleton = invalid)
        prototype = EventDispatcher()

        '////////////////////////////
        '/// PUBLIC API ///
        '////////////////////////////

        prototype._viewObject = invalid

        prototype.createView = sub(parentNode as object, viewObject = invalid) as void
            m._viewObject = createViewObject(parentNode, viewObject, "HomeView")
        end sub

        prototype.getViewObject = function()
            return m._viewObject
        end function

        prototype.destroy = sub() as void
            if (m._viewObject <> invalid)

                m._viewObject.getParent().removeChild(m._viewObject)
                m._viewObject.visible = false
                m._viewObject = invalid
            end if

            DestroyHomeMediator()
        end sub

        prototype.setFocus = sub()
            m._viewObject.setFocus(true)
        end sub

        prototype.populateView = sub(data as object) as void
            m._viewObject.setField("content", data)
        end sub

        '////////////////////////////////////////////////
        '/// PRIVATE PROPERTIES ///
        '////////////////////////////////////////////////

        m._homeMediatorSingleton = prototype
    end if

    return m._homeMediatorSingleton
end function

sub HomeMediator_carouselItemSelectedHandler(event as object)
    m._homeMediatorSingleton._carouselItemSelectedHandler(event)
end sub

sub DestroyHomeMediator() as void
    if m._homeMediatorSingleton <> invalid
        m._homeMediatorSingleton = invalid
    end if
end sub