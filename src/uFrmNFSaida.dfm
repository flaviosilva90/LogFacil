object FrmNFSaida: TFrmNFSaida
  Left = 0
  Top = 0
  Caption = 'Emiss'#227'o de Nota Fiscal de Sa'#237'da (NF-e)'
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
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 286
      Height = 19
      Caption = 'EMISS'#195'O DE NOTA FISCAL DE SA'#205'DA (NF-e)'
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
      Width = 200
      Height = 25
      TabOrder = 0
    end
    object cboStatusNF: TComboBox
      Left = 220
      Top = 10
      Width = 130
      Height = 25
      Style = csDropDownList
      TabOrder = 1
    end
    object btnBuscar: TButton
      Left = 362
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClick
    end
    object btnNova: TButton
      Left = 450
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Nova NF'
      TabOrder = 3
      OnClick = btnNovaClick
    end
    object btnDeVenda: TButton
      Left = 538
      Top = 9
      Width = 150
      Height = 27
      Caption = 'NF a partir de Venda'
      TabOrder = 4
      OnClick = btnDeVendaClick
    end
  end
  object sgdLista: TStringGrid
    Left = 0
    Top = 84
    Width = 1000
    Height = 160
    Align = alTop
    ColCount = 9
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pgcNF: TPageControl
    Left = 0
    Top = 244
    Width = 1000
    Height = 459
    ActivePage = tabCabecalho
    Align = alClient
    TabOrder = 3
    Visible = False
    object tabCabecalho: TTabSheet
      Caption = 'Cabe'#231'alho'
      object lblNumNF: TLabel
        Left = 8
        Top = 10
        Width = 37
        Height = 17
        Caption = 'N'#250' NF'
      end
      object lblSerie: TLabel
        Left = 110
        Top = 10
        Width = 29
        Height = 17
        Caption = 'S'#233'rie'
      end
      object lblDtEmissao: TLabel
        Left = 172
        Top = 10
        Width = 48
        Height = 17
        Caption = 'Emiss'#227'o'
      end
      object lblNatureza: TLabel
        Left = 304
        Top = 10
        Width = 134
        Height = 17
        Caption = 'Natureza da Opera'#231#227'o'
      end
      object lblFinalidade: TLabel
        Left = 616
        Top = 10
        Width = 59
        Height = 17
        Caption = 'Finalidade'
      end
      object lblAmbiente: TLabel
        Left = 800
        Top = 10
        Width = 55
        Height = 17
        Caption = 'Ambiente'
      end
      object lblStatusNFEd: TLabel
        Left = 8
        Top = 64
        Width = 58
        Height = 17
        Caption = 'Status NF:'
      end
      object lblVendaRef: TLabel
        Left = 140
        Top = 64
        Width = 65
        Height = 17
        Caption = 'Venda Ref.:'
      end
      object lblInfoCompl: TLabel
        Left = 8
        Top = 118
        Width = 175
        Height = 17
        Caption = 'Informa'#231#245'es Complementares'
      end
      object edtNumNF: TEdit
        Left = 8
        Top = 28
        Width = 90
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object edtSerie: TEdit
        Left = 110
        Top = 28
        Width = 50
        Height = 25
        TabOrder = 1
      end
      object edtDtEmissao: TDateTimePicker
        Left = 172
        Top = 28
        Width = 120
        Height = 25
        Date = 46094.000000000000000000
        Time = 0.925554675923194700
        TabOrder = 2
      end
      object edtNatureza: TEdit
        Left = 304
        Top = 28
        Width = 300
        Height = 25
        TabOrder = 3
      end
      object cboFinalidade: TComboBox
        Left = 616
        Top = 28
        Width = 170
        Height = 25
        Style = csDropDownList
        TabOrder = 4
      end
      object cboAmbiente: TComboBox
        Left = 800
        Top = 28
        Width = 170
        Height = 25
        Style = csDropDownList
        TabOrder = 5
      end
      object edtStatusNFEd: TEdit
        Left = 8
        Top = 82
        Width = 120
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 6
      end
      object edtVendaID: TEdit
        Left = 140
        Top = 82
        Width = 55
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 7
      end
      object edtVendaNum: TEdit
        Left = 200
        Top = 82
        Width = 80
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 8
      end
      object btnBuscarVenda: TButton
        Left = 286
        Top = 81
        Width = 110
        Height = 27
        Caption = 'Vincular Venda'
        TabOrder = 9
        OnClick = btnBuscarVendaClick
      end
      object mmoInfoCompl: TMemo
        Left = 8
        Top = 136
        Width = 950
        Height = 70
        TabOrder = 10
      end
    end
    object tabDestinatario: TTabSheet
      Caption = 'Destinat'#225'rio'
      object lblClienteRef: TLabel
        Left = 8
        Top = 8
        Width = 99
        Height = 17
        Caption = 'Cliente Sistema:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblDestNome: TLabel
        Left = 8
        Top = 40
        Width = 126
        Height = 17
        Caption = 'Raz'#227'o Social / Nome:'
      end
      object lblDestCNPJ: TLabel
        Left = 416
        Top = 40
        Width = 32
        Height = 17
        Caption = 'CNPJ:'
      end
      object lblDestCPF: TLabel
        Left = 578
        Top = 40
        Width = 24
        Height = 17
        Caption = 'CPF:'
      end
      object lblDestIE: TLabel
        Left = 8
        Top = 94
        Width = 107
        Height = 17
        Caption = 'Inscri'#231#227'o Estadual:'
      end
      object lblDestIndicIE: TLabel
        Left = 160
        Top = 94
        Width = 72
        Height = 17
        Caption = 'Indicador IE:'
      end
      object lblDestFone: TLabel
        Left = 352
        Top = 94
        Width = 52
        Height = 17
        Caption = 'Telefone:'
      end
      object lblDestEnd: TLabel
        Left = 8
        Top = 148
        Width = 73
        Height = 17
        Caption = 'Logradouro:'
      end
      object lblDestNum: TLabel
        Left = 340
        Top = 148
        Width = 51
        Height = 17
        Caption = 'N'#250'mero:'
      end
      object lblDestBairro: TLabel
        Left = 432
        Top = 148
        Width = 38
        Height = 17
        Caption = 'Bairro:'
      end
      object lblDestCidade: TLabel
        Left = 8
        Top = 202
        Width = 44
        Height = 17
        Caption = 'Cidade:'
      end
      object lblDestUF: TLabel
        Left = 260
        Top = 202
        Width = 18
        Height = 17
        Caption = 'UF:'
      end
      object lblDestCEP: TLabel
        Left = 312
        Top = 202
        Width = 25
        Height = 17
        Caption = 'CEP:'
      end
      object edtClienteID: TEdit
        Left = 108
        Top = 5
        Width = 55
        Height = 25
        TabOrder = 0
      end
      object edtClienteNome: TEdit
        Left = 168
        Top = 5
        Width = 280
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object btnBuscarCli: TButton
        Left = 454
        Top = 4
        Width = 100
        Height = 27
        Caption = 'Buscar Cliente'
        TabOrder = 2
        OnClick = btnBuscarCliClick
      end
      object edtDestNome: TEdit
        Left = 8
        Top = 58
        Width = 400
        Height = 25
        TabOrder = 3
      end
      object edtDestCNPJ: TEdit
        Left = 416
        Top = 58
        Width = 150
        Height = 25
        TabOrder = 4
      end
      object edtDestCPF: TEdit
        Left = 578
        Top = 58
        Width = 120
        Height = 25
        TabOrder = 5
      end
      object edtDestIE: TEdit
        Left = 8
        Top = 112
        Width = 140
        Height = 25
        TabOrder = 6
      end
      object cboDestIndicIE: TComboBox
        Left = 160
        Top = 112
        Width = 180
        Height = 25
        Style = csDropDownList
        TabOrder = 7
      end
      object edtDestFone: TEdit
        Left = 352
        Top = 112
        Width = 120
        Height = 25
        TabOrder = 8
      end
      object edtDestLogr: TEdit
        Left = 8
        Top = 166
        Width = 320
        Height = 25
        TabOrder = 9
      end
      object edtDestNum: TEdit
        Left = 340
        Top = 166
        Width = 80
        Height = 25
        TabOrder = 10
      end
      object edtDestBairro: TEdit
        Left = 432
        Top = 166
        Width = 200
        Height = 25
        TabOrder = 11
      end
      object edtDestCidade: TEdit
        Left = 8
        Top = 220
        Width = 240
        Height = 25
        TabOrder = 12
      end
      object edtDestUF: TEdit
        Left = 260
        Top = 220
        Width = 40
        Height = 25
        MaxLength = 2
        TabOrder = 13
      end
      object edtDestCEP: TEdit
        Left = 312
        Top = 220
        Width = 100
        Height = 25
        TabOrder = 14
      end
    end
    object tabItens: TTabSheet
      Caption = 'Itens'
      object sgdItens: TStringGrid
        Left = 0
        Top = 0
        Width = 970
        Height = 260
        ColCount = 9
        DefaultRowHeight = 22
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
      end
      object pnlAddItemNF: TPanel
        Left = 0
        Top = 262
        Width = 970
        Height = 36
        BevelOuter = bvNone
        Color = 15660287
        TabOrder = 1
        object lblAddProd: TLabel
          Left = 8
          Top = 10
          Width = 15
          Height = 17
          Caption = 'ID:'
        end
        object lblAddQtd: TLabel
          Left = 370
          Top = 10
          Width = 25
          Height = 17
          Caption = 'Qtd:'
        end
        object lblAddVlUnit: TLabel
          Left = 484
          Top = 10
          Width = 40
          Height = 17
          Caption = 'Vl.Unit:'
        end
        object lblAddCFOP: TLabel
          Left = 628
          Top = 10
          Width = 34
          Height = 17
          Caption = 'CFOP:'
        end
        object edtAddProdID: TEdit
          Left = 28
          Top = 6
          Width = 55
          Height = 25
          TabOrder = 0
        end
        object edtAddProdNome: TEdit
          Left = 88
          Top = 6
          Width = 240
          Height = 25
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object btnAddProd: TButton
          Left = 334
          Top = 5
          Width = 28
          Height = 27
          Caption = '...'
          TabOrder = 2
          OnClick = btnAddProdClick
        end
        object edtAddQtd: TEdit
          Left = 396
          Top = 6
          Width = 80
          Height = 25
          TabOrder = 3
          Text = '1,000'
        end
        object edtAddVlUnit: TEdit
          Left = 530
          Top = 6
          Width = 90
          Height = 25
          TabOrder = 4
          Text = '0,00'
        end
        object edtAddCFOP: TEdit
          Left = 660
          Top = 6
          Width = 70
          Height = 25
          TabOrder = 5
          Text = '5102'
        end
        object btnAddItemNF: TButton
          Left = 738
          Top = 5
          Width = 80
          Height = 27
          Caption = '+ Item'
          TabOrder = 6
          OnClick = btnAddItemNFClick
        end
        object btnRemItemNF: TButton
          Left = 824
          Top = 5
          Width = 80
          Height = 27
          Caption = '- Remover'
          TabOrder = 7
          OnClick = btnRemItemNFClick
        end
      end
    end
    object tabTotais: TTabSheet
      Caption = 'Totais Fiscais'
      object lblTotBCICMS: TLabel
        Left = 8
        Top = 10
        Width = 95
        Height = 17
        Caption = 'Base Calc. ICMS:'
      end
      object lblTotICMS: TLabel
        Left = 140
        Top = 10
        Width = 67
        Height = 17
        Caption = 'Valor ICMS:'
      end
      object lblTotIPI: TLabel
        Left = 272
        Top = 10
        Width = 16
        Height = 17
        Caption = 'IPI:'
      end
      object lblTotPIS: TLabel
        Left = 384
        Top = 10
        Width = 20
        Height = 17
        Caption = 'PIS:'
      end
      object lblTotCOFINS: TLabel
        Left = 496
        Top = 10
        Width = 47
        Height = 17
        Caption = 'COFINS:'
      end
      object lblTotFrete: TLabel
        Left = 8
        Top = 64
        Width = 32
        Height = 17
        Caption = 'Frete:'
      end
      object lblTotDesc: TLabel
        Left = 120
        Top = 64
        Width = 58
        Height = 17
        Caption = 'Desconto:'
      end
      object lblTotProd: TLabel
        Left = 8
        Top = 118
        Width = 88
        Height = 17
        Caption = 'Total Produtos:'
      end
      object lblTotNF: TLabel
        Left = 160
        Top = 118
        Width = 106
        Height = 17
        Caption = 'TOTAL DA NOTA:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtTotBCICMS: TEdit
        Left = 8
        Top = 28
        Width = 120
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object edtTotICMS: TEdit
        Left = 140
        Top = 28
        Width = 120
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object edtTotIPI: TEdit
        Left = 272
        Top = 28
        Width = 100
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 2
      end
      object edtTotPIS: TEdit
        Left = 384
        Top = 28
        Width = 100
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object edtTotCOFINS: TEdit
        Left = 496
        Top = 28
        Width = 100
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object edtTotFrete: TEdit
        Left = 8
        Top = 82
        Width = 100
        Height = 25
        TabOrder = 5
        Text = 'R$ 0,00'
      end
      object edtTotDesc: TEdit
        Left = 120
        Top = 82
        Width = 100
        Height = 25
        TabOrder = 6
        Text = 'R$ 0,00'
      end
      object edtTotProd: TEdit
        Left = 8
        Top = 136
        Width = 140
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 7
      end
      object edtTotNF: TEdit
        Left = 160
        Top = 136
        Width = 160
        Height = 25
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
      end
    end
    object tabTransporte: TTabSheet
      Caption = 'Transporte'
      object lblModalFrete: TLabel
        Left = 8
        Top = 10
        Width = 127
        Height = 17
        Caption = 'Modalidade do Frete:'
      end
      object lblTransNome: TLabel
        Left = 8
        Top = 64
        Width = 94
        Height = 17
        Caption = 'Transportadora:'
      end
      object lblTransCNPJ: TLabel
        Left = 320
        Top = 64
        Width = 32
        Height = 17
        Caption = 'CNPJ:'
      end
      object cboModalFrete: TComboBox
        Left = 8
        Top = 28
        Width = 240
        Height = 25
        Style = csDropDownList
        TabOrder = 0
      end
      object edtTransNome: TEdit
        Left = 8
        Top = 82
        Width = 300
        Height = 25
        TabOrder = 1
      end
      object edtTransCNPJ: TEdit
        Left = 320
        Top = 82
        Width = 160
        Height = 25
        TabOrder = 2
      end
    end
  end
  object pnlBotoesNF: TPanel
    Left = 0
    Top = 703
    Width = 1000
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    Color = 15263976
    TabOrder = 4
    Visible = False
    object btnSalvarNF: TButton
      Left = 8
      Top = 8
      Width = 110
      Height = 30
      Caption = 'Salvar NF'
      TabOrder = 0
      OnClick = btnSalvarNFClick
    end
    object btnGerarXML: TButton
      Left = 126
      Top = 8
      Width = 140
      Height = 30
      Caption = 'Gerar XML NF-e'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnGerarXMLClick
    end
    object btnCancelarNF: TButton
      Left = 274
      Top = 8
      Width = 110
      Height = 30
      Caption = 'Cancelar NF'
      Enabled = False
      TabOrder = 2
      OnClick = btnCancelarNFClick
    end
    object btnFecharNF: TButton
      Left = 392
      Top = 8
      Width = 100
      Height = 30
      Caption = 'Fechar'
      TabOrder = 3
      OnClick = btnFecharNFClick
    end
  end
end
