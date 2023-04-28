function LoadCatalogCommand() as object
    prototype = {}

    ' dependencies
    prototype._dataModel = DaTaModel()

    prototype.execute = function()
        m._dataModel.requestHomeCatalogData()
    end function

    return prototype
end function