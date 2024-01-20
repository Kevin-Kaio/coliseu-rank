local ColosseumController = Class(function (self,inst)
    self.inst=inst
    self.isgaming=net_bool(self.inst.GUID,"isgaming","onisgaming")
end)

return ColosseumController
