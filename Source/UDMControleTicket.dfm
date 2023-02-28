object DMControle: TDMControle
  OldCreateOrder = False
  Height = 286
  Width = 384
  object Banco: TIBDatabase
    Connected = True
    DatabaseName = 'C:\GitHub\ControleTicket\Database\ticket.fdb'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 56
    Top = 56
  end
  object Conexao: TFDConnection
    Params.Strings = (
      'ConnectionDef=TICKETDB')
    Connected = True
    LoginPrompt = False
    Transaction = Secao
    UpdateTransaction = Secao
    Left = 155
    Top = 56
  end
  object Secao: TFDTransaction
    Connection = Conexao
    Left = 256
    Top = 56
  end
  object fdqTicketFuncionario: TFDQuery
    BeforePost = fdqTicketFuncionarioBeforePost
    AfterScroll = fdqTicketFuncionarioAfterScroll
    OnNewRecord = fdqTicketFuncionarioNewRecord
    Connection = Conexao
    SQL.Strings = (
      'SELECT T.ID, T.ID_FUNCIONARIO FUNCIONARIO, T.QUANTIDADE,'
      '       T.SITUACAO, T.DATA_ENTREGA'
      'FROM TICKETFUNCIONARIO T'
      'INNER JOIN FUNCIONARIO F ON(F.ID = T.ID_FUNCIONARIO)'
      'WHERE F.ID = COALESCE(:ID_FUNCIONARIO, F.ID)'
      'AND   F.NOME CONTAINING COALESCE(:NOME_FUNCIONARIO, F.NOME)')
    Left = 56
    Top = 176
    ParamData = <
      item
        Name = 'ID_FUNCIONARIO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NOME_FUNCIONARIO'
        DataType = ftWideString
        ParamType = ptInput
        Size = 60
        Value = ''
      end>
    object fdqTicketFuncionarioID: TIntegerField
      Alignment = taCenter
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdqTicketFuncionarioQUANTIDADE: TIntegerField
      Alignment = taCenter
      DefaultExpression = '1'
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Required = True
    end
    object fdqTicketFuncionarioSITUACAO: TWideStringField
      Alignment = taCenter
      FieldName = 'SITUACAO'
      Origin = 'SITUACAO'
      Required = True
      OnGetText = fdqTicketFuncionarioSITUACAOGetText
      FixedChar = True
      Size = 1
    end
    object fdqTicketFuncionarioDATA_ENTREGA: TSQLTimeStampField
      Alignment = taCenter
      FieldName = 'DATA_ENTREGA'
      Origin = 'DATA_ENTREGA'
    end
    object fdqTicketFuncionarioFUNCIONARIO: TIntegerField
      FieldName = 'FUNCIONARIO'
      LookupDataSet = fdqFuncionario
      LookupKeyFields = 'ID'
      LookupResultField = 'NOME'
      KeyFields = 'FUNCIONARIO'
      Origin = 'ID_FUNCIONARIO'
      Required = True
      OnGetText = fdqTicketFuncionarioFUNCIONARIOGetText
    end
  end
  object dsTicketFuncionario: TDataSource
    DataSet = fdqTicketFuncionario
    Left = 162
    Top = 168
  end
  object dsFuncionario: TDataSource
    DataSet = fdqFuncionario
    Left = 162
    Top = 120
  end
  object fdqFuncionario: TFDQuery
    Active = True
    BeforePost = fdqFuncionarioBeforePost
    AfterScroll = fdqFuncionarioAfterScroll
    OnNewRecord = fdqFuncionarioNewRecord
    Connection = Conexao
    UpdateTransaction = Secao
    SQL.Strings = (
      'SELECT F.ID, F.NOME, F.CPF, '
      '       F.SITUACAO, F.DATA_ALTERACAO'
      'FROM FUNCIONARIO F'
      'WHERE F.ID = COALESCE(:ID, F.ID)'
      'AND   F.NOME = COALESCE(:NOME, F.NOME)'
      'AND   F.CPF = COALESCE(:CPF, F.CPF)')
    Left = 56
    Top = 120
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'NOME'
        DataType = ftWideString
        ParamType = ptInput
        Size = 60
      end
      item
        Name = 'CPF'
        DataType = ftWideString
        ParamType = ptInput
        Size = 11
      end>
    object fdqFuncionarioID: TIntegerField
      Alignment = taCenter
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fdqFuncionarioNOME: TWideStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      OnValidate = fdqFuncionarioNOMEValidate
      Size = 60
    end
    object fdqFuncionarioCPF: TWideStringField
      Alignment = taCenter
      FieldName = 'CPF'
      Origin = 'CPF'
      Required = True
      OnValidate = fdqFuncionarioCPFValidate
      EditMask = '999.999.999-99;0;_'
      Size = 11
    end
    object fdqFuncionarioSITUACAO: TWideStringField
      Alignment = taCenter
      FieldName = 'SITUACAO'
      Origin = 'SITUACAO'
      Required = True
      OnGetText = fdqFuncionarioSITUACAOGetText
      Size = 1
    end
    object fdqFuncionarioDATA_ALTERACAO: TSQLTimeStampField
      Alignment = taCenter
      FieldName = 'DATA_ALTERACAO'
      Origin = 'DATA_ALTERACAO'
    end
  end
  object Consulta: TFDQuery
    Connection = Conexao
    Transaction = Secao
    Left = 56
    Top = 224
  end
  object fdqRelatorio: TFDQuery
    Connection = Conexao
    Transaction = Secao
    SQL.Strings = (
      
        'SELECT F.ID||'#39' - '#39'||F.NOME NOME, COALESCE(SUM(T.QUANTIDADE), 0) ' +
        'QUANTIDADE'
      'FROM FUNCIONARIO F'
      'LEFT JOIN TICKETFUNCIONARIO T ON (F.ID = T.ID_FUNCIONARIO'
      
        '                                  AND T.DATA_ENTREGA >= COALESCE' +
        '(:DT_INICIAL, T.DATA_ENTREGA)'
      
        '                                  AND T.DATA_ENTREGA <= COALESCE' +
        '(:DT_FINAL, T.DATA_ENTREGA))'
      'WHERE F.ID = COALESCE(:ID, F.ID)'
      'AND F.NOME CONTAINING COALESCE(:NOME, F.NOME)'
      'GROUP BY 1'
      'UNION ALL '
      'SELECT '#39'TOTAL'#39' NOME, COALESCE(SUM(T.QUANTIDADE), 0) QUANTIDADE'
      'FROM FUNCIONARIO F'
      'LEFT JOIN TICKETFUNCIONARIO T ON (F.ID = T.ID_FUNCIONARIO'
      
        '                                  AND T.DATA_ENTREGA >= COALESCE' +
        '(:DT_INICIAL, T.DATA_ENTREGA)'
      
        '                                  AND T.DATA_ENTREGA <= COALESCE' +
        '(:DT_FINAL, T.DATA_ENTREGA))'
      'WHERE F.ID = COALESCE(:ID, F.ID)'
      'AND F.NOME CONTAINING COALESCE(:NOME, F.NOME)'
      'GROUP BY 1')
    Left = 168
    Top = 224
    ParamData = <
      item
        Name = 'DT_INICIAL'
        DataType = ftFixedWideChar
        ParamType = ptInput
        Size = 10
        Value = Null
      end
      item
        Name = 'DT_FINAL'
        DataType = ftFixedWideChar
        ParamType = ptInput
        Size = 10
      end
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NOME'
        DataType = ftWideString
        ParamType = ptInput
        Size = 60
      end>
    object fdqRelatorioNOME: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOME'
      Origin = 'NOME'
      ProviderFlags = []
      ReadOnly = True
      Size = 74
    end
    object fdqRelatorioQUANTIDADE: TLargeintField
      AutoGenerateValue = arDefault
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object dsRelatorio: TDataSource
    DataSet = fdqRelatorio
    Left = 240
    Top = 224
  end
end