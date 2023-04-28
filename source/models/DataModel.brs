function DataModel() as object
    if (m._DataModelSingleton = invalid)
        prototype = EventDispatcher()

        '////////////////////////////////////////////////
        '/// PRIVATE PROPERTIES ///
        '////////////////////////////////////////////////

        'private
        prototype._data = invalid
        '////////////////////////////
        '/// PUBLIC API ///
        '////////////////////////////

        prototype.STOREFRONT_CONTENT_SUCCESS = "DataModel:STOREFRONT_CONTENT_SUCCESS"
        prototype.STOREFRONT_CONTENT_FAILED = "DataModel:STOREFRONT_CONTENT_FAILED"

        prototype.requestHomeCatalogData = sub() as void

            m._DataService = DataService()
            m._DataService.addEventListener(m._DataService.LOAD_SUCCESS, "_loadStorefrontContentSuccessful", m)
            m._DataService.addEventListener(m._DataService.LOAD_NETWORK_FAIL, "_loadStorefrontContentFailed", m)
            m._DataService.addEventListener(m._DataService.LOAD_SERVICE_FAIL, "_loadStorefrontContentFailed", m)

            m._DataService.requestDataHomeService()
        end sub

        prototype.get_homeData = function() as object
            return m._data
        end function

        '///////////////////////////////////////////
        '/// PRIVATE METHODS ///
        '///////////////////////////////////////////


        prototype._loadStorefrontContentSuccessful = function(request as dynamic) as void
            m._removeEventListeners()
            req = request.getResponse()

            data = ParseJson(request.getResponse().data)
            m._homeData = []

            if (req.code = 200)
                ' Parse data
                m._data = data.categories[0]
                m.dispatchEvent(m.STOREFRONT_CONTENT_SUCCESS, m._data)
            else
                m.dispatchEvent(m.STOREFRONT_CONTENT_FAILED, data.header)
            end if
        end function

        prototype._loadStorefrontContentFailed = function(error as dynamic) as void
            m._removeEventListeners()
            m.dispatchEvent(m.STOREFRONT_CONTENT_FAILED, error)
        end function

        prototype._removeEventListeners = function()

            m._DataService.removeEventListener(m._DataService.LOAD_SUCCESS, "_loadStorefrontContentSuccessful", m)
            m._DataService.removeEventListener(m._DataService.LOAD_NETWORK_FAIL, "_loadStorefrontContentFailed", m)
            m._DataService.removeEventListener(m._DataService.LOAD_SERVICE_FAIL, "_loadStorefrontContentFailed", m)

            m._DataService.destroy()
            m._DataService = invalid
        end function

        prototype.destroy = function() as void
            m._removeEventListeners()
            'INFO: data must persist, object is not destroyed
            'DestroyEvergentLoginModel()
        end function

        m._DataModelSingleton = prototype
    end if

    return m._DataModelSingleton
end function

function DestroyDataModel() as void
    if (m._DataModelSingleton <> invalid)
        m._DataModelSingleton = invalid
    end if
end function