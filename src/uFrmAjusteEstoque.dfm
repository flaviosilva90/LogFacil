object FrmAjusteEstoque: TFrmAjusteEstoque
  Left = 0
  Top = 0
  Caption = 'Ajuste de Estoque'
  ClientHeight = 700
  ClientWidth = 900
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
    Width = 900
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 136
      Height = 19
      Caption = 'AJUSTE DE ESTOQUE'
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
    Width = 900
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtFiltro: TEdit
      Left = 8
      Top = 10
      Width = 220
      Height = 25
      Hint = 'Filtrar por motivo'
      TabOrder = 0
    end
    object cboTipoEst: TComboBox
      Left = 240
      Top = 10
      Width = 140
      Height = 25
      Style = csDropDownList
      TabOrder = 1
    end
    object btnBuscar: TButton
      Left = 392
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClick
    end
    object btnNovo: TButton
      Left = 480
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
    Width = 900
    Height = 160
    Align = alTop
    ColCount = 6
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 244
    Width = 900
    Height = 456
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
    object lblData: TLabel
      Left = 110
      Top = 8
      Width = 27
      Height = 17
      Caption = 'Data'
    end
    object lblTipoEstLbl: TLabel
      Left = 244
      Top = 8
      Width = 77
      Height = 17
      Caption = 'Tipo Estoque'
    end
    object lblMotivo: TLabel
      Left = 406
      Top = 8
      Width = 53
      Height = 17
      Caption = 'Motivo: *'
    end
    object lblObs: TLabel
      Left = 8
      Top = 62
      Width = 76
      Height = 17
      Caption = 'Observa'#231#245'es'
    end
    object lblItens: TLabel
      Left = 8
      Top = 140
      Width = 97
      Height = 17
      Caption = 'Itens do Ajuste:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAddObs: TLabel
      Left = 8
      Top = 334
      Width = 76
      Height = 17
      Caption = 'Obs do item:'
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
    object edtData: TDateTimePicker
      Left = 110
      Top = 26
      Width = 120
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.793620601849397600
      TabOrder = 1
    end
    object cboTipoEstEd: TComboBox
      Left = 244
      Top = 26
      Width = 150
      Height = 25
      Style = csDropDownList
      TabOrder = 2
      OnChange = cboTipoEstEdChange
    end
    object edtMotivo: TEdit
      Left = 406
      Top = 26
      Width = 380
      Height = 25
      MaxLength = 100
      TabOrder = 3
    end
    object mmoObs: TMemo
      Left = 8
      Top = 80
      Width = 780
      Height = 50
      TabOrder = 4
    end
    object sgdItens: TStringGrid
      Left = 0
      Top = 158
      Width = 900
      Height = 130
      ColCount = 7
      DefaultRowHeight = 22
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
      TabOrder = 5
    end
    object pnlAddItem: TPanel
      Left = 0
      Top = 288
      Width = 900
      Height = 36
      BevelOuter = bvNone
      Color = 15660287
      TabOrder = 6
      object lblAddID: TLabel
        Left = 8
        Top = 10
        Width = 15
        Height = 17
        Caption = 'ID:'
      end
      object lblAddTipoMov: TLabel
        Left = 334
        Top = 10
        Width = 29
        Height = 17
        Caption = 'Mov:'
      end
      object lblAddQtdNova: TLabel
        Left = 490
        Top = 10
        Width = 25
        Height = 17
        Caption = 'Qtd:'
      end
      object lblAddVlUnit: TLabel
        Left = 606
        Top = 10
        Width = 40
        Height = 17
        Caption = 'Vl.Unit:'
      end
      object edtAddID: TEdit
        Left = 28
        Top = 6
        Width = 60
        Height = 25
        TabOrder = 0
      end
      object edtAddNome: TEdit
        Left = 92
        Top = 6
        Width = 200
        Height = 25
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object btnBuscarItem: TButton
        Left = 298
        Top = 5
        Width = 28
        Height = 27
        Caption = '...'
        TabOrder = 2
        OnClick = btnBuscarItemClick
      end
      object cboAddTipoMov: TComboBox
        Left = 362
        Top = 6
        Width = 120
        Height = 25
        Style = csDropDownList
        TabOrder = 3
      end
      object edtAddQtdNova: TEdit
        Left = 518
        Top = 6
        Width = 80
        Height = 25
        TabOrder = 4
        Text = '0,000'
      end
      object edtAddVlUnit: TEdit
        Left = 648
        Top = 6
        Width = 80
        Height = 25
        TabOrder = 5
        Text = '0,00'
      end
      object btnAddItem: TButton
        Left = 736
        Top = 5
        Width = 70
        Height = 27
        Caption = '+ Add'
        TabOrder = 6
        OnClick = btnAddItemClick
      end
      object btnRemItem: TButton
        Left = 812
        Top = 5
        Width = 70
        Height = 27
        Caption = '- Rem'
        TabOrder = 7
        OnClick = btnRemItemClick
      end
    end
    object edtAddObs: TEdit
      Left = 8
      Top = 352
      Width = 500
      Height = 25
      TabOrder = 8
    end
    object pnlBotoes: TPanel
      Left = 0
      Top = 388
      Width = 900
      Height = 44
      BevelOuter = bvNone
      Color = 15263976
      TabOrder = 7
      object btnSalvar: TButton
        Left = 8
        Top = 8
        Width = 120
        Height = 30
        Caption = 'Salvar Ajuste'
        TabOrder = 0
        OnClick = btnSalvarClick
      end
      object btnFechar: TButton
        Left = 136
        Top = 8
        Width = 100
        Height = 30
        Caption = 'Fechar'
        TabOrder = 1
        OnClick = btnFecharClick
      end
    end
  end
end
