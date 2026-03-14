object FrmFluxoCaixa: TFrmFluxoCaixa
  Left = 0
  Top = 0
  Caption = 'Fluxo de Caixa'
  ClientHeight = 720
  ClientWidth = 980
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    980
    720)
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 3368601
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 111
      Height = 19
      Caption = 'FLUXO DE CAIXA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlSaldo: TPanel
    Left = 0
    Top = 40
    Width = 980
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = 15792383
    TabOrder = 1
    object lblSaldoAtual: TLabel
      Left = 12
      Top = 8
      Width = 110
      Height = 21
      Caption = 'SALDO ATUAL:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSaldoValor: TLabel
      Left = 130
      Top = 6
      Width = 78
      Height = 30
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -22
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEntradas: TLabel
      Left = 380
      Top = 10
      Width = 105
      Height = 17
      Caption = 'Entradas: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSaidas: TLabel
      Left = 580
      Top = 10
      Width = 91
      Height = 17
      Caption = 'Sa'#237'das: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSaldoPeriodo: TLabel
      Left = 760
      Top = 10
      Width = 138
      Height = 17
      Caption = 'Saldo Per'#237'odo: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlFiltro: TPanel
    Left = 0
    Top = 100
    Width = 980
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblDe: TLabel
      Left = 8
      Top = 14
      Width = 49
      Height = 17
      Caption = 'Per'#237'odo:'
    end
    object lblAte: TLabel
      Left = 176
      Top = 14
      Width = 18
      Height = 17
      Caption = 'at'#233
    end
    object edtDe: TDateTimePicker
      Left = 56
      Top = 10
      Width = 110
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.930497928238764900
      TabOrder = 0
    end
    object edtAte: TDateTimePicker
      Left = 194
      Top = 10
      Width = 110
      Height = 25
      Date = 46094.000000000000000000
      Time = 0.930497974535683200
      TabOrder = 1
    end
    object cboTipoMov: TComboBox
      Left = 314
      Top = 10
      Width = 120
      Height = 25
      Style = csDropDownList
      TabOrder = 2
    end
    object btnBuscar: TButton
      Left = 444
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 3
      OnClick = btnBuscarClick
    end
    object btnLancamento: TButton
      Left = 534
      Top = 9
      Width = 140
      Height = 27
      Caption = 'Lan'#231'amento Manual'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btnLancamentoClick
    end
  end
  object pgcFluxo: TPageControl
    Left = 0
    Top = 144
    Width = 980
    Height = 576
    ActivePage = tabMovimentos
    Align = alClient
    TabOrder = 3
    OnChange = pgcFluxoChange
    object tabMovimentos: TTabSheet
      Caption = 'Movimenta'#231#245'es'
      object sgdMovimentos: TStringGrid
        Left = 0
        Top = 0
        Width = 972
        Height = 544
        Align = alClient
        ColCount = 7
        DefaultRowHeight = 22
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
      end
    end
    object tabProjecao: TTabSheet
      Caption = 'Proje'#231#227'o (60 dias)'
      object pnlProjHeader: TPanel
        Left = 0
        Top = 0
        Width = 960
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        Color = clAzure
        TabOrder = 0
        object lblProjPagar: TLabel
          Left = 8
          Top = 8
          Width = 136
          Height = 17
          Caption = 'A Pagar (60d): R$ 0,00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProjReceber: TLabel
          Left = 230
          Top = 8
          Width = 149
          Height = 17
          Caption = 'A Receber (60d): R$ 0,00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProjSaldo: TLabel
          Left = 480
          Top = 8
          Width = 150
          Height = 17
          Caption = 'Saldo Projetado: R$ 0,00'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object sgdProjecao: TStringGrid
        Left = 0
        Top = 36
        Width = 960
        Height = 454
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 22
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 1
      end
    end
    object tabResumo: TTabSheet
      Caption = 'Resumo por Categoria'
      object sgdResumo: TStringGrid
        Left = 0
        Top = 0
        Width = 960
        Height = 490
        Align = alClient
        ColCount = 3
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
        TabOrder = 0
      end
    end
  end
  object btnFechar: TButton
    Left = 880
    Top = 682
    Width = 90
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Fechar'
    TabOrder = 4
    OnClick = btnFecharClick
  end
end
