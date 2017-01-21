unit uTweaks;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Registry, SPGetSid, uTasksTweak, uHost, dialogs, windows;

type
  TActionTweak = (atRefresh = 0, atApply = 1, atCancel = 2);
  TTweakType = (ttRecommended = 0, ttLimited = 1, ttWarning = 2);

  PTweakRec = ^TTweakRec;
  TTweakRec = record
    ID: integer;
    Name: string[255];
    Desc: string;
    TweakType: TTweakType;
  end;

const
  TweaksWin10 : array [0..80] of TTweakRec =
  (
  ( ID:101; Name:'Отключить кнопку показа пароля'; Desc:'На экране входа в систему при наборе пароля вы можете наблюдать кнопку с надписью "Показать пароль". Данная опция отключает ее.';TweakType: ttRecommended),
  ( ID:102; Name:'Отключить средство записи действий пользователя'; Desc:'Средство записи действий ведет учет действий пользователя. Данные созданные средством записи действий, могут быть использованы в системах обратной связи, например в отчетах об ошибках Windows, позволяющих разработчикам распознавать и устранять проблемы. Эти данные включают такие действия пользователя как ввод с клавиатры и ввод с помощью мыши, данные пользовательского интерфейса и снимки экрана.';TweakType: ttRecommended),
  ( ID:103; Name:'Отключить телеметрию (1 из 3)'; Desc:'Отключает службу диагностического отслеживания (DiagTrack). Данная служба позволяет собирать сведения о функциональных проблемах, связанных с компонентами Windows.';TweakType: ttRecommended),
  ( ID:104; Name:'Отключить телеметрию (2 из 3)'; Desc:'Отключает службу маршрутизации push-сообщений WAP (dmwappushservice)';TweakType: ttRecommended),
  ( ID:105; Name:'Отключить телеметрию (3 из 3)'; Desc:'Отключает встроенный в систему AutoLogger. Трассировка сессии AutoLogger записывает события которые происходят в самом начале процесса загрузки операционной системы. Приложения и драйверы устройств могут использовать сессию AutoLogger для захвата следов работы программы до входа пользователя в систему.';TweakType: ttRecommended),
  ( ID:106; Name:'Отключить WiFi Sense'; Desc:'';TweakType: ttRecommended),
  ( ID:107; Name:'Отключить WiFi Sense для моих контактов'; Desc:'';TweakType: ttRecommended),
  ( ID:108; Name:'Отключить доступ приложений Windows Store к беспроводным соединениям'; Desc:'Данная опция лишает все метро-приложения беспроводной связи (WiFi, Bluetooth, и т.д.). Это означает что некоторые приложения не смогут работать должным образом.';TweakType: ttLimited),
  ( ID:109; Name:'Отключить доступ приложений Windows Store для слабосвязных устройств'; Desc:'Если отключить этот параметр, необходимо будет вручную включать разрешения установленным приложениям, для доступа к беспроводной сети.';TweakType: ttLimited),
  ( ID:110; Name:'Отключить доступ в интернет Windows Media Digital Rights Managment (DRM)'; Desc:'Некоторые музыкальные и видео файлы имеют так называемую защиту DRM, которая гарантирует что эти файлы могуть быть воспроизведены только на компьютере (или телевизоре) и защищает файл от копирования. Если у вас есть файлы с DRM защитой не включайте данную опцию, иначе вы больше не сможете воспроизвести такие файлы.';TweakType: ttLimited),
  ( ID:111; Name:'Отключить "Защитник Windows" (Windows Defender)'; Desc:'Отключает встроенный в систему антивирус "Защитник Windows". Данную настройку рекомендуется включать только если у вас установлен другой антивирус.';TweakType: ttWarning),

  //          Privacy
  ( ID:201; Name:'Отключить приложениям доступ к информации о пользователе.'; Desc:'';TweakType: ttRecommended),
  ( ID:202; Name:'Отключить отправку образцов рукописного ввода'; Desc:'';TweakType: ttRecommended),
  ( ID:203; Name:'Отключить отправку ошибок распознавания образцов рукописного ввода'; Desc:'';TweakType: ttRecommended),
  ( ID:204; Name:'Отключить сбор данных о совместимости приложений'; Desc:'Отключает сбор данных, отправку образцов и информации о совместимости приложений.';TweakType: ttRecommended),
//  ( ID:627; Name:'Отключить отправку образцов Защитника Windows'; Desc:'Отключает сбор данных и отправку образцов защитником Windows.';TweakType: ttRecommended),
  ( ID:205; Name:'Отключить сбор пользовательских данных (1 из 5)'; Desc:'Отключает принятие политики конфеденциальности.';TweakType: ttRecommended),
  ( ID:206; Name:'Отключить сбор пользовательских данных (2 из 5)'; Desc:'Microsoft собирает информацию о голосовых, рукописных и иных методов ввода, почерке, в том числе записи календаря и ваши контакты.';TweakType: ttRecommended),
  ( ID:207; Name:'Отключить сбор пользовательских данных (3 из 5)'; Desc:'Microsoft собирает информацию о голосовых, рукописных и иных методов ввода, почерке, в том числе записи календаря и ваши контакты.';TweakType: ttRecommended),
  ( ID:208; Name:'Отключить сбор пользовательских данных (4 из 5)'; Desc:'Microsoft собирает информацию о голосовых, рукописных и иных методов ввода, почерке, в том числе записи календаря и ваши контакты.';TweakType: ttRecommended),
  ( ID:209; Name:'Отключить сбор пользовательских данных (5 из 5)'; Desc:'Microsoft собирает информацию о голосовых, рукописных и иных методов ввода, почерке, в том числе записи календаря и ваши контакты.';TweakType: ttRecommended),
  ( ID:210; Name:'Отключить камеру на экране входа в систему'; Desc:'Отключает камеру на экране входа в систему.';TweakType: ttRecommended),
  ( ID:211; Name:'Отключить голосовой помощник Cortana'; Desc:'Отключает голосовой помощник Cortana и сбрасывает его настройки.';TweakType: ttRecommended),
  ( ID:212; Name:'Отключить передачу набраного текста'; Desc:'Windows 10 по умолчанию отправляет в Microsoft часть писем и набранного текста. Насколько эти данные анонимны и какая именно информация отправляется неизвестно.';TweakType: ttRecommended),
  ( ID:213; Name:'Отключить и сбросить идентификатор рекламы (1 из 3)'; Desc:'Отключает "умную рекламу", она создает и показывает рекламу на основе информации которую пользователь ранее искал или посещал.';TweakType: ttRecommended),
  ( ID:214; Name:'Отключить и сбросить идентификатор рекламы (2 из 3)'; Desc:'Отключает "умную рекламу", она создает и показывает рекламу на основе информации которую пользователь ранее искал или посещал.';TweakType: ttRecommended),
  ( ID:227; Name:'Отключить и сбросить идентификатор рекламы (3 из 3)'; Desc:'Отключает "умную рекламу", она создает и показывает рекламу на основе информации которую пользователь ранее искал или посещал.';TweakType: ttRecommended),
  ( ID:215; Name:'Отключить уведомления приложений'; Desc:'';TweakType: ttLimited),
  ( ID:216; Name:'Отключить приложениям доступ к календарю'; Desc:'';TweakType: ttLimited),
  ( ID:217; Name:'Отключить приложениям доступ к камере'; Desc:'';TweakType: ttLimited),
  ( ID:218; Name:'Отключить приложениям доступ к местоположению (1 из 2)'; Desc:'';TweakType: ttLimited),
  ( ID:219; Name:'Отключить приложениям доступ к местоположению (2 из 2)'; Desc:'';TweakType: ttLimited),
  ( ID:220; Name:'Отключить приложениям доступ к микрофону'; Desc:'';TweakType: ttLimited),
  ( ID:221; Name:'Отключить приложениям доступ к сообщениям'; Desc:'';TweakType: ttLimited),
  ( ID:222; Name:'Отключить биометрическое расширение'; Desc:'Отключение данной службы не позволит использовать приложениям в том числе и входу в систему использовать биометрические данные (например отпечаток пальца).';TweakType: ttLimited),
  ( ID:223; Name:'Отключить браузеру доступ к списку языков компьютера'; Desc:'';TweakType: ttLimited),
  ( ID:224; Name:'Отключить SmartScreen'; Desc:'Отключает фильтр URL - SmartScreen.';TweakType: ttWarning),
  ( ID:225; Name:'Отключить управление качеством ПО (SQM)'; Desc:'Software Quality Management (SQM) - управление качеством программного обеспечения';TweakType: ttRecommended),
  ( ID:226; Name:'Отключить SQMLogger'; Desc:'';TweakType: ttRecommended),


  //          Location Services
  ( ID:301; Name:'Отключить функциональность отслеживания системы (1 из 2)'; Desc:'';TweakType: ttRecommended),
  ( ID:302; Name:'Отключить функциональность отслеживания системы (2 из 2)'; Desc:'';TweakType: ttRecommended),
  ( ID:303; Name:'Отключить функциональность отслеживания системы скриптами'; Desc:'';TweakType: ttRecommended),
  ( ID:304; Name:'Отключить датчики для определения местоположения'; Desc:'';TweakType: ttRecommended),



  //          User Behaviour
  ( ID:401; Name:'Отключить телеметрию в приложениях (1 из 3)'; Desc:'Отключение этой функции приводит к тому что Windows больше не будет отсылать в Microsoft данные телеметрии, такие как данные программ, аварийные ситуации, ошибки входа в Windows и др.';TweakType: ttRecommended),
  ( ID:402; Name:'Отключить телеметрию в приложениях (2 из 3)'; Desc:'Отключение этой функции приводит к тому что Windows больше не будет отсылать в Microsoft данные телеметрии, такие как данные программ, аварийные ситуации, ошибки входа в Windows и др.';TweakType: ttRecommended),
  ( ID:403; Name:'Отключить телеметрию в приложениях (3 из 3)'; Desc:'Отключение этой функции приводит к тому что Windows больше не будет отсылать в Microsoft данные телеметрии, такие как данные программ, аварийные ситуации, ошибки входа в Windows и др.';TweakType: ttRecommended),

  //          Windows Update
  ( ID:501; Name:'Отключить обновление Windows через децентрализованную сеть (1 из 3)'; Desc:'Децентрализованная сеть P2P - это сеть в которой обычно отсутсвует выделеный сервер и все участники обмена равны, а каждый участник является одновременно и сервером и клиентом.';TweakType: ttRecommended),
  ( ID:502; Name:'Отключить обновление Windows через децентрализованную сеть (2 из 3)'; Desc:'Децентрализованная сеть P2P - это сеть в которой обычно отсутсвует выделеный сервер и все участники обмена равны, а каждый участник является одновременно и сервером и клиентом.';TweakType: ttRecommended),
  ( ID:503; Name:'Отключить обновление Windows через децентрализованную сеть (3 из 3)'; Desc:'Децентрализованная сеть P2P - это сеть в которой обычно отсутсвует выделеный сервер и все участники обмена равны, а каждый участник является одновременно и сервером и клиентом.';TweakType: ttRecommended),
  ( ID:504; Name:'Отложить обновление Windows (1 из 2)'; Desc:'Некоторые выпуски Windows 10 позволяют отложить обновления на компьютере. Если вы откладываете обновления, новые функции Windows не будут загружаться или устанавливаться в течение нескольких месяцев. В отложенные обновления не входят обновления безопасности. Обратите внимание, что в этом случае вы не сможете получать новейшие возможности Windows, как только они станут доступны.';TweakType: ttLimited),
  ( ID:510; Name:'Отложить обновление Windows (2 из 2)'; Desc:'Некоторые выпуски Windows 10 позволяют отложить обновления на компьютере. Если вы откладываете обновления, новые функции Windows не будут загружаться или устанавливаться в течение нескольких месяцев. В отложенные обновления не входят обновления безопасности. Обратите внимание, что в этом случае вы не сможете получать новейшие возможности Windows, как только они станут доступны.';TweakType: ttLimited),
  ( ID:505; Name:'Отключить автоматический поиск драйверов через Windows Update (1 из 3)'; Desc:'При подключении нового устройства, больше не будет осуществлятся поиск подходящих драйверов на серверах Microsoft.';TweakType: ttLimited),
  ( ID:615; Name:'Отключить автоматический поиск драйверов через Windows Update (2 из 3)'; Desc:'При подключении нового устройства, больше не будет осуществлятся поиск подходящих драйверов на серверах Microsoft.'; TweakType: ttLimited),
  ( ID:616; Name:'Отключить автоматический поиск драйверов через Windows Update (3 из 3)'; Desc:'При подключении нового устройства, больше не будет осуществлятся поиск подходящих драйверов на серверах Microsoft.'; TweakType: ttLimited),
  ( ID:506; Name:'Отключить автоматическое обновление Windows (1 из 2)'; Desc:'Отключает автоматическое обновление Windows.';TweakType: ttWarning),
  ( ID:507; Name:'Отключить автоматическое обновление Windows (2 из 2)'; Desc:'Отключает автоматическое обновление Windows.';TweakType: ttWarning),
  ( ID:508; Name:'Отключить обновление Windows для других продуктов (Microsoft Office и д.р.)'; Desc:'Отключает получения обновлений для других продуктов с серверов Microsoft.';TweakType: ttWarning),
  ( ID:509; Name:'Отключить обновление баз-вирусов "Защитника Windows"'; Desc:'Защитник Windows больше не будет получать обновления вирусных баз из интернета.';TweakType: ttWarning),

  //          Miscellaneous
  ( ID:601; Name:'Отключить запрос отзывов о Windows (1 из 2)'; Desc:'Устанавливает период формирования отзывов в значение: Никогда.';TweakType: ttRecommended),
  ( ID:602; Name:'Отключить запрос отзывов о Windows (2 из 2)'; Desc:'Устанавливает период формирования отзывов в значение: Никогда.';TweakType: ttRecommended),
  ( ID:603; Name:'Отключить расширение Windows 10 - "Поиск с Bing"'; Desc:'';TweakType: ttRecommended),
  ( ID:604; Name:'Отключить Microsoft OneDrive (1 из 2)'; Desc:'';TweakType: ttLimited),
  ( ID:608; Name:'Отключить Microsoft OneDrive (2 из 2)'; Desc:'';TweakType: ttLimited),
  ( ID:622; Name:'Убрать значек OneDrive из проводника'; Desc:'Этот параметр просто убирает значек OneDrive из проводника.'; TweakType: ttLimited),
  ( ID:605; Name:'Включить DoNotTrack в Edge'; Desc:'Отправлять запрос сайтам о том что вы не хотите раскрывать свое местоположение.';TweakType: ttLimited),
  ( ID:606; Name:'Отключить поиск в интернете для панели поиска'; Desc:'Если включить эту опцию, возможность поиска в Интернете на панели поиска Windows будет недоступна.';TweakType: ttLimited),
  ( ID:607; Name:'Отключить сенсор местоположения (GPS)'; Desc:'';TweakType: ttLimited),
  ( ID:619; Name:'Отключить Cortana'; Desc:''; TweakType: ttLimited),
  ( ID:609; Name:'Отключить Cortana в панели поиска'; Desc:'';TweakType: ttLimited),
  ( ID:610; Name:'Отключить интернет для поисковых запросов через меню'; Desc:'Поисковые запросы не будут выполняться в Интернете и результаты из Интернета не будут отображаться при выполнении пользователем поискового запроса.';TweakType: ttLimited),
  ( ID:611; Name:'Отключить использование ограниченных соединений'; Desc:'Если вы включаете этот параметр, поисковые запросы не будут выполняться в Интернете через лимитные подключения и результаты из Интернета не будут отображаться при выполнении пользователем поискового запроса.';TweakType: ttLimited),
  ( ID:612; Name:'Отключить передачу метаданных'; Desc:'Отключает автоматическое получение приложений и информацию о новых устройствах из интернета.';TweakType: ttWarning),
  ( ID:613; Name:'Отключить автоматическое обновление Магазина приложений'; Desc:'Отключает автоматическое обновление Магазина приложений и установленных приложений. Старые версии приложений могут содержать "дыры" в безопасности.';TweakType: ttLimited),
  ( ID:614; Name:'Отключить KMS client Online Activation'; Desc:''; TweakType: ttRecommended),
  ( ID:617; Name:'Отключить Windows Update Sharing'; Desc:''; TweakType: ttRecommended),
  ( ID:618; Name:'Отключить WiFi Sense (1 из 3)'; Desc:''; TweakType: ttRecommended),
  ( ID:620; Name:'Отключить WiFi Sense (2 из 3)'; Desc:'Отключить автоматическое подключение к открытым точкам Wi-Fi'; TweakType: ttRecommended),
  ( ID:621; Name:'Отключить WiFi Sense (3 из 3)'; Desc:'Отключить журналирование WiFi Sense'; TweakType: ttRecommended),
  ( ID:623; Name:'Отключить запланированные задания'; Desc:''; TweakType: ttRecommended),
  ( ID:624; Name:'Заблокировать шпионские Hosts (1 из 3)'; Desc:'Заблокировать наиболее известные шпионские домены'; TweakType: ttRecommended),
  ( ID:625; Name:'Заблокировать шпионские Hosts (2 из 3)'; Desc:'Заблокировать менее известные шпионские домены'; TweakType: ttRecommended),
  ( ID:626; Name:'Заблокировать шпионские Hosts (3 из 3)'; Desc:'Заблокировать все известные шпионские домены'; TweakType: ttRecommended)
  );

