object Frm: TFrm
  Left = 0
  Top = 0
  Caption = 'Napi rutinok'
  ClientHeight = 625
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object TabbedNotebook1: TTabbedNotebook
    Left = 0
    Top = 0
    Width = 716
    Height = 625
    Align = alClient
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'Tahoma'
    TabFont.Style = []
    TabOrder = 0
    OnClick = TabbedNotebook1Click
    object TTabPage
      Left = 4
      Top = 30
      Caption = 'Adatbevitel'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 708
        Height = 591
        Align = alClient
        Caption = 'Panel2'
        TabOrder = 0
        object Button1: TButton
          Left = 1
          Top = 96
          Width = 706
          Height = 34
          Align = alTop
          Caption = 'Ment'#233's'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Arial Black'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = Button1Click
        end
        object E_Megn: TEdit
          Left = 1
          Top = 42
          Width = 706
          Height = 27
          Hint = 'Megnevez'#233's'
          Align = alTop
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = E_MegnChange
          OnEnter = E_MegnEnter
          OnExit = E_MegnExit
        end
        object E_Mertek: TEdit
          Left = 1
          Top = 69
          Width = 706
          Height = 27
          Hint = 'Mennyis'#233'g/M'#233'rt'#233'k'
          Align = alTop
          TabOrder = 2
          OnChange = E_MertekChange
          OnEnter = E_MertekEnter
          OnExit = E_MertekExit
        end
        object Lista: TListBox
          Left = 1
          Top = 130
          Width = 706
          Height = 460
          Align = alClient
          ItemHeight = 19
          Sorted = True
          TabOrder = 3
          OnClick = ListaClick
        end
        object RadioGroup1: TRadioGroup
          Left = 1
          Top = 1
          Width = 706
          Height = 41
          Align = alTop
          Columns = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            'Bevitel'
            'Kiad'#225's'
            #193'llapot')
          ParentFont = False
          TabOrder = 4
          OnClick = RadioGroup1Click
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 30
      Caption = 'Adatok'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 708
        Height = 591
        Align = alClient
        TabOrder = 0
        object DataList: TStringGrid
          Left = 1
          Top = 1
          Width = 706
          Height = 589
          Align = alClient
          ColCount = 4
          DefaultColWidth = 50
          FixedCols = 0
          RowCount = 1
          FixedRows = 0
          TabOrder = 0
        end
      end
    end
  end
end
