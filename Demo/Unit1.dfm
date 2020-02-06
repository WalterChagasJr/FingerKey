object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 424
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 408
    Width = 483
    Height = 13
    Align = alBottom
    Color = 11793649
    ParentColor = False
    Transparent = False
    Layout = tlCenter
    ExplicitWidth = 3
  end
  object Button1: TButton
    Left = 145
    Top = 43
    Width = 145
    Height = 25
    Caption = 'Cadastrar'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 336
    Top = 43
    Width = 145
    Height = 25
    Caption = 'Verificar'
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 8
    Width = 193
    Height = 25
    Caption = 'Conectar com o finger'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 216
    Top = 8
    Width = 193
    Height = 25
    Caption = 'Desconectar do finger'
    Enabled = False
    TabOrder = 3
    OnClick = Button4Click
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 74
    Width = 473
    Height = 303
    DataSource = DsDigital
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'IdUsuario'
        Title.Caption = 'Id Usu'#225'rio'
        Width = 105
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DigitalUsuario'
        Title.Caption = 'Digital'
        Width = 334
        Visible = True
      end>
  end
  object edtIDUsuario: TEdit
    Left = 8
    Top = 47
    Width = 121
    Height = 21
    TabOrder = 5
    TextHint = 'Id usu'#225'rio'
  end
  object btnExportarDados: TButton
    Left = 216
    Top = 377
    Width = 129
    Height = 25
    Caption = 'Exportar Dados'
    Enabled = False
    TabOrder = 6
    OnClick = btnExportarDadosClick
  end
  object btnImportarDados: TButton
    Left = 351
    Top = 377
    Width = 129
    Height = 25
    Caption = 'Importar Dados'
    TabOrder = 7
    OnClick = btnImportarDadosClick
  end
  object FingerKey: TFingerKey
    TipoDeDispotivos = fkHamsterNitgen
    Initizalization = FingerKeyInitizalization
    Left = 272
    Top = 136
  end
  object FDDigitais: TFDMemTable
    Active = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 432
    Top = 144
    object FDDigitaisIdUsuario: TStringField
      FieldName = 'IdUsuario'
      Size = 100
    end
    object FDDigitaisDigitalUsuario: TBlobField
      FieldName = 'DigitalUsuario'
    end
  end
  object DsDigital: TDataSource
    DataSet = FDDigitais
    Left = 440
    Top = 96
  end
  object OpenDialog1: TOpenDialog
    Filter = 'XML|*.XML'
    Title = 'Localizar base XML'
    Left = 432
    Top = 256
  end
  object FDStanStorageXMLLink1: TFDStanStorageXMLLink
    Left = 440
    Top = 200
  end
end
