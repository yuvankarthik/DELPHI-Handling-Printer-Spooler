unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winspool, printers, Vcl.StdCtrls,
  Vcl.Mask;

type
  TForm1 = class(TForm)
    btnShowPrintJobsCount: TButton;
    medPrintJobsCount: TMaskEdit;
    Memo1: TMemo;
    lblPrinter: TLabel;
    btnClearPrinterAllJobs: TButton;
    procedure btnShowPrintJobsCountClick(Sender: TObject);
    procedure btnClearPrinterAllJobsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


Function GetCurrentPrinterHandle: THandle;
  Const
    Defaults: TPrinterDefaults = (
      pDatatype : nil;
      pDevMode  : nil;
      DesiredAccess : PRINTER_ACCESS_USE or PRINTER_ACCESS_ADMINISTER
);
  Var
    Device, Driver, Port : array[0..255] of char;
    hDeviceMode: THandle;
  Begin { GetCurrentPrinterHandle }
    Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
    //FMX.Printer.Win.TPrinterWin.GetPrinter
    If not OpenPrinter(@Device, Result, @Defaults) Then
      RaiseLastWin32Error;
  End; { GetCurrentPrinterHandle }


{: Kill all pending jobs on the current printer }
Procedure PurgeJobsOnCurrentPrinter;
  Var
    hPrinter: THandle;
  Begin
    hPrinter:= GetCurrentPrinterHandle;
    try
      If not WinSpool.SetPrinter( hPrinter, 0, nil,
PRINTER_CONTROL_PURGE )
      Then
        RaiseLastWin32Error;
    finally
      ClosePrinter( hPrinter );
    end;
  End; { PurgeJobsOnCurrentPrinter }


function GetCurrentPrinterHandle1: THandle;
var
  Device, Driver, Port: array[0..255] of Char;
  hDeviceMode: THandle;
begin
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  if not OpenPrinter(@Device, Result, nil) then
    RaiseLastWin32Error;
end;

function SavePChar(p: PChar): PChar;
const
  error: PChar = 'Nil';
begin
  if not Assigned(p) then
    Result := error
  else
    Result := p;
end;

//getPrintername // -1 to set default pronter name
Function GetPrinterName(pPrinterIdx : Integer = -1):String;
begin
if (Printer.Printers.Count > 0) then begin
    // from Peter...
   Printer.PrinterIndex := -1; // select default printer
   result := Printer.Printers[ Printer.PrinterIndex ];
end
else begin
    // this computer does not have any printer installed (in Windows)
end;
end;


procedure TForm1.btnClearPrinterAllJobsClick(Sender: TObject);
begin
  PurgeJobsOnCurrentPrinter;
end;

procedure TForm1.btnShowPrintJobsCountClick(Sender: TObject);
type
  TJobs  = array [0..1000] of JOB_INFO_1;
  PJobs = ^TJobs;
var
  hPrinter: THandle;
  bytesNeeded, numJobs, i: Cardinal;
  pJ: PJobs;
begin
  hPrinter := GetCurrentPrinterHandle;
  try
    EnumJobs(hPrinter, 0, 1000, 1, nil, 0, bytesNeeded,
      numJobs);
    pJ := AllocMem(bytesNeeded);
    if not EnumJobs(hPrinter, 0, 1000, 1, pJ, bytesNeeded,
      bytesNeeded, numJobs) then
      RaiseLastWin32Error;

    lblPrinter.Caption := 'Printer : '+GetPrinterName;
    medPrintJobsCount.Text :=  'Jobs count : '+InttoStr(numJobs);
    memo1.Clear;
    if numJobs = 0 then
      memo1.Lines.Add('No jobs in queue')
    else
      for i := 0 to Pred(numJobs) do
        memo1.Lines.Add(Format('Printer %s, Job %s, Status (%d): %s',
          [SavePChar(pJ^[i].pPrinterName), SavePChar(pJ^[i].pDocument),
          pJ^[i].Status, SavePChar(pJ^[i].pStatus)]));
  finally
    ClosePrinter(hPrinter);
  end;
end;

end.
