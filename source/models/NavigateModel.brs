function GetNavigateModel() as object

    if (m._navigateModelSingleton = invalid)
        prototype = EventDispatcher()

        prototype.navigationStory = []
        prototype.defaultScreen = controllerNameState().HOME

        prototype.addPath = function(navigationObject)
            ' Clean navigation if we go to default screen
            if (navigationObject.getStateName() = m.defaultScreen)
                m.navigationStory = []
            end if

            m.navigationStory.push(navigationObject)
        end function

        prototype.getCurrentScreen = function() as object
            if (m.navigationStory.Count() >= 1)
                return m.navigationStory[m.navigationStory.Count() - 1]
            end if

            ' If there is no navigation object, start with default
            return m._navigateObject(m.defaultScreen)
        end function

        
        prototype._navigateObject = function(screen as string) as object
            navegation = controllerNameState()
            navegation.setStateName(screen)
            return navegation
        end function

        prototype.getScreenHistory = function()
            return m.navigationStory
        end function

        prototype.deleteScreenHistory = function() 
            m.navigationStory = []
        end function
        
        m._navigateModelSingleton = prototype
    end if

    return m._navigateModelSingleton

end function