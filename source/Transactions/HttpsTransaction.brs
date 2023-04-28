function HttpsTransaction(options as Object) as Object
    prototype = {}

    '////////////////////////////
    '/// PUBLIC API ///
    '////////////////////////////
    
    ' When object created the basic values are set
    ' Like url and type of request
    prototype._request = options
    prototype._response = invalid

    prototype.getResponse = function () as object
        return m._response
    end function

    prototype.setResponse = function (value as Dynamic) as Void
        m._response = value
    end function    

    prototype.start = function() as Void
        ' Create objects to maque request to API
        request = CreateObject("roUrlTransfer")
        request.SetCertificatesFile("common:/certs/ca-bundle.crt")
        request.InitClientCertificates()
        request.SetUrl(m._request.location)
        request.setRequest(m._request.method)

        port = CreateObject("roMessagePort")
        request.SetMessagePort(port) ' Req needs a port response
        request.retainBodyOnError(true)
        request.EnableEncodings(true)

        if (request.AsyncGetToString())
            response = port.waitMessage(10000)

            response_obj = {}

            ' Get basic data from request
            response_obj.data = response.getString()
            response_obj.code = response.getResponseCode()
            response_obj.headers = response.getResponseHeaders()

            response_obj_as_json_str = FormatJson(response_obj)
            m._response = response_obj_as_json_str
        endif

    end function

    return prototype
end function
