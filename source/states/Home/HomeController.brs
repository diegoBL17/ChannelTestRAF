function GetHomeController() as object
    if (m._homeControllerSingleton = invalid)
        prototype = AbstractController()
        prototype._global = m.global

        ' mediators
        prototype._mainViewMediator = invalid
        prototype._ownMediator = invalid

        ' models
        prototype._DataModel = invalid

        ' commands
        prototype._loadcatalogCommand = invalid
        prototype._navigationChangeCommand = invalid

        'private

        '//////////////////
        '/// PUBLIC API ///
        '//////////////////

        prototype.setupModels = sub()
            m._DataModel = DataModel()
        end sub

        prototype.setupMediators = sub()
            m._mainViewMediator = GetMainViewMediator()
            m._ownMediator = GetHomeMediator()
        end sub

        prototype.registerCommands = sub()
            m._loadcatalogCommand = LoadcatalogCommand()
            m._navigationChangeCommand = NavigationChangeCommand()
        end sub

        prototype.init = sub(viewObject = invalid)
            m._ownMediator.createView(m._mainViewMediator.getMainContainer(), viewObject)

            m._DataModel.addEventListener(m._DataModel.STOREFRONT_CONTENT_SUCCESS, "_loadDataSuccessful", m)
            m._DataModel.addEventListener(m._DataModel.STOREFRONT_CONTENT_FAILED, "_loadDataFailed", m)

        end sub

        prototype.launch = sub(data = invalid as object)
            m._loadcatalogCommand.execute()
        end sub

        prototype.getViewObject = function()
            return m._ownMediator.getViewObject()
        end function

        prototype.removeListenerAndMediator = sub()
            
            m._DataModel.removeEventListener(m._DataModel.STOREFRONT_CONTENT_SUCCESS, "_loadDataSuccessful", m)
            m._DataModel.removeEventListener(m._DataModel.STOREFRONT_CONTENT_FAILED, "_loadDataFailed", m)

            m._ownMediator.destroy()
        end sub

        prototype.destroy = sub()

            m.removeListenerAndMediator()
            m._DataModel.destroy()

            DestroyHomeController()
        end sub

        '////////////////
        '/// PRIVATE  ///
        '////////////////

        prototype._loadDataSuccessful = sub(data)
            m._ownMediator.populateView(data)
            m._ownMediator.setFocus()
        end sub

        prototype._loadDataFailed = sub()
            print " ERROR: No Data Found "
        end sub

        m._homeControllerSingleton = prototype
    end if

    return m._homeControllerSingleton
end function

sub DestroyHomeController() as void
    m._homeControllerSingleton = invalid
end sub