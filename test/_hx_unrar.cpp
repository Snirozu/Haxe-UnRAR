
// THIS IS UNUSED
//@:include("./cpp/hx_unrar.cpp")

#pragma once

#include <ctype.h>
#include <locale.h>
#include <stdio.h>
#include <windows.h>
#include <iostream>
#include <functional>
#include <string>

#include "../lib/unrar.h"

// things from abstracts.hx
enum Mode { EXTRACT, LIST, TEST };
enum ErrorType { ERR_OPEN, ERR_READ, ERR_PROCESS };

struct RAROptions {
	std::string openPath;
	int mode;
	std::string destPath;
	std::string password;
	std::function<void(int, int)> onError;
	std::function<void(int)> onFlags;
	std::function<void(::String)> onComment;
	std::function<::String(::String)> onFile;
};

bool checkError(int code, int type, RAROptions options) {
	if (code == ERAR_SUCCESS || code == ERAR_END_ARCHIVE)
		return false;
	
	if (options.onError)
		options.onError(code, type);
	return true;
}

void openArchive(RAROptions options) {
    char *ArcName = (char *) options.openPath.c_str();
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

	OpenArchiveData.OpenMode = (options.mode == EXTRACT || options.mode == TEST) ? RAR_OM_EXTRACT : RAR_OM_LIST;

	hArcData = RAROpenArchiveEx(&OpenArchiveData);
	if (options.password != "") {
		RARSetPassword(hArcData, (char *) options.password.c_str());
	}

	if (checkError(OpenArchiveData.OpenResult, ERR_OPEN, options)) {
		return;
	}

	if (options.onFlags)
		options.onFlags(OpenArchiveData.Flags);

	if (options.onComment && OpenArchiveData.CmtState == 1)
		options.onComment(CmtBuf);

	char *destPath = options.destPath == "" ? NULL : (char *) options.destPath.c_str();
	char *destName = NULL;

	while ((RHCode = RARReadHeader(hArcData, &HeaderData)) == 0) {
		if (options.onFile) {
			destName = (char *) options.onFile(HeaderData.FileName).c_str();
			destName = destName == "" ? NULL : destName;
		}

		PFCode = RARProcessFile(hArcData, options.mode == EXTRACT ? RAR_EXTRACT : RAR_TEST, destPath, destName);

		if (checkError(PFCode, ERR_PROCESS, options)) {
			break;
		}
	}
	checkError(RHCode, ERR_READ, options);

	RARCloseArchive(hArcData);
}