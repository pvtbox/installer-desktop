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
//*******************************************************************************
//** Code Section with Pascal helpers.
//*******************************************************************************


//Check on exist windows update.
function IsKBInstalled(KB: string): Boolean;
var
  WbemLocator: Variant;
  WbemServices: Variant;
  WQLQuery: string;
  WbemObjectSet: Variant;
begin
  WbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  WbemServices := WbemLocator.ConnectServer('', 'root\CIMV2');

  WQLQuery := 'select * from Win32_QuickFixEngineering where HotFixID = ''' + KB + '''';

  WbemObjectSet := WbemServices.ExecQuery(WQLQuery);
  Result := (not VarIsNull(WbemObjectSet)) and (WbemObjectSet.Count > 0);
end;


//Check to need update system.
function NeedUpdate(Major: Integer; Minor: Integer; Build: Integer; is64: Boolean): Boolean;
var
  Version: TWindowsVersion;
begin
  GetWindowsVersionEx(Version);

  if (Version.Major = Major) and
     (Version.Minor = Minor) and
     (Version.Build = Build) and
     (Is64BitInstallMode = is64) then
  begin
    if not IsKBInstalled('KB2999226') then
    begin
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;
