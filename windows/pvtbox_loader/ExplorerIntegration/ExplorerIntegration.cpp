/**
*  
*  Pvtbox. Fast and secure file transfer & sync directly across your devices. 
*  Copyright © 2020  Pb Private Cloud Solutions Ltd. 
*  
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*  
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*  
**/
// ExplorerIntegration.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "ExplorerIntegration.h"
#include <string>
#include <iostream>

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
    _In_opt_ HINSTANCE hPrevInstance,
    _In_ LPWSTR    lpCmdLine,
    _In_ int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    std::wstring regsvr = L"Regsvr32.exe";

    std::wstring regsvr_params = regsvr + L" /s /i \"";
    regsvr_params += lpCmdLine;
    regsvr_params += L"\\pvtbox-overlays.dll\"";

    HINSTANCE hres = ShellExecuteW(NULL, NULL, regsvr.c_str(), regsvr_params.c_str(), lpCmdLine, SW_HIDE);
    if ((int)hres <= 32) {
        std::cerr << "Error registering overlays " << (int)hres << std::endl;
    }

    return 0;
}
