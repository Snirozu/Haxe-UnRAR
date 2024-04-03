import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.zip.Entry;
import haxe.io.Path;
import sys.io.File;
import haxe.zip.Writer;
import sys.FileSystem;

// haxe --main package.hx --interp

class Package {
    static final exclude = [
        ".git",
        ".gitignore",
        "test.bat",
        "completion.hxml",
        "test",
        "Package.hx",
		"lib_package.zip"
    ];

    public static function main() {
        trace("Zipping files...");
        var file = File.write("lib_package.zip", true);
		var writer = new Writer(file);
		writer.write(getEntries("./"));
        file.close();
        trace("Done");

		Sys.println("Submit to Haxelib? [Y/N]:");
		var input = Sys.stdin().readLine().toLowerCase();
        if (input == "y") {
			trace("Submiting...");
			Sys.command("haxelib", ["submit", "lib_package.zip"]);
        }
    }

	static function getEntries(dir:String, entries:List<haxe.zip.Entry> = null, inDir:Null<String> = null) {
		if (entries == null)
			entries = new List<haxe.zip.Entry>();
		if (inDir == null)
			inDir = dir;
		for (file in FileSystem.readDirectory(dir)) {
			var path = Path.join([dir, file]);

            if (exclude.contains(path))
                continue;

			if (sys.FileSystem.isDirectory(path)) {
				getEntries(path, entries, inDir);
			}
            else {
				var bytes:Bytes = haxe.io.Bytes.ofData(sys.io.File.getBytes(path).getData());
				var entry:Entry = {
					fileName: StringTools.replace(path, inDir, ""),
					fileSize: bytes.length,
					fileTime: Date.now(),
					compressed: false,
					dataSize: FileSystem.stat(path).size,
					data: bytes,
					crc32: Crc32.make(bytes)
				};
				entries.push(entry);
			}
		}
		return entries;
	}
}