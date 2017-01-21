unit uHost;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


function HostIsBlockNormal: boolean;
function HostIsBlockExtra: boolean;
function HostIsBlockSuperExtra: boolean;

procedure SetHostBlockNormal;
procedure SetHostBlockExtra;
procedure SetHostBlockSuperExtra;

procedure SetHostNotBlockNormal;
procedure SetHostNotBlockExtra;
procedure SetHostNotBlockSuperExtra;


implementation

const
  NormalBlockList : array[0..89] of string = (
    'a-0001.a-msedge.net', 'a-0002.a-msedge.net', 'a-0003.a-msedge.net',
    'a-0004.a-msedge.net', 'a-0005.a-msedge.net', 'a-0006.a-msedge.net', 'a-0007.a-msedge.net',
    'a-0008.a-msedge.net', 'a-0009.a-msedge.net', 'a-msedge.net', 'a.ads1.msn.com', 'a.ads2.msads.net',
    'a.ads2.msn.com', 'a.rad.msn.com', 'ac3.msn.com', 'ad.doubleclick.net', 'adnexus.net', 'adnxs.com',
    'ads.msn.com', 'ads1.msads.net', 'ads1.msn.com', 'aidps.atdmt.com', 'aka-cdn-ns.adtech.de',
    'az361816.vo.msecnd.net', 'az512334.vo.msecnd.net', 'b.ads1.msn.com',
    'b.ads2.msads.net', 'b.rad.msn.com', 'bs.serving-sys.com', 'c.atdmt.com', 'c.msn.com',
    'cdn.atdmt.com', 'cds26.ams9.msecn.net', 'choice.microsoft.com', 'choice.microsoft.com.nsatc.net',
    'compatexchange.cloudapp.net', 'corp.sts.microsoft.com', 'corpext.msitadfs.glbdns2.microsoft.com',
    'cs1.wpc.v0cdn.net', 'db3aqu.atdmt.com', 'df.telemetry.microsoft.com',
    'diagnostics.support.microsoft.com', 'ec.atdmt.com', 'feedback.microsoft-hohm.com',
    'feedback.search.microsoft.com', 'feedback.windows.com', 'flex.msn.com', 'g.msn.com', 'h1.msn.com',
    'i1.services.social.microsoft.com', 'i1.services.social.microsoft.com.nsatc.net',
    'lb1.www.ms.akadns.net', 'live.rads.msn.com', 'm.adnxs.com', 'msedge.net',
    'msftncsi.com', 'msnbot-65-55-108-23.search.msn.com', 'msntest.serving-sys.com',
    'oca.telemetry.microsoft.com', 'oca.telemetry.microsoft.com.nsatc.net', 'pre.footprintpredict.com',
    'preview.msn.com', 'rad.live.com', 'rad.msn.com', 'redir.metaservices.microsoft.com',
    'schemas.microsoft.akadns.net ', 'secure.adnxs.com', 'secure.flashtalking.com',
    'settings-sandbox.data.microsoft.com', 'settings-win.data.microsoft.com',
    'sls.update.microsoft.com.akadns.net', 'sqm.df.telemetry.microsoft.com',
    'sqm.telemetry.microsoft.com', 'sqm.telemetry.microsoft.com.nsatc.net', 'static.2mdn.net',
    'statsfe1.ws.microsoft.com', 'statsfe2.ws.microsoft.com', 'telecommand.telemetry.microsoft.com',
    'telecommand.telemetry.microsoft.com.nsatc.net', 'telemetry.appex.bing.net',
    'telemetry.microsoft.com', 'telemetry.urs.microsoft.com',
    'vortex-bn2.metron.live.com.nsatc.net', 'vortex-cy2.metron.live.com.nsatc.net',
    'vortex-sandbox.data.microsoft.com', 'vortex-win.data.microsoft.com', 'vortex.data.microsoft.com',
    'watson.live.com', 'www.msftncsi.com', 'ssw.live.com'
  );
  ExtraBlockList : array [0..17] of string = (
    'fe2.update.microsoft.com.akadns.net', 'reports.wes.df.telemetry.microsoft.com', 's0.2mdn.net',
    'services.wes.df.telemetry.microsoft.com', 'statsfe2.update.microsoft.com.akadns.net',
    'survey.watson.microsoft.com', 'view.atdmt.com', 'watson.microsoft.com',
    'watson.ppe.telemetry.microsoft.com', 'watson.telemetry.microsoft.com',
    'watson.telemetry.microsoft.com.nsatc.net', 'wes.df.telemetry.microsoft.com', 'ui.skype.com',
    'pricelist.skype.com', 'apps.skype.com', 'm.hotmail.com', 's.gateway.messenger.live.com',
    'choice.microsoft.com.nstac.net'
  );

  SuperExtraBlockList : array [0..3] of string = (
    'spynet2.microsoft.com','spynetalt.microsoft.com','h2.msn.com','sO.2mdn.net'
  );

