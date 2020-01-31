object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 202
  ClientWidth = 447
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
    Top = 176
    Width = 441
    Height = 23
    Align = alBottom
    Color = 11793649
    ParentColor = False
    Transparent = False
    Layout = tlCenter
  end
  object Button1: TButton
    Left = 9
    Top = 56
    Width = 145
    Height = 25
    Caption = 'Cadastrar'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 177
    Top = 56
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
  object FingerKey: TFingerKey
    TipoDeDispotivos = fkHamsterNitgen
    Initizalization = FingerKeyInitizalization
    Left = 352
    Top = 56
  end
end
