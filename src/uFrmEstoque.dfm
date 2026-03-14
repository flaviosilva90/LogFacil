object FrmEstoque: TFrmEstoque
  Left = 0
  Top = 0
  Caption = 'Posi'#231#227'o de Estoque'
  ClientHeight = 680
  ClientWidth = 960
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    960
    680)
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 960
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 2
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 148
      Height = 19
      Caption = 'POSI'#199#195'O DE ESTOQUE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pgcEstoque: TPageControl
    Left = 0
    Top = 40
    Width = 960
    Height = 640
    ActivePage = tabPosicao
    Align = alClient
    TabOrder = 0
    OnChange = pgcEstoqueChange
    object tabPosicao: TTabSheet
      Caption = 'Posi'#231#227'o Atual'
      object pnlFiltroPos: TPanel
        Left = 0
        Top = 0
        Width = 952
        Height = 44
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object edtFiltroProd: TEdit
          Left = 8
          Top = 10
          Width = 240
          Height = 25
          Hint = 'Filtrar por c'#195#179'digo ou descri'#195#167#195#163'o'
          TabOrder = 0
        end
        object cboSituacao: TComboBox
          Left = 260
          Top = 10
          Width = 160
          Height = 25
          Style = csDropDownList
          TabOrder = 1
        end
        object btnBuscarPos: TButton
          Left = 432
          Top = 9
          Width = 90
          Height = 27
          Caption = 'Buscar'
          TabOrder = 2
          OnClick = btnBuscarPosClick
        end
      end
      object sgdPosicao: TStringGrid
        Left = 0
        Top = 44
        Width = 952
        Height = 532
        Align = alClient
        ColCount = 9
        DefaultRowHeight = 22
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 1
      end
      object pnlResumo: TPanel
        Left = 0
        Top = 576
        Width = 952
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        Color = 15267048
        TabOrder = 2
        object lblTotalItens: TLabel
          Left = 12
          Top = 8
          Width = 80
          Height = 17
          Caption = 'Total: 0 itens'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSemEstoque: TLabel
          Left = 180
          Top = 8
          Width = 94
          Height = 17
          Caption = 'Sem estoque: 0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblBaixo: TLabel
          Left = 360
          Top = 8
          Width = 102
          Height = 17
          Caption = 'Estoque baixo: 0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 39423
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
    object tabHistorico: TTabSheet
      Caption = 'Hist'#243'rico de Movimenta'#231#245'es'
      object pnlFiltroHist: TPanel
        Left = 0
        Top = 0
        Width = 940
        Height = 44
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblDe: TLabel
          Left = 8
          Top = 13
          Width = 19
          Height = 17
          Caption = 'De:'
        end
        object lblAte: TLabel
          Left = 150
          Top = 13
          Width = 22
          Height = 17
          Caption = 'At'#233':'
        end
        object edtDe: TDateTimePicker
          Left = 30
          Top = 9
          Width = 110
          Height = 25
          Date = 46094.000000000000000000
          Time = 0.926484837960742900
          TabOrder = 0
        end
        object edtAte: TDateTimePicker
          Left = 172
          Top = 9
          Width = 110
          Height = 25
          Date = 46094.000000000000000000
          Time = 0.926484837960742900
          TabOrder = 1
        end
        object edtFiltroItem: TEdit
          Left = 294
          Top = 9
          Width = 180
          Height = 25
          Hint = 'Filtrar por item'
          TabOrder = 2
        end
        object cboTipoMov: TComboBox
          Left = 484
          Top = 9
          Width = 130
          Height = 25
          Style = csDropDownList
          TabOrder = 3
        end
        object btnBuscarHist: TButton
          Left = 626
          Top = 8
          Width = 90
          Height = 27
          Caption = 'Buscar'
          TabOrder = 4
          OnClick = btnBuscarHistClick
        end
      end
      object sgdHistorico: TStringGrid
        Left = 0
        Top = 44
        Width = 952
        Height = 564
        Align = alClient
        ColCount = 8
        DefaultRowHeight = 22
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 1
        ExplicitWidth = 940
        ExplicitHeight = 510
      end
    end
  end
  object btnFechar: TButton
    Left = 848
    Top = 648
    Width = 100
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Fechar'
    TabOrder = 1
    OnClick = btnFecharClick
  end
end
