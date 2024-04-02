package;

import unrar.RARUtil;
import unrar.UnRAR;

using StringTools;

class Test {
	public static function main() {
		trace("RAR Test: " + RARUtil.isRAR("test.rar"));
		UnRAR.openArchive({
			openPath: "test.rar",
			mode: EXTRACT,
			onFile: (file, flags) -> {
				Sys.println(file);
				return file;
			},
			onError: (code, type) -> {
				trace(code, type);
			},
			onFlags: (flags) -> {
				trace(flags);
			},
			onComment: (cmt) -> {
				trace(cmt);
			}
		});
		trace("Finished");
	}
}
