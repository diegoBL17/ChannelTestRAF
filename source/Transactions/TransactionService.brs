function TransactionService() as Object
    prototype = EventDispatcher()
  
    ' dependencies
    prototype._transactionPool = GetTransactionPool()
  
    ' '////////////////////////////
    ' '/// PUBLIC API ///
    ' '////////////////////////////
  
    prototype.LOAD_SUCCESS = "Service.LOAD_SUCCESS"
    prototype.LOAD_NETWORK_FAIL = "Service.LOAD_NETWORK_FAIL"
    prototype.LOAD_SERVICE_FAIL = "Service.LOAD_SERVICE_FAIL"
	' Private
    prototype._activeRequests = {}
  
    prototype._load = function (options as Object) as String
		request = m._createRequest(options)
		m._transactionPool.queue(request)
		m._transactionPool.processQueue()
		return request.id
    end function

	prototype._getRequest = function (id) as Dynamic
		request = m._activeRequests.Lookup(id)
		if (request = Invalid) then request = m._transactionPool.getRequest(id)
	
		return request
    end function
	
    ' '//////////////////////////////////////////
    ' '/// PRIVATE METHODS ///
    ' '//////////////////////////////////////////
	
	prototype.clearRequestFromActiveQueue = function(id as String) as Void
      m._activeRequests.Delete(id)
    end function
  
    prototype._createRequest = function (options as Object) as Object
		'It should be an interface such as AbstractController, but since there is only one service
		request = HttpsTransaction({}) 
		
		' Set the values of the request
		request.location = options.location
		request.method = options.method
		request.callback = m._transactionComplete
		request.context = m

		request.id = Rnd(16).toStr()
        ' This way we can search a way faster a request using lookup
		m._activeRequests.addReplace(request.id, request)
	
		return request
    end function
  
	' On this function we get the response from the transaction pool of the task
	' Clean the request queue
	' Send the response of the API with the dispacht event, those were set on the model too
    prototype._transactionComplete = function (context as Object, requestId as String) as Void
      HTTP_CODE_RANGE = {
        SUCCESS_FROM: 0,
        ERROR_FROM: 400,
      }
	  ' Context were it was created
      m = context
      response = Invalid
      request = m._getRequest(requestId)
      m.clearRequestFromActiveQueue(requestId)
  
      if (request <> Invalid AND request.getResponse() <> Invalid)
        response = request.getResponse()
      end if
  
      if (response <> Invalid)
        parsedResponse = parseJSON(response)
        request.setResponse(parsedResponse)

		' Good response
        if (parsedResponse.code > HTTP_CODE_RANGE.SUCCESS_FROM AND parsedResponse.code < HTTP_CODE_RANGE.ERROR_FROM)
			m.dispatchEvent(m.LOAD_SUCCESS, request)
        else ' Error due token or similar 
			m.dispatchEvent(m.LOAD_SERVICE_FAIL, request)
        end if

      else
		' Set a network fail
        response = { code: HTTP_CODE_RANGE.SUCCESS_FROM }
        request.setResponse(response)
		m.dispatchEvent(m.LOAD_NETWORK_FAIL, request)
      end if
    end function
  
    return prototype
  end function
  