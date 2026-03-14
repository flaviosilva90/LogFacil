object DMPrincipal: TDMPrincipal
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 200
  Width = 400
  object Conn: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Server=localhost'
      'CharacterSet=UTF8'
      'Database=C:\LogFacil\LOGFACIL.FDB'
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
