unit RestoreViewer;


{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  Variants,
  ComObj,
  ActiveX;

const
  //Event type
  BEGIN_NESTED_SYSTEM_CHANGE = 102;
  BEGIN_SYSTEM_CHANGE = 100;
  END_NESTED_SYSTEM_CHANGE = 103;
  END_SYSTEM_CHANGE = 101;

  //Restore point type
  APPLICATION_INSTALL = 0;
  APPLICATION_UNINSTALL = 1;
  CANCELLED_OPERATION = 13;
  DEVICE_DRIVER_INSTALL = 10;
  MODIFY_SETTINGS = 12;

type
  TRestorePoint = record
    Description:string;
    EventType:string;
    SequenceNumber:string;
    CreationTime:string;
    RestorePointType:string;
  end;

  TRestorePoints = array of TRestorePoint;


  TRestoreViewer = class
  private
    function RestorePointTypeToStr(RestorePointType:Integer):string;
    function EventTypeToStr(EventType:Integer):string;
    function WMITimeToStr(WMITime:string): string;
    function GetWMIObject (const ObjectName:string):IDispatch;
  public
    function GetRestorePoints():TRestorePoints;
  end;

implementation

{ TRestoreViewer }

function TRestoreViewer.EventTypeToStr(EventType: Integer): string;
begin
  case EventType of
    BEGIN_NESTED_SYSTEM_CHANGE: Result := 'BEGIN_NESTED_SYSTEM_CHANGE';
    BEGIN_SYSTEM_CHANGE: Result := 'BEGIN_SYSTEM_CHANGE';
    END_NESTED_SYSTEM_CHANGE: Result := 'END_NESTED_SYSTEM_CHANGE';
    END_SYSTEM_CHANGE: Result := 'END_SYSTEM_CHANGE';
  else
    Result := 'Unknown';
  end;
end;

function TRestoreViewer.GetRestorePoints: TRestorePoints;
var
  ObjWMIService           : OLEVariant;
  ColItems                : OLEVariant;
  ColItem                 : Variant;
  OEnum                   : IEnumvariant;
  IValue                  : LongWord;
  CountOfRestorePoint     : Integer;
  I: Integer;
  RestorePoint            : TRestorePoint;
begin
  ObjWMIService := GetWMIObject('winmgmts:\\localhost\root\default');
  ColItems      := objWMIService.ExecQuery('SELECT * FROM SystemRestore','WQL',0);
  OEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;


  if (VarIsOrdinal(ColItems.Count)) then
    CountOfRestorePoint := StrToInt(VarToStr(ColItems.Count))
  else
    CountOfRestorePoint := 0;

  if (CountOfRestorePoint = 0) then
    Exit;

    SetLength(Result, CountOfRestorePoint);

  I := 0;

  while OEnum.Next(1, colItem, @IValue) = 0 do
  begin
    RestorePoint.Description := ColItem.Description;
    RestorePoint.EventType := EventTypeToStr(ColItem.EventType);
    RestorePoint.SequenceNumber := ColItem.SequenceNumber;
    RestorePoint.CreationTime := WMITimeToStr(ColItem.CreationTime);
    RestorePoint.RestorePointType := RestorePointTypeToStr(ColItem.RestorePointType);

    Result[i] := RestorePoint;
    Inc(I);
  end;
end;

function TRestoreViewer.GetWMIObject(const ObjectName: ansistring): IDispatch;
var
  chEaten: ^Cardinal;
  BindCtx: IBindCtx;//for access to a bind context
  Moniker: IMoniker;//Enables you to use a moniker object
begin
  OleCheck(CreateBindCtx(0, bindCtx));
  OleCheck(MkParseDisplayName(BindCtx, StringToOleStr(objectName), chEaten, Moniker));//Converts a string into a moniker that identifies the object named by the string
  OleCheck(Moniker.BindToObject(BindCtx, nil, IDispatch, Result));//Binds to the specified object
end;

function TRestoreViewer.RestorePointTypeToStr(
  RestorePointType: Integer): string;
begin
  case RestorePointType of
    APPLICATION_INSTALL: Result := 'APPLICATION_INSTALL';
    APPLICATION_UNINSTALL: Result := 'APPLICATION_UNINSTALL';
    CANCELLED_OPERATION: Result := 'CANCELLED_OPERATION';
    DEVICE_DRIVER_INSTALL: Result:= 'DEVICE_DRIVE_INSTALL';
    MODIFY_SETTINGS: Result:= 'MODIFY_SETTINGS';
  else
    Result := 'Unknown';
  end;
end;

function TRestoreViewer.WMITimeToStr(WMITime: string): string;
begin
 result:=Format('%s/%s/%s %s:%s:%s',[copy(WMITime,7,2),copy(WMITime,5,2),
                                     copy(WMITime,1,4),copy(WMITime,9,2),
                                     copy(WMITime,11,2),copy(WMITime,13,2)
                                    ]);
end;
end.
