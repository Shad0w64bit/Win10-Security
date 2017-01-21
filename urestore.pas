unit uRestore;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, uRestorePoint;

type

  { TfmRestore }

  TfmRestore = class(TForm)
    lblInfo: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    mr: TModalResult;
    crp: TCreateRestorePoint;
    procedure CallbackCRP(mResult: TModalResult);
    procedure CallbackStatus(status: string);
  public
    { public declarations }
    procedure CreateRestorePoint;
  end;

var
  fmRestore: TfmRestore;

implementation

{$R *.lfm}

{ TfmRestore }

procedure TfmRestore.CallbackCRP(mResult: TModalResult);
begin
  mr:=mResult;
  crp.Terminate;
  crp.Suspended:=true;
  Close;
end;

procedure TfmRestore.CallbackStatus(status: string);
begin
  lblInfo.Caption:=Status;
end;

procedure TfmRestore.CreateRestorePoint;
begin
  crp.Start;
  ProgressBar1.Style:=pbstMarquee;
end;

procedure TfmRestore.FormCreate(Sender: TObject);
begin
  crp:=TCreateRestorePoint.Create(true);
  crp.Priority:=tpNormal;
  crp.SetRPC(@CallbackCRP);
  crp.SetStatusCallback(@CallbackStatus);
end;

procedure TfmRestore.FormShow(Sender: TObject);
begin

end;

procedure TfmRestore.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ModalResult:=mr;
end;

procedure TfmRestore.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  i: integer;
begin
  if not crp.Suspended then
  begin
     i := GetSystemRestoreInfo;
     if i >= 0 then
       SRRemoveRestorePoint(i);

     mr:=mrCancel;         // не обрабатывает mrAbort
     crp.Terminate;
     close;
  end;
end;

end.

