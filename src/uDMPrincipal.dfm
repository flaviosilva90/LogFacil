object DMPrincipal: TDMPrincipal
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 200
  Width = 400
  object Conn: TFDConnection
    Params.Strings = (
      'Database=C:\LogFacil\LOGFACIL.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 56
    Top = 56
  end
  object Tran: TFDTransaction
    Options.AutoStop = False
    Connection = Conn
    Left = 176
    Top = 56
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 296
    Top = 56
  end
end