//  ( ID:; Name:''; Desc:''),

function UpdateTweak(ID: integer; Action: TActionTweak): boolean;


implementation

procedure ChangeKeyAttribute(stKey: string);
label Finish;
var
  lRetCode: LongWord;
  Key: HKey;
  sia: SID_IDENTIFIER_AUTHORITY;
  pAdministratorsSid: PSID;
  pInteractiveSid: PSID;
  dwAclSize: DWORD;
  pDacl: PACL;
  sd: SECURITY_DESCRIPTOR;
begin
  if Win32Platform<>VER_PLATFORM_WIN32_NT then Exit;
  lRetCode := RegOpenKeyEx(
        HKEY_LOCAL_MACHINE, PChar(stKey), 0, WRITE_DAC or KEY_WOW64_64KEY, Key);
  if (lRetCode <> ERROR_SUCCESS) then Exit;

  pDacl := nil;
  sia.Value[0]:=0; sia.Value[1]:=0; sia.Value[2]:=0;
  sia.Value[3]:=0; sia.Value[4]:=0; sia.Value[5]:=5;
  pInteractiveSid := nil;
  pAdministratorsSid := nil;
  if not(AllocateAndInitializeSid(
    sia, 1, SECURITY_INTERACTIVE_RID,
    0, 0, 0, 0, 0, 0, 0, pInteractiveSid)) then goto Finish;
  if not(AllocateAndInitializeSid(
    sia, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
    0, 0, 0, 0, 0, 0, pAdministratorsSid)) then goto Finish;

    dwAclSize := sizeof(ACL) +
        2 * ( sizeof(ACCESS_ALLOWED_ACE) - sizeof(DWORD) ) +
        GetLengthSid(pInteractiveSid) +
        GetLengthSid(pAdministratorsSid);

  pDacl := PACL(HeapAlloc(GetProcessHeap(), 0, dwAclSize));

  if not (InitializeAcl(pDacl^, dwAclSize, ACL_REVISION)) then goto Finish;

  if not (AddAccessAllowedAce(
    pDacl, ACL_REVISION, KEY_ALL_ACCESS, pInteractiveSid)) then goto Finish;
  if not(AddAccessAllowedAce(
    pDacl, ACL_REVISION, KEY_ALL_ACCESS, pAdministratorsSid)) then goto Finish;

  if not (InitializeSecurityDescriptor(@sd, SECURITY_DESCRIPTOR_REVISION)) then goto Finish;

  if not (SetSecurityDescriptorDacl(@sd, TRUE, pDacl, FALSE)) then goto Finish;

  lRetCode := RegSetKeySecurity(
    Key, SECURITY_INFORMATION(DACL_SECURITY_INFORMATION), @sd);
  if (lRetCode <> ERROR_SUCCESS) then
    showmessage('error');

