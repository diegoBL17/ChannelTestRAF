function GetTransactionPool() as Object
  if (m._transactionPoolSingleton = Invalid)

    prototype = {}

    prototype._requestQueue = []
    prototype._activeRequestQueue = {}
    prototype._transactionPool = []
    prototype._activeTransactionPool = {}

    '////////////////////////////
    '/// PUBLIC API ///
    '////////////////////////////

    ' Here is created the task for handle transactions, could have multiple
    prototype.init = function() as Void
        trans = createObject("roSGNode", "Transaction")
        m._transactionPool.push(trans)
    end function

    ' Store requests 
    prototype.queue = function(request as Object) as Void
        m._requestQueue.push(request)
    end function

    prototype.queueFirst = function(request as Object) as Void
        m._requestQueue.unshift(request)
    end function

    prototype.processQueue = function() as Void
        m._processQueue()
    end function

    ' Get request by id
    prototype.getRequest = function(transactionId) as Object
        return m._activeRequestQueue.Lookup(transactionId)
    end function

    prototype._getTransaction = function() as Object
        return m._transactionPool.shift() 
    end function

    '////////////////////////////
    '/// PRIVATE API ///
    '////////////////////////////

    prototype._processQueue = function ()
        ' Validation of a present request
        if (m._requestQueue.count() = 0)
            return invalid
        end if

        transaction = m._getTransaction()
        if (transaction = Invalid)
            return invalid
        end if

        request = m._requestQueue.shift()
        transaction.id = request.id

        ' This way we can search a way faster a transaction using lookup
        m._activeRequestQueue.addReplace(request.id, request)
        m._activeTransactionPool.addReplace(transaction.id, transaction)

        m._configureTransaction(transaction, request)
    end function

    ' Here it's setup functions to be executed when the request respond
    prototype._configureTransaction = function (transaction as Object, request as Object) as Void
        transaction.observeField("response", "TransactionPool_transactionComplete")

        reqParams = FormatJson({ location: request.location, method: request.method })

        transaction.request = reqParams
        transaction.control = "RUN" ' Running task
        transaction.observeField("state", "TransactionPool_stateChanged")
    end function

    ' Delete actual request, push the cleaned transaction, delete in active
    prototype._removeTransaction = function (transaction as Object) as Void
        ' Restart values of transaction
        transactionId = transaction.id
        m._activeRequestQueue.Delete(transactionId)
        transaction.unobserveField("response")
        transaction.unobserveField("state")
        transaction.control = "INIT"
        transaction.request = ""
        transaction.response = ""
        transaction.id = ""

        m._transactionPool.push(transaction)
        m._activeTransactionPool.Delete(transactionId)
    end function

    m._transactionPoolSingleton = prototype
  end if

  return m._transactionPoolSingleton
end function

' Here we got the response of the API, set the value to the object 
' Then call _transactionComplete on the transaction service
function TransactionPool_transactionComplete(transactionNode as Object) as Void
    transactionId = transactionNode.getNode()
    request = GetTransactionPool().getRequest(transactionId)

    if (request <> Invalid AND transactionNode <> Invalid)
        request.setResponse(transactionNode.getData())

        request.callback(request.context, transactionId)
    end if
end function

' Delete transaction when finsih
function TransactionPool_stateChanged(event) as Void
    if (event.getData() = "stop")
        transaction = event.getRoSGNode()
        GetTransactionPool()._removeTransaction(transaction)
    end if
end function

' Delete whole object
function TransactionPool_destroy() as Void
    if (m._transactionPoolSingleton <> Invalid)
        m._transactionPoolSingleton = Invalid
    end if
end function
