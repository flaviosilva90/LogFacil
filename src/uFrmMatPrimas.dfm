object FrmMatPrimas: TFrmMatPrimas
  Left = 0
  Top = 0
  Caption = 'Cadastro de Mat'#233'rias-Primas'
  ClientHeight = 660
  ClientWidth = 820
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
    Width = 820
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 227
      Height = 19
      Caption = 'CADASTRO DE MAT'#201'RIAS-PRIMAS'
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
    Width = 820
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
    Width = 820
    Height = 200
    Align = alTop
    ColCount = 7
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 284
    Width = 820
    Height = 376
    Align = alTop
    BevelOuter = bvNone
    Color = 16448250
    TabOrder = 3
    Visible = False
    object lblCodigo: TLabel
      Left = 8
      Top = 10
      Width = 55
      Height = 17
      Caption = 'C'#243'digo: *'
    end
    object lblDesc: TLabel
      Left = 140
      Top = 10
      Width = 69
      Height = 17
      Caption = 'Descri'#231#227'o: *'
    end
    object lblCategoria: TLabel
      Left = 492
      Top = 10
      Width = 57
      Height = 17
      Caption = 'Categoria'
    end
    object lblUnidade: TLabel
      Left = 8
      Top = 64
      Width = 61
      Height = 17
      Caption = 'Unidade: *'
    end
    object lblCustoMedio: TLabel
      Left = 180
      Top = 64
      Width = 75
      Height = 17
      Caption = 'Custo M'#233'dio'
    end
    object lblEstAtual: TLabel
      Left = 302
      Top = 64
      Width = 53
      Height = 17
      Caption = 'Est. Atual'
    end
    object lblEstMin: TLabel
      Left = 414
      Top = 64
      Width = 49
      Height = 17
      Caption = 'Est. M'#237'n.'
    end
    object lblEstMax: TLabel
      Left = 526
      Top = 64
      Width = 52
      Height = 17
      Caption = 'Est. M'#225'x.'
    end
    object lblLocalizacao: TLabel
      Left = 8
      Top = 118
      Width = 67
      Height = 17
      Caption = 'Localiza'#231#227'o'
    end
    object lblAtivo: TLabel
      Left = 180
      Top = 118
      Width = 29
      Height = 17
      Caption = 'Ativo'
    end
    object lblObs: TLabel
      Left = 8
      Top = 172
      Width = 76
      Height = 17
      Caption = 'Observa'#231#245'es'
    end
    object edtCodigo: TEdit
      Left = 8
      Top = 28
      Width = 120
      Height = 25
      MaxLength = 20
      TabOrder = 0
    end
    object edtDesc: TEdit
      Left = 140
      Top = 28
      Width = 340
      Height = 25
      MaxLength = 100
      TabOrder = 1
    end
    object cboCategoria: TComboBox
      Left = 492
      Top = 28
      Width = 200
      Height = 25
      Style = csDropDownList
      TabOrder = 2
    end
    object cboUnidade: TComboBox
      Left = 8
      Top = 82
      Width = 160
      Height = 25
      Style = csDropDownList
      TabOrder = 3
    end
    object edtCustoMedio: TEdit
      Left = 180
      Top = 82
      Width = 110
      Height = 25
      TabOrder = 4
      Text = '0,00'
    end
    object edtEstAtual: TEdit
      Left = 302
      Top = 82
      Width = 100
      Height = 25
      TabOrder = 5
      Text = '0,000'
    end
    object edtEstMin: TEdit
      Left = 414
      Top = 82
      Width = 100
      Height = 25
      TabOrder = 6
      Text = '0,000'
    end
    object edtEstMax: TEdit
      Left = 526
      Top = 82
      Width = 100
      Height = 25
      TabOrder = 7
      Text = '0,000'
    end
    object edtLocalizacao: TEdit
      Left = 8
      Top = 136
      Width = 160
      Height = 25
      TabOrder = 8
    end
    object cboAtivo: TComboBox
      Left = 180
      Top = 136
      Width = 60
      Height = 25
      Style = csDropDownList
      TabOrder = 9
    end
    object mmoObs: TMemo
      Left = 8
      Top = 190
      Width = 680
      Height = 70
      TabOrder = 10
    end
    object btnSalvar: TButton
      Left = 8
      Top = 276
      Width = 100
      Height = 32
      Caption = 'Salvar'
      TabOrder = 11
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 116
      Top = 276
      Width = 100
      Height = 32
      Caption = 'Excluir'
      Enabled = False
      TabOrder = 12
      OnClick = btnExcluirClick
    end
    object btnCancelar: TButton
      Left = 224
      Top = 276
      Width = 100
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 13
      OnClick = btnCancelarClick
    end
  end
end
