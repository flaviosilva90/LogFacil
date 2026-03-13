object DMPrincipal: TDMPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 200
  Width = 400
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=FB')
    LoginPrompt = False
    Left = 56
    Top = 56
  end
  object Tran: TFDTransaction
    Connection = Conn
    Options.AutoStart = True
    Options.AutoStop = False
    Left = 176
    Top = 56
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 296
    Top = 56
  end
end
