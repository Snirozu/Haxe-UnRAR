package unrar;

#if !(cpp && windows)
#error "UnRAR only supports C++ Windows targets!"
#end

@:buildXml('<include name="${haxelib:unrar}/Build.xml" />')
@:cppFileCode('
#include <ctype.h>
#include <locale.h>
#include <stdio.h>
#include <windows.h>
#include <iostream>
#include <functional>
#include <string>

#include "../lib/unrar.h"

enum Mode { EXTRACT, LIST, TEST };
enum ErrorType { ERR_OPEN, ERR_READ, ERR_PROCESS };

bool checkError(int code, int type, ::Dynamic onError) {
	if (code == ERAR_SUCCESS || code == ERAR_END_ARCHIVE)
		return false;
	
	if (onError != NULL)
		onError(code, type);
	return true;
}

bool checkEmpty(::String str) {
	if (!str)
		return true;

	return str.c_str()[0] == \'\\0\';
}
')
class UnRARLib {
	@:functionCode('
		char *ArcName = (char *) openPath.c_str();

		HANDLE hArcData;
		int RHCode,PFCode;
		wchar_t CmtBuf[16384];
		struct RARHeaderData HeaderData;
		struct RAROpenArchiveDataEx OpenArchiveData;

		memset(&HeaderData, 0, sizeof(HeaderData));
		memset(&OpenArchiveData, 0, sizeof(OpenArchiveData));

		OpenArchiveData.ArcName = ArcName;
		OpenArchiveData.CmtBufW = CmtBuf;
		OpenArchiveData.CmtBufSize = sizeof(CmtBuf) / sizeof(CmtBuf[0]);

		OpenArchiveData.OpenMode = (mode == EXTRACT || mode == TEST) ? RAR_OM_EXTRACT : RAR_OM_LIST;

		hArcData = RAROpenArchiveEx(&OpenArchiveData);

		if (!checkEmpty(password)) {
			char *Password = (char *) password.c_str();
			if (Password[0] != \'\\0\') {
				RARSetPassword(hArcData, Password);
			}
		}

		if (checkError(OpenArchiveData.OpenResult, ERR_OPEN, onError)) {
			return;
		}

		if (onFlags != NULL)
			onFlags(OpenArchiveData.Flags);

		if (onComment != NULL && OpenArchiveData.CmtState == 1)
			onComment(String(CmtBuf));

		char *destFile = NULL;
		if (!checkEmpty(destPath)) {
			char *DestPath = (char *) destPath.c_str();
			if (DestPath[0] != \'\\0\') {
				destFile = DestPath;
			}
		}
		char *destName = NULL;
        bool skip = false;
        
		while ((RHCode = RARReadHeader(hArcData, &HeaderData)) == 0) {
			if (onFile != NULL) {
				destName = NULL;
                skip = false;

				::Dynamic callback = onFile(String(HeaderData.FileName), HeaderData.Flags);
				if (!checkEmpty(callback)) {
					destName = (char *) String(callback).c_str();
				}
                else {
                    skip = true;
                }
			}
            
			PFCode = RARProcessFile(hArcData, skip ? RAR_SKIP : mode == EXTRACT ? RAR_EXTRACT : RAR_TEST, destFile, destName);

			if (checkError(PFCode, ERR_PROCESS, onError)) {
				break;
			}
		}
		checkError(RHCode, ERR_READ, onError);

		RARCloseArchive(hArcData);
	')
	public static function openArchive(
		openPath:String,
		mode:Int,
		?destPath:String,
		?password:String,
		?onError:Dynamic = 0,
		?onFlags:Dynamic = 0,
		?onComment:Dynamic = 0,
		?onFile:Dynamic = 0
	) {}
}