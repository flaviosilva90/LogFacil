object FrmCompras: TFrmCompras
  Left = 0
  Top = 0
  Caption = 'Compras de Mat'#233'ria-Prima'
  ClientHeight = 740
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
      Width = 205
      Height = 19
      Caption = 'COMPRAS DE MAT'#201'RIA-PRIMA'
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
    Width = 960
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtFiltro: TEdit
      Left = 8
      Top = 10
      Width = 220
      Height = 25
      TabOrder = 0
    end
    object cboStatus: TComboBox
      Left = 240
      Top = 10
      Width = 130
      Height = 25
      Style = csDropDownList
      TabOrder = 1
    end
    object btnBuscar: TButton
      Left = 382
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClick
    end
    object btnNova: TButton
      Left = 470
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Nova'
      TabOrder = 3
      OnClick = btnNovaClick
    end
  end
  object sgdLista: TStringGrid
    Left = 0
    Top = 84
    Width = 960
    Height = 180
    Align = alTop
    ColCount = 8
    DefaultRowHeight = 22
    DrawingStyle = gdsGradient
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 264
    Width = 960
    Height = 476
    Align = alTop
    BevelOuter = bvNone
    Color = 16448250
    TabOrder = 3
    Visible = False
    object lblNumero: TLabel
      Left = 8
      Top = 8
      Width = 48
      Height = 17
      Caption = 'N'#250'mero'
    end
    object lblFornec: TLabel
      Left = 110
      Top = 8
      Width = 79
      Height = 17
      Caption = 'Fornecedor: *'
    end
    object lblEmissao: TLabel
      Left = 496
      Top = 8
      Width = 48
      Height = 17
      Caption = 'Emiss'#227'o'
    end
    object lblPrevisao: TLabel
      Left = 618
      Top = 8
      Width = 49
      Height = 17
      Caption = 'Previs'#227'o'
    end
    object lblStatus: TLabel
      Left = 740
      Top = 8
      Width = 35
      Height = 17
      Caption = 'Status'
    end
    object lblNF: TLabel
      Left = 8
      Top = 62
      Width = 68
      Height = 17
      Caption = 'NF N'#250'mero'
    end
    object lblSerie: TLabel
      Left = 140
      Top = 62
      Width = 29
      Height = 17
      Caption = 'S'#233'rie'
    end
    object lblCondPagto: TLabel
      Left = 212
      Top = 62
      Width = 104
      Height = 17
      Caption = 'Cond. Pagamento'
    end
    object lblObs: TLabel
      Left = 424
      Top = 62
      Width = 24
      Height = 17
      Caption = 'Obs'
    end
    object lblItens: TLabel
      Left = 8
      Top = 140
      Width = 105
      Height = 17
      Caption = 'Itens da Compra:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtNumero: TEdit
      Left = 8
      Top = 26
      Width = 90
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtFornecID: TEdit
      Left = 110
      Top = 26
      Width = 55
      Height = 25
      TabOrder = 1
    end
    object edtFornecNome: TEdit
      Left = 170
      Top = 26
      Width = 280
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object btnBuscarFornec: TButton
      Left = 456
      Top = 25
      Width = 28
      Height = 27
      Caption = '...'
      TabOrder = 3
      OnClick = btnBuscarFornecClick
    end
    object edtEmissao: TDateTimePicker
      Left = 496
      Top = 26
      Width = 110
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.813471516201389000
      TabOrder = 4
    end
    object edtPrevisao: TDateTimePicker
      Left = 618
      Top = 26
      Width = 110
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.813471516201389000
      TabOrder = 5
    end
    object edtStatusLabel: TEdit
      Left = 740
      Top = 26
      Width = 120
      Height = 25
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object edtNF: TEdit
      Left = 8
      Top = 80
      Width = 120
      Height = 25
      TabOrder = 7
    end
    object edtSerie: TEdit
      Left = 140
      Top = 80
      Width = 60
      Height = 25
      TabOrder = 8
    end
    object edtCondPagto: TEdit
      Left = 212
      Top = 80
      Width = 200
      Height = 25
      TabOrder = 9
    end
    object mmoObs: TMemo
      Left = 424
      Top = 80
      Width = 420
      Height = 48
      TabOrder = 10
    end
    object sgdItens: TStringGrid
      Left = 0
      Top = 158
      Width = 960
      Height = 130
      ColCount = 7
      DefaultRowHeight = 22
      DrawingStyle = gdsGradient
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      TabOrder = 11
    end
    object pnlAddItem: TPanel
      Left = 0
      Top = 288
      Width = 960
      Height = 36
      BevelOuter = bvNone
      Color = 15660287
      TabOrder = 12
      object lblAddMP: TLabel
        Left = 8
        Top = 10
        Width = 38
        Height = 17
        Caption = 'ID MP:'
      end
      object lblAddQtd: TLabel
        Left = 390
        Top = 10
        Width = 25
        Height = 17
        Caption = 'Qtd:'
      end
      object lblAddVlUnit: TLabel
        Left = 502
        Top = 10
        Width = 40
        Height = 17
        Caption = 'Vl.Unit:'
      end
      object lblAddDesc: TLabel
        Left = 646
        Top = 10
        Width = 31
        Height = 17
        Caption = 'Desc:'
      end
      object edtAddMPID: TEdit
        Left = 48
        Top = 6
        Width = 55
        Height = 25
        TabOrder = 0
      end
      object edtAddMPNome: TEdit
        Left = 108
        Top = 6
        Width = 240
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object btnBuscarMP: TButton
        Left = 354
        Top = 5
        Width = 28
        Height = 27
        Caption = '...'
        TabOrder = 2
        OnClick = btnBuscarMPClick
      end
      object edtAddQtd: TEdit
        Left = 414
        Top = 6
        Width = 80
        Height = 25
        TabOrder = 3
        Text = '1,000'
      end
      object edtAddVlUnit: TEdit
        Left = 548
        Top = 6
        Width = 90
        Height = 25
        TabOrder = 4
        Text = '0,00'
      end
      object edtAddDesc: TEdit
        Left = 678
        Top = 6
        Width = 80
        Height = 25
        TabOrder = 5
        Text = '0,00'
      end
      object btnAddItem: TButton
        Left = 766
        Top = 5
        Width = 80
        Height = 27
        Caption = '+ Item'
        TabOrder = 6
        OnClick = btnAddItemClick
      end
      object btnRemItem: TButton
        Left = 852
        Top = 5
        Width = 80
        Height = 27
        Caption = '- Remover'
        TabOrder = 7
        OnClick = btnRemItemClick
      end
    end
    object pnlTotais: TPanel
      Left = 640
      Top = 330
      Width = 316
      Height = 70
      BevelOuter = bvNone
      Color = 16448250
      TabOrder = 13
      object lblFrete: TLabel
        Left = 8
        Top = 6
        Width = 32
        Height = 17
        Caption = 'Frete:'
      end
      object lblDescGlobal: TLabel
        Left = 168
        Top = 6
        Width = 58
        Height = 17
        Caption = 'Desconto:'
      end
      object lblTotalLabel: TLabel
        Left = 8
        Top = 38
        Width = 44
        Height = 17
        Caption = 'TOTAL:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtFrete: TEdit
        Left = 60
        Top = 2
        Width = 100
        Height = 25
        TabOrder = 0
        Text = '0,00'
        OnChange = edtFreteChange
      end
      object edtDescGlobal: TEdit
        Left = 228
        Top = 2
        Width = 80
        Height = 25
        TabOrder = 1
        Text = '0,00'
        OnChange = edtDescGlobalChange
      end
      object edtTotal: TEdit
        Left = 60
        Top = 34
        Width = 120
        Height = 25
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
    object pnlBotoes: TPanel
      Left = 0
      Top = 406
      Width = 960
      Height = 44
      BevelOuter = bvNone
      Color = 15263976
      TabOrder = 14
      object btnSalvar: TButton
        Left = 8
        Top = 8
        Width = 100
        Height = 30
        Caption = 'Salvar'
        TabOrder = 0
        OnClick = btnSalvarClick
      end
      object btnConfirmar: TButton
        Left = 116
        Top = 8
        Width = 110
        Height = 30
        Caption = 'Confirmar'
        Enabled = False
        TabOrder = 1
        OnClick = btnConfirmarClick
      end
      object btnReceber: TButton
        Left = 234
        Top = 8
        Width = 110
        Height = 30
        Caption = 'Receber'
        Enabled = False
        TabOrder = 2
        OnClick = btnReceberClick
      end
      object btnCancelarDoc: TButton
        Left = 352
        Top = 8
        Width = 110
        Height = 30
        Caption = 'Cancelar'
        Enabled = False
        TabOrder = 3
        OnClick = btnCancelarDocClick
      end
      object btnFechar: TButton
        Left = 470
        Top = 8
        Width = 100
        Height = 30
        Caption = 'Fechar'
        TabOrder = 4
        OnClick = btnFecharClick
      end
    end
  end
end
