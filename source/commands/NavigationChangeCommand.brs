function NavigationChangeCommand() as object
    prototype = {}

    ' dependencies
    prototype._appController = GetAppController()
    prototype._navigateModel = GetNavigateModel()

    ' Stablish object to show
    prototype.executeController = sub(stateOrOptionName as string)
        navigationObject = m._navigateModel.getCurrentScreen()

        m._navigateModel.addPath(navigationObject)
        ' Stablish name of the new navigation object
        navigationObject.setStateName(stateOrOptionName)
        ' Search the navigation option object
        m._appController._navigationChangedHandler(navigationObject)
    end sub

    ' Screens options
    prototype.getSelectStateName = function(stateOrOptionName)
        navigationObject = controllerNameState()

        _stateName = ""
        _menuItemSelected = ""

        if (stateOrOptionName = navigationObject.HOME)
            _stateName = navigationObject.HOME
        else
            _stateName = stateOrOptionName
        end if

        select = {
            stateName: _stateName
        }

        return select
    end function

    return prototype
end function