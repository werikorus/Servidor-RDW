object DataModule1: TDataModule1
  OldCreateOrder = False
  Encoding = esASCII
  Height = 302
  Width = 264
  object cadastro: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'buscar'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'JSON'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'clientes'
        OnReplyEventByType = evEventseventosReplyEventByType
      end>
    Left = 80
    Top = 72
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=DEV-15\RADINFO'
      'Password=rad123'
      'Database=RestDataWare_DB'
      'User_Name=sa'
      'DriverID=MSSQL')
    Left = 80
    Top = 128
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 80
    Top = 184
  end
  object qcmd: TFDQuery
    Connection = FDConnection1
    Left = 168
    Top = 136
  end
end
