object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 259
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrinter: TLabel
    Left = 32
    Top = 52
    Width = 42
    Height = 13
    Caption = 'Printer : '
  end
  object btnShowPrintJobsCount: TButton
    Left = 32
    Top = 8
    Width = 145
    Height = 25
    Caption = 'Show jobs count'
    TabOrder = 0
    OnClick = btnShowPrintJobsCountClick
  end
  object medPrintJobsCount: TMaskEdit
    Left = 200
    Top = 49
    Width = 145
    Height = 21
    TabOrder = 1
    Text = ''
  end
  object Memo1: TMemo
    Left = 32
    Top = 88
    Width = 313
    Height = 138
    TabOrder = 2
  end
  object btnClearPrinterAllJobs: TButton
    Left = 200
    Top = 8
    Width = 145
    Height = 25
    Caption = 'Clear Printer All Jobs'
    TabOrder = 3
    OnClick = btnClearPrinterAllJobsClick
  end
end
