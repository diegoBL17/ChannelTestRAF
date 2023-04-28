function AbstractController() as object
    ' Interface
    prototype = {}
    prototype._global = m.global

    prototype.init = function() as object
    end function

    prototype.launch = function()
    end function

    prototype.exit = function() as object
    end function

    prototype.destroy = function() as object
    end function

    prototype.setupModels = function()
    end function

    prototype.registerCommands = function()
    end function

    prototype.setupMediators = function()
    end function

    prototype.setFocus = function()
    end function

    return prototype
end function