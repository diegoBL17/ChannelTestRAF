function controllerNameState() as object
    'Navigation object
    prototype = {}
    
    prototype.HOME = "HOME"
    prototype._stateName = ""
    prototype._view = invalid
    prototype._controller = invalid

    prototype.getView = function()
        return m._view
    end function
    
    prototype.getStateName = function()
        return m._stateName
    end function

    prototype.setStateName = function(name as string)
        m._stateName = name
    end function

    prototype.getController = function()
        return m._controller
    end function

    return prototype
end function
