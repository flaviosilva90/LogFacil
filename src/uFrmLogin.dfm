object FrmLogin: TFrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'LogF'#225'cil - Login'
  ClientHeight = 380
  ClientWidth = 420
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 17
  object lblVersao: TLabel
    Left = 0
    Top = 360
    Width = 420
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'vers'#227'o 2.0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 380
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    TabOrder = 0
    ExplicitWidth = 416
    ExplicitHeight = 379
    object pnlCard: TPanel
      Left = 40
      Top = 40
      Width = 340
      Height = 300
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object lblTitulo: TLabel
        Left = 0
        Top = 16
        Width = 340
        Height = 36
        Alignment = taCenter
        AutoSize = False
        Caption = 'LogF'#225'cil'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10040064
        Font.Height = -27
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSubtitulo: TLabel
        Left = 0
        Top = 56
        Width = 340
        Height = 20
        Alignment = taCenter
        AutoSize = False
        Caption = 'Sistema ERP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblLogin: TLabel
        Left = 20
        Top = 96
        Width = 35
        Height = 17
        Caption = 'Login:'
      end
      object lblSenha: TLabel
        Left = 20
        Top = 154
        Width = 38
        Height = 17
        Caption = 'Senha:'
      end
      object edtLogin: TEdit
        Left = 20
        Top = 116
        Width = 300
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object edtSenha: TEdit
        Left = 20
        Top = 174
        Width = 300
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        PasswordChar = '*'
        TabOrder = 1
        OnKeyPress = edtSenhaKeyPress
      end
      object btnEntrar: TButton
        Left = 20
        Top = 224
        Width = 300
        Height = 40
        Caption = 'ENTRAR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnEntrarClick
      end
    end
  end
end
