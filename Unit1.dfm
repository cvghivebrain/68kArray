object Form1: TForm1
  Left = 0
  Top = 0
  Caption = '68kArray'
  ClientHeight = 661
  ClientWidth = 1076
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object memInput: TMemo
    Left = 8
    Top = 8
    Width = 425
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnChange = memInputChange
  end
  object memOutput: TMemo
    Left = 439
    Top = 8
    Width = 425
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Fixedsys'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object grpMenu2: TGroupBox
    Left = 439
    Top = 351
    Width = 425
    Height = 149
    TabOrder = 2
    object editRow: TLabeledEdit
      Left = 11
      Top = 16
      Width = 87
      Height = 23
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = 'Items per row'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '16'
      OnChange = editRowChange
    end
    object udRow: TUpDown
      Left = 98
      Top = 16
      Width = 17
      Height = 23
      Associate = editRow
      Min = 1
      Max = 1000
      Position = 16
      TabOrder = 1
      Thousands = False
    end
    object boxType: TComboBox
      Left = 264
      Top = 17
      Width = 110
      Height = 22
      Style = csOwnerDrawFixed
      ItemIndex = 0
      TabOrder = 2
      Text = 'dc.b'
      OnChange = boxTypeChange
      Items.Strings = (
        'dc.b'
        'dc.w'
        'dc.l')
    end
    object chkSigned: TCheckBox
      Left = 264
      Top = 45
      Width = 97
      Height = 17
      Caption = 'Signed'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = chkSignedClick
    end
    object editIndent: TLabeledEdit
      Left = 139
      Top = 16
      Width = 87
      Height = 23
      EditLabel.Width = 32
      EditLabel.Height = 13
      EditLabel.Caption = 'Indent'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Fixedsys'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '2'
      OnChange = editIndentChange
    end
    object udIndent: TUpDown
      Left = 226
      Top = 16
      Width = 17
      Height = 23
      Associate = editIndent
      Position = 2
      TabOrder = 5
      Thousands = False
    end
    object chkDollar: TCheckBox
      Left = 264
      Top = 60
      Width = 97
      Height = 17
      Caption = 'Omit $ for 0-9'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = chkDollarClick
    end
    object chk0s: TCheckBox
      Left = 264
      Top = 75
      Width = 97
      Height = 17
      Caption = 'Leading 0s'
      TabOrder = 7
      OnClick = chk0sClick
    end
    object chkSpace: TCheckBox
      Left = 264
      Top = 90
      Width = 97
      Height = 17
      Caption = 'Even spacing'
      TabOrder = 8
      OnClick = chkSpaceClick
    end
    object btnSaveTxt: TButton
      Left = 11
      Top = 60
      Width = 121
      Height = 35
      Caption = 'Save to text file...'
      TabOrder = 9
      OnClick = btnSaveTxtClick
    end
    object btnCopy: TButton
      Left = 11
      Top = 101
      Width = 121
      Height = 35
      Caption = 'Copy to clipboard'
      TabOrder = 10
      OnClick = btnCopyClick
    end
  end
  object grpMenu: TGroupBox
    Left = 8
    Top = 351
    Width = 425
    Height = 149
    TabOrder = 3
    object lblCount: TLabel
      Left = 11
      Top = 3
      Width = 67
      Height = 13
      Caption = '0 bytes found'
    end
    object btnSave: TButton
      Left = 11
      Top = 73
      Width = 121
      Height = 35
      Caption = 'Save to binary file...'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnOpen: TButton
      Left = 11
      Top = 32
      Width = 121
      Height = 35
      Caption = 'Open from binary file...'
      TabOrder = 1
      OnClick = btnOpenClick
    end
  end
  object dlgOpen: TOpenDialog
    Left = 8
    Top = 544
  end
  object dlgSave: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 56
    Top = 544
  end
end
