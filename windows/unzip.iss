;/**
;*  
;*  Pvtbox. Fast and secure file transfer & sync directly across your devices. 
;*  Copyright © 2020  Pb Private Cloud Solutions Ltd. 
;*  
;*  This program is free software: you can redistribute it and/or modify
;*  it under the terms of the GNU General Public License as published by
;*  the Free Software Foundation, either version 3 of the License, or
;*  (at your option) any later version.
;*  
;*  This program is distributed in the hope that it will be useful,
;*  but WITHOUT ANY WARRANTY; without even the implied warranty of
;*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;*  GNU General Public License for more details.
;*  
;*  You should have received a copy of the GNU General Public License
;*  along with this program.  If not, see <https://www.gnu.org/licenses/>.
;*  
;**/
[Code]
#ifdef UNICODE
  #define AW "W"
#else
  #define AW "A"
#endif

const
  WAIT_OBJECT_0 = $0;
  WAIT_TIMEOUT = $00000102;
  SEE_MASK_NOCLOSEPROCESS = $00000040;
  INFINITE = $FFFFFFFF;     { Infinite timeout }

type
  TShellExecuteInfo = record
    cbSize: DWORD;
    fMask: Cardinal;
    Wnd: HWND;
    lpVerb: string;
    lpFile: string;
    lpParameters: string;
    lpDirectory: string;
    nShow: Integer;
    hInstApp: THandle;
    lpIDList: DWORD;
    lpClass: string;
    hkeyClass: THandle;
    dwHotKey: DWORD;
    hMonitor: THandle;
    hProcess: THandle;
  end;

function ShellExecuteEx(var lpExecInfo: TShellExecuteInfo): BOOL; 
  external 'ShellExecuteEx{#AW}@shell32.dll stdcall';
function WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD): DWORD; 
  external 'WaitForSingleObject@kernel32.dll stdcall';
function CloseHandle(hObject: THandle): BOOL; external 'CloseHandle@kernel32.dll stdcall';

//-----------------------
//"Generic" code, some old "Application.ProcessMessages"-ish procedure
//-----------------------
type
  TMsg = record
    hwnd: HWND;
    message: UINT;
    wParam: Longint;
    lParam: Longint;
    time: DWORD;
    pt: TPoint;
  end;

const
  PM_REMOVE      = 1;

function PeekMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; external 'PeekMessageA@user32.dll stdcall';
function TranslateMessage(const lpMsg: TMsg): BOOL; external 'TranslateMessage@user32.dll stdcall';
function DispatchMessage(const lpMsg: TMsg): Longint; external 'DispatchMessageA@user32.dll stdcall';

procedure AppProcessMessage;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, WizardForm.Handle, 0, 0, PM_REMOVE) do begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;
//-----------------------
//-----------------------


procedure Unzip(source: String; targetdir: String);
var
  unzipTool, unzipParams : String;     // path to unzip util
  ReturnCode  : Integer;  // errorcode
  ExecInfo: TShellExecuteInfo;
begin
    // source might contain {tmp} or {app} constant, so expand/resolve it to path name
    source := ExpandConstant(source);

    unzipTool := ExpandConstant('{tmp}\7za.exe');
    unzipParams := ' x "' + source + '" -o"' + targetdir + '" -y';

    ExecInfo.cbSize := SizeOf(ExecInfo);
    ExecInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
    ExecInfo.Wnd := 0;
    ExecInfo.lpFile := unzipTool;
    ExecInfo.lpParameters := unzipParams;
    ExecInfo.nShow := SW_HIDE;

    if not FileExists(unzipTool)
    then MsgBox('UnzipTool not found: ' + unzipTool, mbError, MB_OK)
    else if not FileExists(source)
    then MsgBox('File was not found while trying to unzip: ' + source, mbError, MB_OK)
    else begin 

          // ShellExecuteEx combined with INFINITE WaitForSingleObject   

          if ShellExecuteEx(ExecInfo) then
          begin
            while WaitForSingleObject(ExecInfo.hProcess, 20) = WAIT_TIMEOUT { WAIT_OBJECT_0 }
            do begin
                AppProcessMessage();
                //InstallPage.Surface.Update;          
                //BringToFrontAndRestore;
                WizardForm.Refresh();
            end;
          CloseHandle(ExecInfo.hProcess);
          end; 

    end;
end;


function CheckList(checklist_filename: String; dest: String): boolean;
var
    names: TArrayOfString;
    name: String;
    i: Integer;
begin
    Result := LoadStringsFromFile(checklist_filename, names);
    if Result <> True then
    begin
        Log('Cannot load check list from file: ' + checklist_filename);
        exit;
    end;

    for i := 0 to GetArrayLength(names)-1 do
    begin
        if Length(names[i]) > 0 then
        begin
            name := dest + '\' + names[i];
            Result := FileExists(name);
            if Result <> True then
            begin
                Log('File does not exist: ' + name);
                exit;
            end;
            //Log('File exists: ' + name);
        end;
    end;

    Result := True;
end;
