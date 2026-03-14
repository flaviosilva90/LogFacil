object FrmContasReceber: TFrmContasReceber
  Left = 0
  Top = 0
  Caption = 'Contas a Receber'
  ClientHeight = 749
  ClientWidth = 1000
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
    Width = 1000
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 3368448
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 131
      Height = 19
      Caption = 'CONTAS A RECEBER'
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
    Width = 1000
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtFiltro: TEdit
      Left = 8
      Top = 10
      Width = 180
      Height = 25
      TabOrder = 0
    end
    object edtDtDe: TDateTimePicker
      Left = 198
      Top = 10
      Width = 110
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.928466701385332300
      TabOrder = 1
    end
    object edtDtAte: TDateTimePicker
      Left = 316
      Top = 10
      Width = 110
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.928466701385332300
      TabOrder = 2
    end
    object cboStatusFiltro: TComboBox
      Left = 434
      Top = 10
      Width = 140
      Height = 25
      Style = csDropDownList
      TabOrder = 3
    end
    object btnBuscar: TButton
      Left = 584
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 4
      OnClick = btnBuscarClick
    end
    object btnNova: TButton
      Left = 672
      Top = 9
      Width = 100
      Height = 27
      Caption = 'Nova Conta'
      TabOrder = 5
      OnClick = btnNovaClick
    end
  end
  object pnlResumo: TPanel
    Left = 0
    Top = 84
    Width = 1000
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    Color = 14745568
    TabOrder = 2
    object lblTotAberto: TLabel
      Left = 8
      Top = 7
      Width = 114
      Height = 17
      Caption = 'A Receber: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotVencido: TLabel
      Left = 220
      Top = 7
      Width = 106
      Height = 17
      Caption = 'Vencidas: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotRecebido: TLabel
      Left = 420
      Top = 7
      Width = 108
      Height = 17
      Caption = 'Recebido: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object sgdLista: TStringGrid
    Left = 0
    Top = 114
    Width = 1000
    Height = 200
    Align = alTop
    ColCount = 10
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 3
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 314
    Width = 1000
    Height = 446
    Align = alTop
    BevelOuter = bvNone
    Color = 16448250
    TabOrder = 4
    Visible = False
    object lblDescricao: TLabel
      Left = 8
      Top = 8
      Width = 69
      Height = 17
      Caption = 'Descri'#231#227'o: *'
    end
    object lblCliente: TLabel
      Left = 380
      Top = 8
      Width = 39
      Height = 17
      Caption = 'Cliente'
    end
    object lblDtEmissao: TLabel
      Left = 8
      Top = 62
      Width = 48
      Height = 17
      Caption = 'Emiss'#227'o'
    end
    object lblDtVencimento: TLabel
      Left = 140
      Top = 62
      Width = 79
      Height = 17
      Caption = 'Vencimento: *'
    end
    object lblVlOriginal: TLabel
      Left = 272
      Top = 62
      Width = 92
      Height = 17
      Caption = 'Valor Original: *'
    end
    object lblFormaPgto: TLabel
      Left = 404
      Top = 62
      Width = 96
      Height = 17
      Caption = 'Forma Esperada'
    end
    object lblParcela: TLabel
      Left = 596
      Top = 62
      Width = 42
      Height = 17
      Caption = 'Parcela'
    end
    object lblTotalParcelas: TLabel
      Left = 656
      Top = 62
      Width = 15
      Height = 17
      Caption = 'de'
    end
    object lblNFNum: TLabel
      Left = 8
      Top = 116
      Width = 51
      Height = 17
      Caption = 'NF N'#250'm.'
    end
    object lblHistorico: TLabel
      Left = 140
      Top = 116
      Width = 52
      Height = 17
      Caption = 'Hist'#243'rico'
    end
    object lblStatusEd: TLabel
      Left = 552
      Top = 116
      Width = 35
      Height = 17
      Caption = 'Status'
    end
    object lblObs: TLabel
      Left = 8
      Top = 170
      Width = 27
      Height = 17
      Caption = 'Obs.'
    end
    object lblRecebimentos: TLabel
      Left = 8
      Top = 258
      Width = 169
      Height = 17
      Caption = 'Hist'#243'rico de Recebimentos:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtDescricao: TEdit
      Left = 8
      Top = 26
      Width = 360
      Height = 25
      MaxLength = 100
      TabOrder = 0
    end
    object edtClienteID: TEdit
      Left = 380
      Top = 26
      Width = 55
      Height = 25
      TabOrder = 1
    end
    object edtClienteNome: TEdit
      Left = 440
      Top = 26
      Width = 260
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object btnBuscarCli: TButton
      Left = 706
      Top = 25
      Width = 28
      Height = 27
      Caption = '...'
      TabOrder = 3
      OnClick = btnBuscarCliClick
    end
    object edtDtEmissao: TDateTimePicker
      Left = 8
      Top = 80
      Width = 120
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.928466701385332300
      TabOrder = 4
    end
    object edtDtVenc: TDateTimePicker
      Left = 140
      Top = 80
      Width = 120
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.928466701385332300
      TabOrder = 5
    end
    object edtVlOriginal: TEdit
      Left = 272
      Top = 80
      Width = 120
      Height = 25
      TabOrder = 6
      Text = '0,00'
    end
    object cboFormaPgto: TComboBox
      Left = 404
      Top = 80
      Width = 180
      Height = 25
      Style = csDropDownList
      TabOrder = 7
    end
    object edtParcela: TEdit
      Left = 596
      Top = 80
      Width = 50
      Height = 25
      TabOrder = 8
      Text = '1'
    end
    object edtTotalParcelas: TEdit
      Left = 676
      Top = 80
      Width = 50
      Height = 25
      TabOrder = 9
      Text = '1'
    end
    object edtNFNum: TEdit
      Left = 8
      Top = 134
      Width = 120
      Height = 25
      TabOrder = 10
    end
    object edtHistorico: TEdit
      Left = 140
      Top = 134
      Width = 400
      Height = 25
      TabOrder = 11
    end
    object edtStatusEd: TEdit
      Left = 552
      Top = 134
      Width = 110
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 12
    end
    object mmoObs: TMemo
      Left = 8
      Top = 188
      Width = 680
      Height = 60
      TabOrder = 13
    end
    object sgdRecebimentos: TStringGrid
      Left = 0
      Top = 276
      Width = 980
      Height = 100
      ColCount = 6
      DefaultRowHeight = 22
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      TabOrder = 14
    end
    object btnReceber: TButton
      Left = 8
      Top = 386
      Width = 130
      Height = 34
      Caption = 'Registrar Recebimento'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 15
      OnClick = btnReceberClick
    end
    object btnSalvar: TButton
      Left = 146
      Top = 386
      Width = 100
      Height = 34
      Caption = 'Salvar'
      TabOrder = 16
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 254
      Top = 386
      Width = 100
      Height = 34
      Caption = 'Excluir'
      Enabled = False
      TabOrder = 17
      OnClick = btnExcluirClick
    end
    object btnCancelarEd: TButton
      Left = 362
      Top = 386
      Width = 100
      Height = 34
      Caption = 'Cancelar'
      TabOrder = 18
      OnClick = btnCancelarEdClick
    end
  end
end
