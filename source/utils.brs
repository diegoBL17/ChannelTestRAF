function createViewObject(parentNode, viewObject, viewName)
    date = CreateObject("roDateTime")
    today = date.AsSeconds()

    if (viewObject = invalid)
        viewObject = CreateObject("roSGNode", viewName)
        viewObject.id = today.toStr() + viewName
    end if

    parentNode.appendChild(viewObject)
    return viewObject
end function
