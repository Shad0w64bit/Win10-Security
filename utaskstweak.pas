unit uTasksTweak;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Taskschd, comobj;

type
   TTaskList = class
    Items: array of IRegisteredTask;
    procedure Add(Item: IRegisteredTask);
  end;

  TTaskState = (tsUnknown, tsDisabled, tsQueued, tsReady, tsRunning);

const
  TaskStateNames : array[TTaskState] of string = ('неизвестно', 'отключено', 'в очереди', 'готово', 'выполеняется');


  function GetTasksIsEnabled: boolean;
  procedure SetTasksStatus(TasksEnable: boolean);

implementation

procedure TTaskList.Add(Item: IRegisteredTask);
begin
    SetLength(Items, Length(Items) + 1);
    Items[Length(Items) - 1] := Item;
end;

function GetTasksIsEnabled: boolean; // true - enable
var                               // false - disable
  ts : ITaskService;
  tf : ITaskFolder;
  task : IRegisteredTask;

  function IsTaskEnabled(sFolder, sTask: WideString): boolean;
  begin
    result := false;
    if (ts.GetFolder(PWideChar(sFolder), tf) = S_OK) then
      if (tf.GetTask(PWideChar(sTask), task) = S_OK) then
        if task.Enabled then
           result := true;
  end;

begin
  result := false;
  ts := CreateComObject(CLSID_TaskScheduler) as ITaskService;
  ts.Connect('', '', '', '');
  if IsTaskEnabled('Microsoft\Windows\Customer Experience Improvement Program','KernelCeipTask') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Customer Experience Improvement Program','UsbCeip') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Power Efficiency Diagnostics','AnalyzeSystem') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Shell','FamilySafetyMonitor') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Shell','FamilySafetyRefresh') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Application Experience','AitAgent') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Application Experience','ProgramDataUpdater') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Application Experience','StartupAppTask') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Autochk','Proxy') then
  begin
  result := true;
  exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Customer Experience Improvement Program','BthSQM') then
  begin
    result := true;
    exit;
  end;

  if IsTaskEnabled('Microsoft\Windows\Customer Experience Improvement Program','Consolidator') then
  begin
    result := true;
    exit;
  end;
end;

procedure SetTasksStatus(TasksEnable: boolean);
var
  ts : ITaskService;
  tf : ITaskFolder;
  task : IRegisteredTask;

  function SetTaskStatus(sFolder, sTask: WideString; Enable: boolean): boolean;
  begin
    result := false;
    if (ts.GetFolder(PWideChar(sFolder), tf) = S_OK) then
      if (tf.GetTask(PWideChar(sTask), task) = S_OK) then
      begin
         task.Enabled:=Enable;
         if task.Enabled then
           result := true;
      end;
  end;

begin
  ts := CreateComObject(CLSID_TaskScheduler) as ITaskService;
  ts.Connect('', '', '', '');
  SetTaskStatus('Microsoft\Windows\Customer Experience Improvement Program','KernelCeipTask',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Customer Experience Improvement Program','UsbCeip',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Power Efficiency Diagnostics','AnalyzeSystem',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Shell','FamilySafetyMonitor',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Shell','FamilySafetyRefresh',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Application Experience','AitAgent',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Application Experience','ProgramDataUpdater',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Application Experience','StartupAppTask',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Autochk','Proxy',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Customer Experience Improvement Program','BthSQM',TasksEnable);
  SetTaskStatus('Microsoft\Windows\Customer Experience Improvement Program','Consolidator',TasksEnable);
end;

end.

