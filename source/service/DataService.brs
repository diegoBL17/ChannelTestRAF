function DataService() as object
    if (m._DataSingleton = invalid)
        prototype = TransactionService()

        prototype.requestDataHomeService = function()
            BASE_URL = "https://cdn-media.brightline.tv/recruiting/roku/testapi.json"
            requestHeaders = {}

            options = {
                location: BASE_URL,
                method: "GET",
            }

            m._load(options)
        end function

        m._DataSingleton = prototype

        prototype.destroy = function()
            DestroyDataService()
        end function
    end if

    return m._DataSingleton
end function

function DestroyDataService() as void
    if (m._DataSingleton <> invalid)
        m._DataSingleton = invalid
    end if
end function