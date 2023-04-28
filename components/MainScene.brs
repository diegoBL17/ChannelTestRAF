sub init()
    m.global.id = "GlobalNode"

    m.appController = GetAppController()
    m.appController.setRoots(m.top.findNode("MainView"))

    m.appController.init()
end sub
