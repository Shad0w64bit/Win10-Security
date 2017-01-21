unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, Menus, VirtualTrees,  Windows;

type

  { TfmMain }

  TfmMain = class(TForm)
    Button1: TButton;
    lbDescription: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PopupMenu1: TPopupMenu;
    vstTweaks: TVirtualStringTree;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure vstTweaksBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTweaksChecking(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var NewState: TCheckState; var Allowed: Boolean);
    procedure vstTweaksFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure vstTweaksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTweaksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure vstTweaksInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
    { private declarations }
//    procedure CreateRestorePoint;
  public
    { public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.lfm}

uses uTweaks;

{ TfmMain }

procedure TfmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  attr: integer;
  hostfile: string;
begin
  hostfile := SysUtils.GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  attr := FileGetAttr(hostfile);

  if (faReadOnly and attr = 0) then
    FileSetAttr(hostfile, attr or faReadOnly);
end;

{
procedure TfmMain.CreateRestorePoint;
var
  fmRestore : TfmRestore;
  mr : TModalResult;
begin
  fmRestore := TfmRestore.Create(fmMain);
  try
    if MessageDlg(ApplicationName, 'Создать точку восстаноления системы?', mtConfirmation, mbYesNo, '') = mrYes then
    begin
      fmRestore.CreateRestorePoint;
      mr := fmRestore.ShowModal;
    end;

    if mr = mrOK then
      MessageDlg(ApplicationName, 'Точка восстановления успешно создана.', mtInformation, [mbOK], '');
    if mr = mrAbort then
      MessageDlg(ApplicationName, 'Не удалось создать точку восстановления!'+#10#13+'Проверьте включена ли функция восстановления в системе.', mtError, [mbOK], '');
  finally
    fmRestore.Free;
  end;
end;
}

procedure TfmMain.Button1Click(Sender: TObject);
var
  pt : Classes.TPoint;
begin
  Pt := ClientToScreen(Classes.Point(Button1.Left, Button1.Top + Button1.Height));
  PopupMenu1.Popup(Pt.X, Pt.Y);
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
 i, attr: integer;
 Node: PVirtualNode;
 Data: PTweakRec;
 hostfile: string;
begin
  randomize;

  hostfile := SysUtils.GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  attr := FileGetAttr(hostfile);

  if (faReadOnly and attr > 0) then
    FileSetAttr(hostfile, attr xor faReadOnly);


{  if GetSystemRestoreInfo = -1 then
    CreateRestorePoint;}

  vstTweaks.NodeDataSize := SizeOf(TTweakRec);
  vstTweaks.BeginUpdate;
  for i:=0 to Length(TweaksWin10)-1 do
  begin
    Node := vstTweaks.AddChild(vstTweaks.RootNode);
//    Node^.CheckType:=ctCheckBox;
    Data := vstTweaks.GetNodeData(Node);
    Data^.ID := TweaksWin10[i].ID;
    Data^.Name := TweaksWin10[i].Name;
    Data^.Desc := TweaksWin10[i].Desc;
    Data^.TweakType:=TweaksWin10[i].TweakType;

    vstTweaks.ReinitNode(Node, false); // Инициализируем то что заполнили
  end;
  vstTweaks.EndUpdate;
end;

procedure TfmMain.MenuItem1Click(Sender: TObject);
var // Рекомендуемые
 Node: PVirtualNode;
 Data: PTweakRec;
begin
  Node:=vstTweaks.RootNode;
  while Node<>nil do begin
    Data := vstTweaks.GetNodeData(Node);
    if Assigned(Data) then
    begin
      if Data^.TweakType=ttRecommended then
        vstTweaks.CheckState[Node]:=csCheckedNormal
      else
        vstTweaks.CheckState[Node]:=csUncheckedNormal;
    end;
    Node:=vstTweaks.GetNext(Node);
  end;
end;

procedure TfmMain.MenuItem2Click(Sender: TObject);
var  // Рекомендуемые и ограниченные
  Node: PVirtualNode;
  Data: PTweakRec;
begin
  Node:=vstTweaks.RootNode;
  while Node<>nil do begin
    Data := vstTweaks.GetNodeData(Node);
    if Assigned(Data) then
    begin
      if (Data^.TweakType=ttRecommended) or (Data^.TweakType=ttLimited) then
         vstTweaks.CheckState[Node]:=csCheckedNormal
      else
        vstTweaks.CheckState[Node]:=csUncheckedNormal;
    end;
    Node:=vstTweaks.GetNext(Node);
  end;
end;

procedure TfmMain.MenuItem3Click(Sender: TObject);
var
 Node: PVirtualNode;
begin
  Node:=vstTweaks.RootNode;
  while Node<>nil do begin
    vstTweaks.CheckState[Node]:=csCheckedNormal;
    Node:=vstTweaks.GetNext(Node);
  end;
end;

procedure TfmMain.MenuItem6Click(Sender: TObject);
var
 Node: PVirtualNode;
begin
  Node:=vstTweaks.RootNode;
  while Node<>nil do begin
    vstTweaks.CheckState[Node]:=csUncheckedNormal;
    Node:=vstTweaks.GetNext(Node);
  end;
end;

procedure TfmMain.MenuItem7Click(Sender: TObject);
begin
//  CreateRestorePoint;
end;

procedure TfmMain.vstTweaksBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
 Data: PTweakRec;
begin
  Data := Sender.GetNodeData(Node);
  case Data^.TweakType of
    ttRecommended: TargetCanvas.Brush.Color := clWhite;
    ttLimited: TargetCanvas.Brush.Color := $00EEEE;
    ttWarning: TargetCanvas.Brush.Color := $8080FF;
  end;

  TargetCanvas.FillRect(TargetCanvas.ClipRect);
end;

procedure TfmMain.vstTweaksChecking(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
var
 Data: PTweakRec;
begin
  // MessageBox точка восстановления
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    if (csCheckedNormal = NewState) then
      UpdateTweak(Data^.ID,atApply)
    else
      UpdateTweak(Data^.ID,atCancel);
end;

procedure TfmMain.vstTweaksFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
//  Node: PVirtualNode;
  Data: PTweakRec;
begin
//  Node := vstTweaks.GetNodeAt(X,Y);
  if (Node = nil) then exit;
  Data := vstTweaks.GetNodeData(Node);
  if Assigned(Data) then
  begin
    lbDescription.Caption:=Data^.Desc;
  end;
end;

procedure TfmMain.vstTweaksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode
  );
var
  Data: PTweakRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Data^.Name := '';
    Data^.Desc := '';
  end;
end;

procedure TfmMain.vstTweaksGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  Data: PTweakRec;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
    CellText := Data^.Name;
end;

procedure TfmMain.vstTweaksInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PTweakRec;
begin
  Node^.CheckType:=ctCheckBox;
  with Sender do
  begin
    Data := GetNodeData(Node);
    if UpdateTweak(Data^.ID, atRefresh) then
      Node^.CheckState:=csCheckedNormal
    else
      Node^.CheckState:=csUncheckedNormal;
  end;
end;


end.

