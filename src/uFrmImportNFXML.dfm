object FrmImportNFXML: TFrmImportNFXML
  Left = 0
  Top = 0
  Caption = 'Importar NF-e XML - Entrada'
  ClientHeight = 700
  ClientWidth = 960
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 960
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 348
      Height = 19
      Caption = 'IMPORTA'#199#195'O DE NF-e XML - ENTRADA DE COMPRA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlArquivo: TPanel
    Left = 0
    Top = 40
    Width = 960
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblArquivo: TLabel
      Left = 8
      Top = 14
      Width = 85
      Height = 17
      Caption = 'Arquivo XML:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtArquivo: TEdit
      Left = 90
      Top = 10
      Width = 540
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object btnSelArquivo: TButton
      Left = 640
      Top = 9
      Width = 130
      Height = 27
      Caption = 'Selecionar XML...'
      TabOrder = 1
      OnClick = btnSelArquivoClick
    end
    object btnLerXML: TButton
      Left = 778
      Top = 9
      Width = 120
      Height = 27
      Caption = 'Ler / Processar'
      Enabled = False
      TabOrder = 2
      OnClick = btnLerXMLClick
    end
  end
  object grpNF: TGroupBox
    Left = 0
    Top = 84
    Width = 480
    Height = 90
    Caption = ' Dados da Nota Fiscal '
    TabOrder = 2
    object lblChave: TLabel
      Left = 8
      Top = 18
      Width = 70
      Height = 17
      Caption = 'Chave NF-e:'
    end
    object lblNumNF: TLabel
      Left = 8
      Top = 50
      Width = 47
      Height = 17
      Caption = 'N'#194#186' NF:'
    end
    object lblSerieNF: TLabel
      Left = 148
      Top = 50
      Width = 45
      Height = 17
      Caption = 'S'#195#169'rie:'
    end
    object lblDtEmissao: TLabel
      Left = 240
      Top = 50
      Width = 59
      Height = 17
      Caption = 'Emiss'#195#163'o:'
    end
    object lblAmbiente: TLabel
      Left = 396
      Top = 50
      Width = 30
      Height = 17
      Caption = 'Amb:'
    end
    object lblVlTotal: TLabel
      Left = 8
      Top = 70
      Width = 51
      Height = 17
      Caption = 'Total NF:'
    end
    object edtChave: TEdit
      Left = 80
      Top = 15
      Width = 380
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtNumNF: TEdit
      Left = 55
      Top = 47
      Width = 80
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtSerieNF: TEdit
      Left = 188
      Top = 47
      Width = 40
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object edtDtEmissao: TEdit
      Left = 293
      Top = 47
      Width = 90
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object edtAmbiente: TEdit
      Left = 420
      Top = 47
      Width = 50
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object edtVlTotalNF: TEdit
      Left = 60
      Top = 67
      Width = 100
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
  end
  object grpEmitente: TPanel
    Left = 482
    Top = 84
    Width = 478
    Height = 90
    BevelOuter = bvLowered
    TabOrder = 3
    object lblEmiCNPJ: TLabel
      Left = 8
      Top = 8
      Width = 86
      Height = 17
      Caption = 'CNPJ Emitente:'
    end
    object lblEmiRazao: TLabel
      Left = 240
      Top = 8
      Width = 85
      Height = 17
      Caption = 'Raz'#195#163'o Social:'
    end
    object lblEmiIE: TLabel
      Left = 8
      Top = 36
      Width = 13
      Height = 17
      Caption = 'IE:'
    end
    object lblEmiFone: TLabel
      Left = 162
      Top = 36
      Width = 31
      Height = 17
      Caption = 'Fone:'
    end
    object lblFornecSistema: TLabel
      Left = 8
      Top = 62
      Width = 97
      Height = 17
      Caption = 'Fornec.Sistema:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtEmiCNPJ: TEdit
      Left = 102
      Top = 5
      Width = 130
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtEmiRazao: TEdit
      Left = 318
      Top = 5
      Width = 150
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtEmiIE: TEdit
      Left = 30
      Top = 33
      Width = 120
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object edtEmiFone: TEdit
      Left = 196
      Top = 33
      Width = 120
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object edtFornecID: TEdit
      Left = 108
      Top = 59
      Width = 50
      Height = 25
      TabOrder = 4
    end
    object edtFornecNome: TEdit
      Left = 162
      Top = 59
      Width = 200
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
    object btnBuscarFornec: TButton
      Left = 368
      Top = 58
      Width = 28
      Height = 25
      Caption = '...'
      TabOrder = 6
      OnClick = btnBuscarFornecClick
    end
  end
  object grpItens: TGroupBox
    Left = 0
    Top = 176
    Width = 960
    Height = 300
    Caption = ' Itens da Nota Fiscal '
    TabOrder = 4
    object lblVincularMP: TLabel
      Left = 4
      Top = 222
      Width = 364
      Height = 17
      Caption = 'Vincule cada item XML a uma Mat'#195#169'ria-Prima do sistema:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sgdItens: TStringGrid
      Left = 4
      Top = 16
      Width = 940
      Height = 200
      ColCount = 9
      DefaultRowHeight = 22
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      TabOrder = 0
      OnClick = sgdItensClick
    end
    object pnlVincular: TPanel
      Left = 4
      Top = 240
      Width = 940
      Height = 36
      BevelOuter = bvNone
      Color = 15660287
      TabOrder = 1
      object lblLinSel: TLabel
        Left = 8
        Top = 10
        Width = 153
        Height = 17
        Caption = 'Selecione um item acima...'
      end
      object edtMPID: TEdit
        Left = 216
        Top = 6
        Width = 55
        Height = 25
        TabOrder = 0
      end
      object edtMPNome: TEdit
        Left = 276
        Top = 6
        Width = 240
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object btnBuscarMP: TButton
        Left = 522
        Top = 5
        Width = 28
        Height = 27
        Caption = '...'
        TabOrder = 2
        OnClick = btnBuscarMPClick
      end
      object btnVincular: TButton
        Left = 558
        Top = 5
        Width = 120
        Height = 27
        Caption = 'Vincular Item'
        Enabled = False
        TabOrder = 3
        OnClick = btnVincularClick
      end
    end
  end
  object grpTotais: TGroupBox
    Left = 0
    Top = 478
    Width = 460
    Height = 60
    Caption = ' Totais da NF '
    TabOrder = 5
    object lblVlProd: TLabel
      Left = 8
      Top = 18
      Width = 56
      Height = 17
      Caption = 'Produtos:'
    end
    object lblVlIPI: TLabel
      Left = 152
      Top = 18
      Width = 16
      Height = 17
      Caption = 'IPI:'
    end
    object lblVlICMS: TLabel
      Left = 248
      Top = 18
      Width = 33
      Height = 17
      Caption = 'ICMS:'
    end
    object lblVlFrete: TLabel
      Left = 8
      Top = 42
      Width = 32
      Height = 17
      Caption = 'Frete:'
    end
    object lblVlDescNF: TLabel
      Left = 126
      Top = 42
      Width = 58
      Height = 17
      Caption = 'Desconto:'
    end
    object lblVlNF: TLabel
      Left = 262
      Top = 42
      Width = 65
      Height = 17
      Caption = 'TOTAL NF:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtVlProd: TEdit
      Left = 64
      Top = 14
      Width = 80
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtVlIPI: TEdit
      Left = 170
      Top = 14
      Width = 70
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtVlICMS: TEdit
      Left = 280
      Top = 14
      Width = 70
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object edtVlFrete: TEdit
      Left = 48
      Top = 38
      Width = 70
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object edtVlDescNF: TEdit
      Left = 184
      Top = 38
      Width = 70
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object edtVlNF: TEdit
      Left = 320
      Top = 38
      Width = 90
      Height = 25
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 650
    Width = 960
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    Color = 15263976
    TabOrder = 6
    object lblStatus: TLabel
      Left = 330
      Top = 15
      Width = 160
      Height = 17
      Caption = 'Aguardando arquivo XML...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object btnImportar: TButton
      Left = 8
      Top = 10
      Width = 200
      Height = 32
      Caption = 'IMPORTAR NF e CRIAR COMPRA'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnImportarClick
    end
    object btnCancelar: TButton
      Left = 216
      Top = 10
      Width = 100
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object dlgAbrir: TOpenDialog
    Left = 880
    Top = 20
  end
end
