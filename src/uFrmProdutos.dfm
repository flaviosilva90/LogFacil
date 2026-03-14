object FrmProdutos: TFrmProdutos
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produtos'
  ClientHeight = 700
  ClientWidth = 860
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
    Width = 860
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 175
      Height = 19
      Caption = 'CADASTRO DE PRODUTOS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlFiltro: TPanel
    Left = 0
    Top = 40
    Width = 860
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtFiltro: TEdit
      Left = 8
      Top = 10
      Width = 260
      Height = 25
      TabOrder = 0
    end
    object chkSoAtivos: TCheckBox
      Left = 280
      Top = 13
      Width = 80
      Height = 17
      Caption = 'S'#243' ativos'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object btnBuscar: TButton
      Left = 368
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClick
    end
    object btnNovo: TButton
      Left = 456
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Novo'
      TabOrder = 3
      OnClick = btnNovoClick
    end
  end
  object sgdLista: TStringGrid
    Left = 0
    Top = 84
    Width = 860
    Height = 200
    Align = alTop
    ColCount = 8
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 284
    Width = 860
    Height = 416
    Align = alTop
    BevelOuter = bvNone
    Color = 16448250
    TabOrder = 3
    Visible = False
    object lblCodigo: TLabel
      Left = 8
      Top = 8
      Width = 55
      Height = 17
      Caption = 'C'#243'digo: *'
    end
    object lblCodBar: TLabel
      Left = 140
      Top = 8
      Width = 68
      Height = 17
      Caption = 'C'#243'd. Barras'
    end
    object lblDesc: TLabel
      Left = 302
      Top = 8
      Width = 69
      Height = 17
      Caption = 'Descri'#231#227'o: *'
    end
    object lblCategoria: TLabel
      Left = 8
      Top = 62
      Width = 57
      Height = 17
      Caption = 'Categoria'
    end
    object lblUnidade: TLabel
      Left = 220
      Top = 62
      Width = 61
      Height = 17
      Caption = 'Unidade: *'
    end
    object lblPrecoCusto: TLabel
      Left = 382
      Top = 62
      Width = 70
      Height = 17
      Caption = 'Pre'#231'o Custo'
    end
    object lblPrecoVenda: TLabel
      Left = 504
      Top = 62
      Width = 85
      Height = 17
      Caption = 'Pre'#231'o Venda: *'
    end
    object lblMargem: TLabel
      Left = 626
      Top = 62
      Width = 53
      Height = 17
      Caption = 'Margem:'
    end
    object lblMargemVal: TLabel
      Left = 626
      Top = 80
      Width = 36
      Height = 17
      Caption = '0,00%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEstAtual: TLabel
      Left = 8
      Top = 116
      Width = 53
      Height = 17
      Caption = 'Est. Atual'
    end
    object lblEstMin: TLabel
      Left = 120
      Top = 116
      Width = 49
      Height = 17
      Caption = 'Est. M'#237'n.'
    end
    object lblEstMax: TLabel
      Left = 232
      Top = 116
      Width = 52
      Height = 17
      Caption = 'Est. M'#225'x.'
    end
    object lblNCM: TLabel
      Left = 344
      Top = 116
      Width = 30
      Height = 17
      Caption = 'NCM'
    end
    object lblCFOP: TLabel
      Left = 456
      Top = 116
      Width = 31
      Height = 17
      Caption = 'CFOP'
    end
    object lblAtivo: TLabel
      Left = 548
      Top = 116
      Width = 29
      Height = 17
      Caption = 'Ativo'
    end
    object lblDescComp: TLabel
      Left = 8
      Top = 170
      Width = 117
      Height = 17
      Caption = 'Descri'#231#227'o Completa'
    end
    object lblObs: TLabel
      Left = 8
      Top = 258
      Width = 76
      Height = 17
      Caption = 'Observa'#231#245'es'
    end
    object edtCodigo: TEdit
      Left = 8
      Top = 26
      Width = 120
      Height = 25
      MaxLength = 20
      TabOrder = 0
    end
    object edtCodBar: TEdit
      Left = 140
      Top = 26
      Width = 150
      Height = 25
      TabOrder = 1
    end
    object edtDesc: TEdit
      Left = 302
      Top = 26
      Width = 420
      Height = 25
      MaxLength = 100
      TabOrder = 2
    end
    object cboCategoria: TComboBox
      Left = 8
      Top = 80
      Width = 200
      Height = 25
      Style = csDropDownList
      TabOrder = 3
    end
    object cboUnidade: TComboBox
      Left = 220
      Top = 80
      Width = 150
      Height = 25
      Style = csDropDownList
      TabOrder = 4
    end
    object edtPrecoCusto: TEdit
      Left = 382
      Top = 80
      Width = 110
      Height = 25
      TabOrder = 5
      Text = '0,00'
      OnChange = edtPrecoCustoChange
    end
    object edtPrecoVenda: TEdit
      Left = 504
      Top = 80
      Width = 110
      Height = 25
      TabOrder = 6
      Text = '0,00'
      OnChange = edtPrecoVendaChange
    end
    object edtEstAtual: TEdit
      Left = 8
      Top = 134
      Width = 100
      Height = 25
      TabOrder = 7
      Text = '0,000'
    end
    object edtEstMin: TEdit
      Left = 120
      Top = 134
      Width = 100
      Height = 25
      TabOrder = 8
      Text = '0,000'
    end
    object edtEstMax: TEdit
      Left = 232
      Top = 134
      Width = 100
      Height = 25
      TabOrder = 9
      Text = '0,000'
    end
    object edtNCM: TEdit
      Left = 344
      Top = 134
      Width = 100
      Height = 25
      MaxLength = 10
      TabOrder = 10
    end
    object edtCFOP: TEdit
      Left = 456
      Top = 134
      Width = 80
      Height = 25
      MaxLength = 6
      TabOrder = 11
    end
    object cboAtivo: TComboBox
      Left = 548
      Top = 134
      Width = 60
      Height = 25
      Style = csDropDownList
      TabOrder = 12
    end
    object mmoDescComp: TMemo
      Left = 8
      Top = 188
      Width = 700
      Height = 60
      TabOrder = 13
    end
    object mmoObs: TMemo
      Left = 8
      Top = 276
      Width = 700
      Height = 50
      TabOrder = 14
    end
    object btnSalvar: TButton
      Left = 8
      Top = 336
      Width = 100
      Height = 32
      Caption = 'Salvar'
      TabOrder = 15
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 116
      Top = 336
      Width = 100
      Height = 32
      Caption = 'Excluir'
      Enabled = False
      TabOrder = 16
      OnClick = btnExcluirClick
    end
    object btnCancelar: TButton
      Left = 224
      Top = 336
      Width = 100
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 17
      OnClick = btnCancelarClick
    end
  end
end
