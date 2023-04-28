function GetAppController() as object
    if (m._appControllerSingleton = invalid)
        prototype = {}

        ' dependencies
        prototype._mainViewMediator = GetMainViewMediator()
        prototype._stateController = invalid
        prototype._currentView = invalid

        prototype.setRoots = sub(mainContainer)
            m._mainViewMediator.setContainers(mainContainer)
        end sub

        prototype.init = sub()
            ' Initialize task for transactions
            GetTransactionPool().init()
            ' Redirect to Home View
            NavigationChangeCommand().executeController("HOME")
        end sub

        prototype.getStateController = function()
            return m._stateController
        end function

        '////////////////////////////////////////////////
        '/// PRIVATE  ///
        '////////////////////////////////////////////////

        prototype._navigationChangedHandler = sub(navigationObject as object)

            m._stateController = navigationObject.getController()
            ' Since it will be just one screen we don need a case if the state is <> invalid
            if (m._stateController = invalid)
                m._stateController = m._selectControllerStateView(navigationObject)
                ' Set up all dependencies for new screen before creation of view and setup
                ' of addEventListener
                m._stateController.setupModels()
                m._stateController.setupMediators()
                m._stateController.registerCommands()
                m._stateController.init()
    
                m._stateController.launch(navigationObject)
            end if

        end sub

        prototype._selectControllerStateView = function(navigationObject)
            ' Get the architecture for a screen
            if (navigationObject.getStateName() = controllerNameState().HOME)
                return GetHomeController()
            end if

        end function

        prototype.destroy = sub()
        end sub

        m._appControllerSingleton = prototype
    end if

    return m._appControllerSingleton
end function

sub DestroyAppController() as void
    m._appControllerSingleton = invalid
end sub