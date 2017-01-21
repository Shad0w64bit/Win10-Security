program Win10Tw;

{$mode objfpc}{$H+}

uses
  Interfaces, // this includes the LCL widgetset
  Forms, virtualtreeview_package, uMain, uTweaks, SPGetSid
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Win10 Security';
  RequireDerivedFormResource := True;
  Application.MainFormOnTaskBar:=true;
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.