Finish:

    RegCloseKey(Key);
    RegCloseKey(HKEY_LOCAL_MACHINE);

    if (pDacl <> nil) then HeapFree(GetProcessHeap(), 0, pDacl);
    if (pInteractiveSid <> nil) then FreeSid(pInteractiveSid);
    if (pAdministratorsSid <>nil) then FreeSid(pAdministratorsSid);

end;

function UpdateTweak(ID: integer; Action: TActionTweak): boolean;
var
  Reg, Reg32: Registry.TRegistry;
  Val: string;
  ValueInt: integer;
  mask: integer;
begin
  result := false;
  if Action = atRefresh then
     Reg:=TRegistry.Create(KEY_READ or KEY_WOW64_64KEY)
  else
    Reg:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);

  try

    case ID of
    101: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\CredUI', true);
            Val := 'DisablePasswordReveal';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    102: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\AppCompat', true);
            Val := 'DisableUAR';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    103: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('System\CurrentControlSet\Services\DiagTrack', true);
            Val := 'Start';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 4) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,4);
              atCancel:
                Reg.WriteInteger(Val,2);
            end;

          end;
    104: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('System\CurrentControlSet\Services\dmwappushservice', true);
            Val := 'Start';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 4) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,4);
              atCancel:
                Reg.WriteInteger(Val,2);
            end;

          end;
    105: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('System\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener', true);
            Val := 'Start';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              // echo «» > AutoLogger-Diagtrack-Listener.etl
              //   cacls AutoLogger-Diagtrack-Listener.etl /d SYSTEM
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    106: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            // SID пользователя
            // Wow6432Node
            Reg.OpenKey('SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\'+GetCurrentUserSid, true);
            Val := 'FeatureStates';
            mask := 1; // проверяем первый бит
            case Action of                          // 1 - Disable WiFi sense
              atRefresh: try

                           try
                             ValueInt := StrToInt(Reg.ReadString(Val));
                           except
                             on Exception : EConvertError do
                             ValueInt := 893;
                           end;

                           if ((ValueInt and mask) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                         try
                           try
                            ValueInt := StrToInt(Reg.ReadString(Val));
                          except
                            on Exception : EConvertError do
                            ValueInt := 893;
                          end;

                           ValueInt := ValueInt xor Mask;
                           Reg.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
              atCancel:
                         try
                          try
                            ValueInt := StrToInt(Reg.ReadString(Val));
                          except
                            on Exception : EConvertError do
                            ValueInt := 893;
                          end;

                           ValueInt := ValueInt or Mask;
                           Reg.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
              end;

           Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
           try
            Reg32.RootKey:=HKEY_LOCAL_MACHINE;
            // SID пользователя
            // Wow6432Node
            Reg32.OpenKey('SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\'+GetCurrentUserSid, true);
            Val := 'FeatureStates';
            mask := 1; // проверяем первый бит
            case Action of                          // 1 - Disable WiFi sense
              atRefresh: try

                           try
                             ValueInt := StrToInt(Reg32.ReadString(Val));
                           except
                             on Exception : EConvertError do
                             ValueInt := 893;
                           end;

                           if ((ValueInt and mask) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                         try
                           try
                            ValueInt := StrToInt(Reg32.ReadString(Val));
                          except
                            on Exception : EConvertError do
                            ValueInt := 893;
                          end;

                           ValueInt := ValueInt xor Mask;
                           Reg32.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
              atCancel:
                         try
                          try
                            ValueInt := StrToInt(Reg32.ReadString(Val));
                          except
                            on Exception : EConvertError do
                            ValueInt := 893;
                          end;

                           ValueInt := ValueInt or Mask;
                           Reg32.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
              end;
            finally
              Reg32.Free;
            end;
        end;

    107: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            // SID пользователя
            // Wow6432Node
            Reg.OpenKey('SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\'+GetCurrentUserSid, true);
            Val := 'FeatureStates';
            mask := 64; // 1 shl 6;  проверяем седьмой бит
            case Action of                                // 64 - Disable Wifi sense of my contact 7
              atRefresh: try
                           try
                             ValueInt := StrToInt(Reg.ReadString(Val));
                           except
                             on Exception : EConvertError do
                             ValueInt := 893;
                           end;

                           if ((ValueInt and mask) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                         try
                            try
                              ValueInt := StrToInt(Reg.ReadString(Val));
                            except
                              on Exception : EConvertError do
                              ValueInt := 893;
                            end;

                           ValueInt := ValueInt xor Mask;
                           Reg.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
              atCancel:
                         try
                            try
                              ValueInt := StrToInt(Reg.ReadString(Val));
                            except
                              on Exception : EConvertError do
                              ValueInt := 893;
                            end;

                           ValueInt := ValueInt or Mask;
                           Reg.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
            end;


           Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
           try
           Reg32.RootKey:=HKEY_LOCAL_MACHINE;
            // SID пользователя
            // Wow6432Node
            Reg32.OpenKey('SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\'+GetCurrentUserSid, true);
            Val := 'FeatureStates';
            mask := 64; // 1 shl 6;  проверяем седьмой бит
            case Action of                                // 64 - Disable Wifi sense of my contact 7
              atRefresh: try
                           try
                             ValueInt := StrToInt(Reg32.ReadString(Val));
                           except
                             on Exception : EConvertError do
                             ValueInt := 893;
                           end;

                           if ((ValueInt and mask) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                         try
                            try
                              ValueInt := StrToInt(Reg32.ReadString(Val));
                            except
                              on Exception : EConvertError do
                              ValueInt := 893;
                            end;

                           ValueInt := ValueInt xor Mask;
                           Reg32.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
              atCancel:
                         try
                            try
                              ValueInt := StrToInt(Reg32.ReadString(Val));
                            except
                              on Exception : EConvertError do
                              ValueInt := 893;
                            end;

                           ValueInt := ValueInt or Mask;
                           Reg32.WriteString(Val,IntToStr(ValueInt));
                         except
                           on ERegistryException do
                         end;
            end;
           finally
             Reg32.Free;
           end;


          end;
    108: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    109: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    110: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\WMDRM', true);
            Val := 'DisableOnline';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    111: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows Defender', true);
            Val := 'DisableAntiSpyware';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;

    201: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;

    202: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\TabletPC', true);
            Val := 'PreventHandwritingDataSharing';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    203: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports', true);
            Val := 'PreventHandwritingErrorReports';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    204: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\AppCompat', true);
            Val := 'DisableInventory';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    205: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Personalization\Settings', true);
            Val := 'AcceptedPrivacyPolicy';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    206: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language', true);
            Val := 'Enabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

          end;
    207: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\InputPersonalization', true);
            Val := 'RestrictImplicitInkCollection';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    208: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\InputPersonalization', true);
            Val := 'RestrictImplicitTextCollection';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    209: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore', true);
            Val := 'HarvestContacts';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

          end;
    210: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\Personalization', true);
            Val := 'NoLockScreenCamera';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    211: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\Windows Search', true);
            Val := 'AllowCortana';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    212: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Input\TIPC', true);
            Val := 'Enabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    213: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo', true);
            Val := 'Enabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;
          end;
    214: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            // Wow6432Node
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo', true);
            Val := 'Enabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo', true);
              Val := 'Enabled';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Result := Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;

          end;
    215: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications', true);
            Val := 'ToastEnabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    216: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    217: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    218: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFFA794E4-F964-4FDB-90F6-51056BFE4B44}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    219: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissons\{BFFA794E4-F964-4FDB-90F6-51056BFE4B44}', true);
            Val := 'SensorPermissionState';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    220: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    221: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;

          end;
    222: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Biometrics', true);
            Val := 'Enabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    223: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('Control Panel\International\User Profile', true);
            Val := 'HttpAcceptLanguageOptOut';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    224: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost', true);
            Val := 'EnableWebContentEvaluation';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    225: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\SQMClient\Windows', true);
            Val := 'CEIPEnable';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

          end;
    226: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger', true);
            Val := 'Start';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

          end;
    227: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            // Wow6432Node
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo', true);
            Val := 'Id';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val)='') then result:=true;
                         except
                           on ERegistryException do
                           result:=false;
                         end;
              atApply:
                Reg.DeleteValue(Val);
{              atCancel:
                Result := Reg.DeleteValue(Val);}
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo', true);
              Val := 'Id';
              case Action of
                atRefresh: try
                             if (Reg32.ReadString(Val)='') then result:=true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.DeleteValue(Val);
                {atCancel:
                  Result := Reg32.DeleteValue(Val);}
              end;
            finally
              Reg32.Free;
            end;

          end;

    301: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors', true);
            Val := 'DisableLocation';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    302: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors', true);
            Val := 'DisableWindowsLocationProvider';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    303: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors', true);
            Val := 'DisableLocationScripting';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    304: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors', true);
            Val := 'DisableSensors';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;

    401: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\DataCollection', true);
            Val := 'AllowTelemetry';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;
            {
              Для Pro версии нельзя отключить полностью телеметрию, работает только в значении 1 (отправка базовых данных):
            }
          end;
    402: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection', true);
            Val := 'AllowTelemetry';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection', true);
              Val := 'AllowTelemetry';
              case Action of
                atRefresh: try
                             if result and (Reg32.ReadInteger(Val) = 0) then
                               result := true
                             else
                               result := false;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.WriteInteger(Val,1);
              end;
            finally
              Reg32.Free;
            end;

          end;
    403: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\AppCompat', true);
            Val := 'AITEnable';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;

    501: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization', true);
            Val := 'SystemSettingsDownloadMode';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0); // 0 или 3
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_CURRENT_USER;
              // Wow6432Node
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization', true);
              Val := 'SystemSettingsDownloadMode';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;

          end;
    502: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config', true);
            Val := 'DODownloadMode';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);    // 0 !!! Отключает
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              // Wow6432Node
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config', true);
              Val := 'DODownloadMode';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;
          end;
    503: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization', true);
            Val := 'DODownloadMode';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    504: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate', true);
            Val := 'DeferUpgrade';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    505: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\DriverSearching', true);
            Val := 'DontSearchWindowsUpdate';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    506: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU', true);
            Val := 'NoAutoUpdate';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    507: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('System\CurrentControlSet\Services\wuauserv', true);
            Val := 'Start';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 4) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,4);
              atCancel:
                Reg.WriteInteger(Val,3);
            end;

          end;
    508: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
                          // Wow6432Node
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d', true);
            Val := 'RegisteredWithAU';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d', true);
              Val := 'RegisteredWithAU';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.WriteInteger(Val,1);
              end;
            finally
              Reg32.Free;
            end;

          end;
    509: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\MRT', true);
            Val := 'DontOfferThroughWUAU';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.WriteInteger(Val,0);
            end;
          end;
    510: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\WindowsUpdate\UX\Settings', true);
            Val := 'DeferUpgrade';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.WriteInteger(Val,0);
            end;

          end;
    601:  begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Siuf\Rules', true);
            Val := 'NumberOfSIUFInPeriod';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;
    602: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Siuf\Rules', true);
            Val := 'PeriodInNanoSeconds';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := false;
                         except
                           on ERegistryException do
                           result:=true;
                         end;
              atApply:
                Result := Reg.DeleteValue(Val);
              atCancel:
                Reg.WriteInteger(Val,0);
            end;

          end;
    603: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Search', true);
            Val := 'BingSearchEnabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Result := Reg.DeleteValue(Val);
            end;

          end;

    604:  begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\OneDrive', true);
            Val := 'DisableFileSyncNGSC';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.DeleteValue(Val);
            end;

          end;
    605: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main', true);
            Val := 'DoNotTrack';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.WriteInteger(Val,0);
            end;
          end;
    606: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\Windows Search', true);
            Val := 'DisableWebSearch';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Policies\Microsoft\Windows\Windows Search', true);
              Val := 'DisableWebSearch';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 1) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,1);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;
          end;
    607: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}', true);
            Val := 'Value';
            case Action of
              atRefresh: try
                           if (Reg.ReadString(Val) = 'Deny') then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteString(Val,'Deny');
              atCancel:
                Reg.WriteString(Val,'Allow');
            end;
          end;


        // HKLM\System\CurrentControlSet\Control\Storage\EnabledDenyGP\DenyAllGPState
      608: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('System\CurrentControlSet\Control\Storage\EnabledDenyGP', true);
            Val := 'DenyAllGPState';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.WriteInteger(Val,0);
            end;
          end;
     609: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Search', true);
            Val := 'CortanaEnabled';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;
          end;
     610: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('Software\Policies\Microsoft\Windows\Windows Search', true);
            Val := 'ConnectedSearchUseWeb';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('Software\Policies\Microsoft\Windows\Windows Search', true);
              Val := 'ConnectedSearchUseWeb';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;

          end;
     611: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('Software\Policies\Microsoft\Windows\Windows Search', true);
            Val := 'ConnectedSearchUseWebOverMeteredConnections';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.DeleteValue(Val);
            end;


            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('Software\Policies\Microsoft\Windows\Windows Search', true);
              Val := 'ConnectedSearchUseWebOverMeteredConnections';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;

          end;
     612: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\Device Metadata', true);
            Val := 'PreventDeviceMetadataFromNetwork';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Policies\Microsoft\Windows\Device Metadata', true);
              Val := 'PreventDeviceMetadataFromNetwork';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 1) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,1);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;


          end;

     613: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\WindowsStore\WindowsUpdate', true);
            Val := 'AutoDownload';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 2) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,2);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Policies\Microsoft\WindowsStore\WindowsUpdate', true);
              Val := 'AutoDownload';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 2) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,2);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;
          end;
     614: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform', true);
            Val := 'NoGenTicket';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 1) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,1);
              atCancel:
                Reg.WriteInteger(Val,0);
            end;
          end;
     615: begin
            {Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching', true);
            Val := 'SearchOrderConfig';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;}

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching', true);
              Val := 'SearchOrderConfig';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.WriteInteger(Val,1);
              end;
            finally
              Reg32.Free;
            end;
          end;
     616: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate\', true);
            Val := 'AutoDownload';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 2) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,2);
              atCancel:
                Reg.WriteInteger(Val,4);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate', true);
              Val := 'AutoDownload';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 2) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,2);
                atCancel:
                  Reg32.WriteInteger(Val,4);
              end;
            finally
              Reg32.Free;
            end;
          end;
     617: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config', true);
            Val := 'DODownloadMode';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,3);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config', true);
              Val := 'DODownloadMode';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.WriteInteger(Val,3);
              end;
            finally
              Reg32.Free;
            end;
          end;
     618: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config', true);
            Val := 'AutoConnectAllowedOEM';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config', true);
              Val := 'AutoConnectAllowedOEM';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.WriteInteger(Val,1);
              end;
            finally
              Reg32.Free;
            end;
          end;
     619: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana', true);
            Val := 'value';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana', true);
              Val := 'value';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;
          end;

     620: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots', true);
            Val := 'value';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots', true);
              Val := 'value';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;
          end;
     621: begin
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting', true);
            Val := 'value';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.DeleteValue(Val);
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting', true);
              Val := 'value';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.DeleteValue(Val);
              end;
            finally
              Reg32.Free;
            end;
          end;
     622: begin
            Reg.RootKey:=HKEY_CURRENT_USER;
            Reg.OpenKey('Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder', true);
            Val := 'Attributes';
            Mask := 1 shl 20; //21 бит
            case Action of
              atRefresh: try
                           try
                             ValueInt := Reg.ReadInteger(Val);
                           except
                             on ERegistryException do
                             ValueInt := 4034920525;
                           end;

                           if ((ValueInt and mask) <> 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                         try
                           try
                            ValueInt := Reg.ReadInteger(Val);
                          except
                             on ERegistryException do
                            ValueInt := 4034920525;
                          end;

                           ValueInt := ValueInt or Mask;
                           Reg.WriteInteger(Val,ValueInt);
                         except
                           on ERegistryException do
                         end;
              atCancel:
                         try
                          try
                            ValueInt := Reg.ReadInteger(Val);
                          except
                             on ERegistryException do
                            ValueInt := 4034920525;
                          end;

                           ValueInt := ValueInt xor Mask;
                           Reg.WriteInteger(Val,ValueInt);
                         except
                           on ERegistryException do
                         end;
            end;

            Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_CURRENT_USER;
              Reg32.OpenKey('Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder', true);
              Val := 'Attributes';
               Mask := 1 shl 20; //21 бит
              case Action of
                atRefresh: try
                           try
                             ValueInt := Reg32.ReadInteger(Val);
                           except
                             on ERegistryException do
                             ValueInt := 4034920525;
                           end;

                           if ((ValueInt and mask) <> 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                         try
                           try
                            ValueInt := Reg32.ReadInteger(Val);
                          except
                             on ERegistryException do
                            ValueInt := 4034920525;
                          end;

                           ValueInt := ValueInt or Mask;
                           Reg32.WriteInteger(Val,ValueInt);
                         except
                           on ERegistryException do
                         end;
              atCancel:
                         try
                          try
                            ValueInt := Reg32.ReadInteger(Val);
                          except
                             on ERegistryException do
                            ValueInt := 4034920525;
                          end;

                           ValueInt := ValueInt xor Mask;
                           Reg32.WriteInteger(Val,ValueInt);
                         except
                           on ERegistryException do
                         end;
              end;
            finally
              Reg32.Free;
            end;
          end;
     623: begin
            case Action of
              atRefresh:
                result := not GetTasksIsEnabled;
              atApply:
                SetTasksStatus(False);
              atCancel:
                SetTasksStatus(True); // По умолчанию включено
            end;
          end;
     624: begin
            try
              case Action of
                atRefresh:
                  result := HostIsBlockNormal;
                atApply:
                  SetHostBlockNormal;
                atCancel:
                  SetHostNotBlockNormal;
              end;
            except
              on EFCreateError do
                MessageDlg(ApplicationName, 'Не удалось записать правила в hosts', mtError, [mbOK],'');
            end;
          end;

     625: begin
            try
            case Action of
              atRefresh:
                result := HostIsBlockExtra;
              atApply:
                SetHostBlockExtra;
              atCancel:
                SetHostNotBlockExtra;
            end;
                        except
              on EFCreateError do
                MessageDlg(ApplicationName, 'Не удалось записать правила в hosts', mtError, [mbOK],'');
            end;
          end;
     626: begin // Все домены
            try
            case Action of
              atRefresh:
                result := HostIsBlockSuperExtra;
              atApply:
                SetHostBlockSuperExtra;
              atCancel:
                SetHostNotBlockSuperExtra;
            end;
                        except
              on EFCreateError do
                MessageDlg(ApplicationName, 'Не удалось записать правила в hosts', mtError, [mbOK],'');
            end;
          end;
    { 627: begin
            ChangeKeyAttribute('SOFTWARE\Microsoft\Windows Defender\SpyNet');
            Reg.RootKey:=HKEY_LOCAL_MACHINE;
            Reg.OpenKey('SOFTWARE\Microsoft\Windows Defender\SpyNet', true);
            Val := 'SubmitSamplesConsent';
            case Action of
              atRefresh: try
                           if (Reg.ReadInteger(Val) = 0) then result := true;
                         except
                           on ERegistryException do
                             result:=false;
                         end;
              atApply:
                Reg.WriteInteger(Val,0);
              atCancel:
                Reg.WriteInteger(Val,1);
            end;

           { Reg32:=TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_32KEY);
            try
              Reg32.RootKey:=HKEY_LOCAL_MACHINE;
              Reg32.OpenKey('SOFTWARE\Microsoft\Windows Defender\SpyNet', true);
              Val := 'SubmitSamplesConsent';
              case Action of
                atRefresh: try
                             if (Reg32.ReadInteger(Val) = 0) then result := true;
                           except
                             on ERegistryException do
                               result:=false;
                           end;
                atApply:
                  Reg32.WriteInteger(Val,0);
                atCancel:
                  Reg32.WriteInteger(Val,1);
              end;
            finally
              Reg32.Free;
            end;
          end; }

    end;
  finally
    Reg.Free;
  end;
end;

end.
