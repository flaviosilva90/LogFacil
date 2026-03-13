object FrmEstoque: TFrmEstoque
  Caption = 'Posi'#231#227'o de Estoque'
  ClientHeight = 680  ClientWidth = 960
  Font.Name = 'Segoe UI'  Font.Height = -13
  Position = poOwnerFormCenter  OnCreate = FormCreate
  object pnlTopo: TPanel
    Left=0 Top=0 Width=960 Height=40 Align=alTop BevelOuter=bvNone Color=$00993300
    object lblTitulo: TLabel
      Left=12 Top=10 Caption='POSI'#199#195'O DE ESTOQUE'
      Font.Color=clWhite Font.Style=[fsBold] Font.Height=-14 ParentFont=False
    end
  end
  object pgcEstoque: TPageControl
    Left=0 Top=40 Width=960 Height=600 Align=alClient TabOrder=0
    OnChange=pgcEstoqueChange
    object tabPosicao: TTabSheet
      Caption='Posi'#231#227'o Atual'
      object pnlFiltroPos: TPanel
        Left=0 Top=0 Width=940 Height=44 Align=alTop BevelOuter=bvNone TabOrder=0
        object edtFiltroProd: TEdit
          Left=8 Top=10 Width=240 Height=25 Hint='Filtrar por código ou descrição' TabOrder=0
        end
        object cboSituacao: TComboBox
          Left=260 Top=10 Width=160 Height=25 Style=csDropDownList TabOrder=1
        end
        object btnBuscarPos: TButton
          Left=432 Top=9 Width=90 Height=27 Caption='Buscar' TabOrder=2 OnClick=btnBuscarPosClick
        end
      end
      object sgdPosicao: TStringGrid
        Left=0 Top=44 Width=940 Height=480 Align=alClient
        ColCount=9 DefaultRowHeight=22 RowCount=2 FixedRows=1
        Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
        TabOrder=1
      end
      object pnlResumo: TPanel
        Left=0 Top=524 Width=940 Height=32 Align=alBottom BevelOuter=bvNone Color=$00E8F4E8
        object lblTotalItens: TLabel
          Left=12 Top=8 Caption='Total: 0 itens' Font.Style=[fsBold] ParentFont=False
        end
        object lblSemEstoque: TLabel
          Left=180 Top=8 Caption='Sem estoque: 0' Font.Color=clRed Font.Style=[fsBold] ParentFont=False
        end
        object lblBaixo: TLabel
          Left=360 Top=8 Caption='Estoque baixo: 0' Font.Color=$000099FF Font.Style=[fsBold] ParentFont=False
        end
      end
    end
    object tabHistorico: TTabSheet
      Caption='Hist'#243'rico de Movimenta'#231#245'es'
      object pnlFiltroHist: TPanel
        Left=0 Top=0 Width=940 Height=44 Align=alTop BevelOuter=bvNone TabOrder=0
        object lblDe: TLabel Left=8 Top=13 Caption='De:' end
        object edtDe: TDateTimePicker Left=30 Top=9 Width=110 Height=25 TabOrder=0 end
        object lblAte: TLabel Left=150 Top=13 Caption='At'#233':' end
        object edtAte: TDateTimePicker Left=172 Top=9 Width=110 Height=25 TabOrder=1 end
        object edtFiltroItem: TEdit Left=294 Top=9 Width=180 Height=25 Hint='Filtrar por item' TabOrder=2 end
        object cboTipoMov: TComboBox
          Left=484 Top=9 Width=130 Height=25 Style=csDropDownList TabOrder=3
        end
        object btnBuscarHist: TButton
          Left=626 Top=8 Width=90 Height=27 Caption='Buscar' TabOrder=4 OnClick=btnBuscarHistClick
        end
      end
      object sgdHistorico: TStringGrid
        Left=0 Top=44 Width=940 Height=510 Align=alClient
        ColCount=8 DefaultRowHeight=22 RowCount=2 FixedRows=1
        Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
        TabOrder=1
      end
    end
  end
  object btnFechar: TButton
    Left=848 Top=648 Width=100 Height=30 Caption='Fechar' TabOrder=1 OnClick=btnFecharClick
    Anchors=[akRight,akBottom]
  end
end
