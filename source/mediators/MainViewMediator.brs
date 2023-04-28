function GetMainViewMediator() as object
    if (m._viewMediatorSingleton = invalid)
        prototype = {}

        prototype._mainContainer = invalid

        prototype.setContainers = function(mainContainer as object) as void
            m._mainContainer = mainContainer
        end function

        prototype.getMainContainer = function() as object
            return m._mainContainer
        end function

        m._viewMediatorSingleton = prototype
    end if

    return m._viewMediatorSingleton
end function

function DestroyMainViewMediator() as void
    m._viewMediatorSingleton = invalid
end function