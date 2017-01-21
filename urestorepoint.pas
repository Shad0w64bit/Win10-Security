unit uRestorePoint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, windows, Forms, controls, Dialogs, ComCtrls, variants, activex, ComObj;

const
 // Type of Event
 BEGIN_SYSTEM_CHANGE = 100;
 END_SYSTEM_CHANGE  = 101;
 // Type of Restore Points
 APPLICATION_INSTALL =  0;
 MODIFY_SETTINGS = 12;
 CANCELLED_OPERATION = 13;
 MAX_DESC = 64;
 MIN_EVENT = 100;

// Restore point information
type
  PRESTOREPTINFOW = ^_RESTOREPTINFOW;
  _RESTOREPTINFOW = packed record
      dwEventType: DWORD;  // Type of Event - Begin or End
      dwRestorePtType: DWORD;  // Type of Restore Point - App install/uninstall
      llSequenceNumber: INT64;  // Sequence Number - 0 for begin
      szDescription: array [0..MAX_DESC] of WCHAR; // Description - Name of Application / Operation
  end;
  RESTOREPOINTINFO = _RESTOREPTINFOW;
  PRESTOREPOINTINFOW = ^_RESTOREPTINFOW;

  // Status returned by System Restore

  PSMGRSTATUS = ^_SMGRSTATUS;
  _SMGRSTATUS = packed record
      nStatus: DWORD; // Status returned by State Manager Process
      llSequenceNumber: INT64;  // Sequence Number for the restore point
  end;
  STATEMGRSTATUS =  _SMGRSTATUS;
  PSTATEMGRSTATUS =  ^_SMGRSTATUS;

{  function SRSetRestorePointA(pRestorePtSpec: PRESTOREPOINTINFOA; pSMgrStatus: PSTATEMGRSTATUS): Boolean;
    stdcall; external 'SrClient.dll' Name 'SRSetRestorePointA';}
  function SRSetRestorePointW(pRestorePtSpec: PRESTOREPOINTINFOW; pSMgrStatus: PSTATEMGRSTATUS): Boolean;
    stdcall; external 'SrClient.dll' Name 'SRSetRestorePointW';

  function SRRemoveRestorePoint(dwRPNum: DWORD): DWORD;
    stdcall; external 'SrClient.dll' Name 'SRRemoveRestorePoint';

type
  TRestorePointCallback = procedure (Result: TModalResult) of Object;
  TRestorePointCallbackStatus = procedure (status: string)  of Object;

  type

  { TCreateRestorePoint }

  TCreateRestorePoint = class(TThread) //MyThread - заданное нами имя потока.
  private
    { Private declarations }
    mr: TModalResult;
    pRPC: TRestorePointCallback;
    pStatus: TRestorePointCallbackStatus;
    infoStatus: string;
    function CreateRestorePoint(Description: string): TModalResult;
  protected
    procedure Execute; override;
    procedure callrpc;
    procedure callStatus;
  public
    procedure SetRPC(rpc: TRestorePointCallback);
    procedure SetStatusCallBack(cs: TRestorePointCallbackStatus);
  end;

  function  GetSystemRestoreInfo: integer;

implementation

function  GetSystemRestoreInfo: integer;
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : Variant;
  oEnum         : IEnumvariant;
  sValue        : string;
begin;
  result := -1;

  CoInitialize(nil);
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, 'root\DEFAULT', WbemUser, WbemPassword);
    FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM SystemRestore','WQL',wbemFlagForwardOnly);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    while oEnum.Next(1, FWbemObject, nil) = 0 do
    begin
      sValue:= FWbemObject.Properties_.Item('Description').Value;
      if sValue = 'Win10 Security' then
      begin
        sValue:= FWbemObject.Properties_.Item('SequenceNumber').Value;
        Result := strtoint(sValue);
      end;

      FWbemObject:=Unassigned;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure TCreateRestorePoint.Execute;
var
  I: Integer;
begin
  infoStatus:='Проверка существования точки восстановления';
  Synchronize(@callStatus);

  try
      i:=GetSystemRestoreInfo;
      if i>=0 then
        if MessageDlg(Application.Title,
                      'Точка восстановления уже существует.'+#13#10+'Хотите заменить?',
                      mtInformation, mbYesNo, '') = mrYes then
        begin
          infoStatus:='Удаление точки восстановления';
          Synchronize(@callStatus);
          SRRemoveRestorePoint(i);
        end else begin
          if Assigned(pRPC) then
            Synchronize(@callrpc);
          Exit;
        end;


   except
   end;

  infoStatus:='Создание точки восстановления';
  Synchronize(@callStatus);

  mr:=CreateRestorePoint('Win10 Security');

  if Assigned(pRPC) then
   Synchronize(@callrpc);
end;

procedure TCreateRestorePoint.callrpc;
begin
  if Assigned(pRPC) then
    pRPC(mr);
end;

procedure TCreateRestorePoint.callStatus;
begin
  if Assigned(pStatus) then
    pStatus(infoStatus);
end;

procedure TCreateRestorePoint.SetRPC(rpc: TRestorePointCallback);
begin
  pRPC := rpc;
end;

procedure TCreateRestorePoint.SetStatusCallBack(cs: TRestorePointCallbackStatus
  );
begin
  pStatus:=cs;
end;

function TCreateRestorePoint.CreateRestorePoint(Description: string): TModalResult;
const
 CR = #13#10;
var
  RestorePtSpec: RESTOREPOINTINFO;
  SMgrStatus: STATEMGRSTATUS;
begin
  // Initialize the RESTOREPOINTINFO structure
  RestorePtSpec.dwEventType := BEGIN_SYSTEM_CHANGE;
  RestorePtSpec.dwRestorePtType := MODIFY_SETTINGS;
  RestorePtSpec.llSequenceNumber := 0;
  RestorePtSpec.szDescription := Description;

  result:=mrAbort;

  if (SRSetRestorePointW(@RestorePtSpec, @SMgrStatus)) then
  begin
      // Restore Point Spec to cancel the previous restore point.
      RestorePtSpec.dwEventType := END_SYSTEM_CHANGE;
      RestorePtSpec.dwRestorePtType  := CANCELLED_OPERATION;
      RestorePtSpec.llSequenceNumber := SMgrStatus.llSequenceNumber;

      if (SRSetRestorePointW(@RestorePtSpec, @SMgrStatus)) then
        result := mrOK
          //MessageDlg(ApplicationName, 'Предыдущая точка восстановления отменена.',mtInformation,[mbOK],'')
      else
        result:=mrAbort;
//        MessageDlg(ApplicationName, 'Не удалось отменить точку восстановления.',mtError,[mbOK],'')
    end
    else
      result:=mrAbort;
end;


end.

