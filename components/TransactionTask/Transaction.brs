function init()
    m.top.functionName = "load"
end function

function load()
    if (m.top <> Invalid)
        json_str = invalid

        json_str = m.top.request

        ' Check type of request
        json_obj = ParseJson(json_str)
        transaction = GetAbstractTransaction(json_obj)

        if (transaction <> Invalid)
            transaction.start() 'Start request
            m.top.response = transaction.getResponse() 'Get response
        else ' If the transaction do not exists an object with cero is set
            response_obj = {code:0}
            response_obj_as_json_str = FormatJson(response_obj)
            m.top.response = response_obj_as_json_str
        end if
    end if
end function

function GetAbstractTransaction(request as Object) as Object
    location = request.location
    protocol = location.tokenize(":")[0]

    if (protocol = "https")
        return HttpsTransaction(request)
    else
        return Invalid
    end if
end function
