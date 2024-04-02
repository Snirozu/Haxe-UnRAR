package unrar;

import haxe.io.Bytes;
import sys.io.File;

class RARUtil {
    /**
     * Checks if `file` is a RAR archive.
     * @param file Path to that archive
     */
    public static function isRAR(file:String) {
        var file = File.read(file, true);
        var bytes = Bytes.alloc(4);
		file.readBytes(bytes, 0, 4);
		file.close();
		return bytes.toString() == "Rar!";
    }
}