function HostIsBlockNormal: boolean; // true - block, false, not block
var
  i: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  result:=true;
  try
    sl.LoadFromFile(GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts');
    for i:=0 to Length(NormalBlockList)-1 do
    if Pos(#9+NormalBlockList[i], sl.Text) = 0  then
    begin
      result:=false;
      exit;
    end;
  finally
    sl.Free;
  end;
end;

function HostIsBlockExtra: boolean; // true - block, false, not block
var
  i: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  result:=true;
  try
    sl.LoadFromFile(GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts');
    for i:=0 to Length(ExtraBlockList)-1 do
    if Pos(#9+ExtraBlockList[i], sl.Text) = 0 then
    begin
      result:=false;
      exit;
    end;
  finally
    sl.Free;
  end;
end;

function HostIsBlockSuperExtra: boolean; // true - block, false, not block
var
  i: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  result:=true;
  try
    sl.LoadFromFile(GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts');
    for i:=0 to Length(SuperExtraBlockList)-1 do
    if Pos(#9+SuperExtraBlockList[i], sl.Text) = 0 then
    begin
      result:=false;
      exit;
    end;
  finally
    sl.Free;
  end;
end;

procedure SetHostBlockNormal;
var
  i: integer;
  sl: TStringList;
  hostpath: string;
begin
  sl := TStringList.Create;
  hostpath := GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  try
    sl.LoadFromFile(hostpath);

    for i:=0 to Length(NormalBlockList)-1 do
      if Pos(#9+NormalBlockList[i], sl.Text) = 0 then
        sl.Add('0.0.0.0'+#9+NormalBlockList[i]);

    sl.SaveToFile(hostpath);
  finally
    sl.Free;
  end;
end;

procedure SetHostBlockExtra;
var
  i: integer;
  sl: TStringList;
  hostpath: string;
begin
  sl := TStringList.Create;
  hostpath := GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  try
    sl.LoadFromFile(hostpath);

    for i:=0 to Length(ExtraBlockList)-1 do
      if Pos(#9+ExtraBlockList[i], sl.Text) = 0 then
        sl.Add('0.0.0.0'+#9+ExtraBlockList[i]);

    sl.SaveToFile(hostpath);
  finally
    sl.Free;
  end;
end;

procedure SetHostBlockSuperExtra;
var
  i: integer;
  sl: TStringList;
  hostpath: string;
begin
  sl := TStringList.Create;
  hostpath := GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  try
    sl.LoadFromFile(hostpath);

    for i:=0 to Length(SuperExtraBlockList)-1 do
      if Pos(#9+SuperExtraBlockList[i], sl.Text) = 0 then
        sl.Add('0.0.0.0'+#9+SuperExtraBlockList[i]);

    sl.SaveToFile(hostpath);
  finally
    sl.Free;
  end;
end;

procedure SetHostNotBlockNormal;
var
  i, j: integer;
  sl: TStringList;
  hostpath: string;
  Del: Boolean;
begin
  sl := TStringList.Create;
  hostpath := GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';

  try
    sl.LoadFromFile(hostpath);

    for i:=sl.Count-1 downto 0 do
      if (sl.Strings[i] = EmptyStr) or (sl.Strings[i][1]=PChar('#')) then
        Continue
      else
      begin
        Del := false;
        for j:=0 to Length(NormalBlockList)-1 do
          if (not del) and (Pos(#9+NormalBlockList[j], sl.Strings[i]) > 0) then
          begin
            del := true;
            sl.Delete(i);
            Continue;
          end;
      end;

    sl.SaveToFile(hostpath);
  finally
    sl.Free;
  end;
end;

procedure SetHostNotBlockExtra;
var
  i, j: integer;
  sl: TStringList;
  hostpath: string;
  Del: Boolean;
begin
  sl := TStringList.Create;
  hostpath := GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  try
    sl.LoadFromFile(hostpath);

    for i:=sl.Count-1 downto 0 do
      if (sl.Strings[i] = EmptyStr) or (sl.Strings[i][1]=PChar('#')) then
        Continue
      else
      begin
        Del := false;
        for j:=0 to Length(ExtraBlockList)-1 do
          if (not del) and (Pos(#9+ExtraBlockList[j], sl.Strings[i]) > 0) then
          begin
            del := true;
            sl.Delete(i);
            Continue;
          end;
      end;

    sl.SaveToFile(hostpath);
  finally
    sl.Free;
  end;
end;

procedure SetHostNotBlockSuperExtra;
var
  i, j: integer;
  sl: TStringList;
  hostpath: string;
  Del: Boolean;
begin
  sl := TStringList.Create;
  hostpath := GetEnvironmentVariable('WinDir')+'\System32\drivers\etc\hosts';
  try
    sl.LoadFromFile(hostpath);

    for i:=sl.Count-1 downto 0 do
      if (sl.Strings[i] = EmptyStr) or (sl.Strings[i][1]=PChar('#')) then
        Continue
      else
      begin
        Del := false;
        for j:=0 to Length(SuperExtraBlockList)-1 do
          if (not del) and (Pos(#9+SuperExtraBlockList[j], sl.Strings[i]) > 0) then
          begin
            del := true;
            sl.Delete(i);
            Continue;
          end;
      end;

    sl.SaveToFile(hostpath);
  finally
    sl.Free;
  end;
end;

end.

