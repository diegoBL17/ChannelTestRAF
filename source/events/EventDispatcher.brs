function EventDispatcher () as Object
    prototype = {}
  
    '////////////////////////////
    '/// PUBLIC API ///
    '////////////////////////////
    ' This has been created to manage events between files 
    ' First the name of the listener is stored with 2 identifiers and the context where it was created
    ' First one is the type (used after in dispatch event) 
    ' Second one is the name of the function to be executed 
    ' Third one is the context on where has to be executed
    ' -----
    ' The dispatch event receives a type and search on the listenners
    ' Then checks if this has a payload to pass to the function
    ' Either way search for the listener and execute it
    ' -----
    ' Then the listeners are removed by type

    prototype.addEventListener = function (eventType as String, handlerName as String, context as Object) as void
     if (context.uid = Invalid)
        context.uid = "uid" + GetEventListenerUID()
      end if
  
      if (m._listeners[eventType] = Invalid)
        m._listeners[eventType] = {}
      end if
  
      listenerIdToAdd = handlerName + context.uid
      m._listeners[eventType].addReplace(listenerIdToAdd, {handlerName: handlerName, context: context})
    end function
  
    prototype.dispatchEvent = function (eventType as String, payload=Invalid as Dynamic) as Boolean
      eventTypeListeners = m._listeners[eventType]
  
      if (eventTypeListeners <> Invalid)
        if (payload = Invalid)
          for each listenerId in eventTypeListeners
            listener = eventTypeListeners[listenerId]
            listener.context[listener.handlerName]()
          end for
        else
          for each listenerId in eventTypeListeners
            listener = eventTypeListeners[listenerId]
            listener.context[listener.handlerName](payload)
          end for
        end if
      end if
    end function
  
    prototype.removeEventListener = function (eventType as String, handlerName as String, context as Object) as void
      eventTypeListeners = m._listeners[eventType]

      if (eventTypeListeners <> Invalid AND context.uid <> Invalid)

        listenerIdToDelete = handlerName + context.uid

        if (eventTypeListeners.delete(listenerIdToDelete) AND eventTypeListeners.count() = 0)
          m._listeners.delete(eventType)
        end if
      end if
    end function
  
    '////////////////////////////////////////////////
    '/// PRIVATE PROPERTIES ///
    '////////////////////////////////////////////////
  
    prototype._listeners = {}
    return prototype
end function
  
' Return a unique event-listener UID to identify the listener.
function GetEventListenerUID() as String
  if (m.UIDCounterInstance = invalid)
    this = {}

    this.count = 0

    this.getNext = function() as Integer
      m.count = m.count + 1
      return m.count
    end function

    m.UIDCounterInstance = this
  end if

  return m.UIDCounterInstance.getNext().toStr()
end function

function DestroyEventListenerUID () as Void
  m.UIDCounterInstance = Invalid
end function
