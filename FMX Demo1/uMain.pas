unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,{Winspool,FMX.Printer,}
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ScrollBox, FMX.Memo,
  FMX.Printer.Win,Winspool;

type
  TForm2 = class(TForm)
    btnShowPrinter: TButton;
    lblprinter: TLabel;
    medPrintJobsCount: TEdit;
    Memo1: TMemo;
    procedure btnShowPrinterClick(Sender: TObject);
  private
    PrinterWin : TPrinterWin;

    function GetCurrentPrinterHandle: THandle;
    function GetPrinterName: String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}
//
Function TForm2.GetCurrentPrinterHandle: THandle;
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
    //Printer.GetPrinter(Device, Driver, Port, hDeviceMode);

    {FMX.Printer.Win.TPrinterWin}PrinterWin.GetPrinter(Device, Driver, Port, hDeviceMode);
    //If not FMX.Printer.Win.TPrinterWin.OpenPrinter(@Device, Result, @Defaults) Then
      //RaiseLastWin32Error;
  End; { GetCurrentPrinterHandle }

//
//{: Kill all pending jobs on the current printer }
//Procedure PurgeJobsOnCurrentPrinter;
//  Var
//    hPrinter: THandle;
//  Begin
//    hPrinter:= GetCurrentPrinterHandle;
//    try
//      If not WinSpool.SetPrinter( hPrinter, 0, nil,
//PRINTER_CONTROL_PURGE )
//      Then
//        RaiseLastWin32Error;
//    finally
//      ClosePrinter( hPrinter );
//    end;
//  End; { PurgeJobsOnCurrentPrinter }
//
//
//function GetCurrentPrinterHandle1: THandle;
//var
//  Device, Driver, Port: array[0..255] of Char;
//  hDeviceMode: THandle;
//begin
//  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
//  if not OpenPrinter(@Device, Result, nil) then
//    RaiseLastWin32Error;
//end;
//
function SavePChar(p: PChar): PChar;
const
  error: PChar = 'Nil';
begin
  if not Assigned(p) then
    Result := error
  else
    Result := p;
end;
//
//getPrintername // -1 to set default pronter name
Function TForm2.GetPrinterName:String;
begin
  result := PrinterWin.ActivePrinter.Device;
end;
//


procedure TForm2.btnShowPrinterClick(Sender: TObject);
type
  TJobs  = array [0..1000] of JOB_INFO_1;
  PJobs = ^TJobs;
var
  hPrinter: THandle;
  bytesNeeded, numJobs, i: Cardinal;
  pJ: PJobs;
  Device, Driver, Port : array[0..255] of char;
begin
  PrinterWin := TPrinterWin.Create;
  PrinterWin.GetPrinter(Device, Driver, Port, hPrinter);
  //hPrinter :=  GetCurrentPrinterHandle;//Printer.ActivePrinter; //GetCurrentPrinterHandle;
  try
    EnumJobs(hPrinter, 0, 1000, 1, nil, 0, bytesNeeded,
      numJobs);
    pJ := AllocMem(bytesNeeded);
    if not EnumJobs(hPrinter, 0, 1000, 1, pJ, bytesNeeded,
      bytesNeeded, numJobs) then
      RaiseLastWin32Error;

    lblPrinter.Text := 'Printer : '+GetPrinterName;//Printer.ActivePrinter.Device;
    medPrintJobsCount.Text :=  'Jobs count : '+InttoStr(numJobs);
    memo1.Lines.Clear;
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
  (*
  ShowMessage('Active Printer : '+Printer.ActivePrinter.Device+#10#13+
  'Count : '+ InttoStr(Printer.Count));
  *)
end;

end.
