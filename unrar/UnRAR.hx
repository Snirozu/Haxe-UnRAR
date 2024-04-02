package unrar;

import haxe.io.Path;
import unrar.Abstracts;

class UnRAR {
	/**
	 * Open a RAR archive using `options`
	 * @param options Properties for reading that RAR file; `RAROptions.openPath` and `RAROptions.mode` are required.
	 */
	public static function openArchive(options:RAROptions) {
		var onFlagsCatch:Dynamic = options.onFlags == null ? null : (flags) -> {
			options.onFlags({
				volume: flags & 1 == 1,
				comment: flags & 2 == 2,
				locked: flags & 4 == 4,
				solid: flags & 8 == 8,
				newNaming: flags & 16 == 16,
				recovery: flags & 64 == 64,
				encryptedHeaders: flags & 128 == 128,
				firstVolume: flags & 256 == 256,
			});
		};

		var onFileCatch:Dynamic = options.onFile == null ? null : (file, flags) -> {
			var coolFlags:RARFileFlags = {
				continuedPrev: flags & 1 == 1,
				continuedNext: flags & 2 == 2,
				password: flags & 4 == 4,
				solid: flags & 16 == 16,
				isDirectory: flags & 32 == 32
			};
			file = Path.normalize(file) + (coolFlags.isDirectory ? "/" : "");
			options.onFile(file, coolFlags);
		};

		UnRARLib.openArchive(
			options.openPath,
			options.mode,
			options.destPath,
			options.password,
			options.onError,
			onFlagsCatch,
			options.onComment,
			onFileCatch
		);
	}
}

typedef RAROptions = {
	/**
	 * The path of the RAR file.
	 */
	public var openPath:String;

	/**
	 * The mode that is used for reading that archive.
	 */
	public var mode:Mode;

	/**
	 * Directory in where the archive files will be extracted.
	 * 
	 * This is ignored when `destFile` is set.
	 */
	@:optional public var destPath:String;

	/**
	 * Password to decrypt files.
	 */
	@:optional public var password:String;

	/**
	 * Called when an error gets caught.
	 */
	@:optional public var onError:(ErrorCode, ErrorType)->Void;

	/**
	 * Returns flags when they are available.
	 */
	@:optional public var onFlags:RARFlags->Void;

	/**
	 * Returns the comment for that RAR file.
	 */
	@:optional public var onComment:String->Void;

	/**
	 * Called before a file gets processed.
	 * 
	 * @return If successful, this will be the path where that file will be extracted. Return `null` to skip that file.
	 */
	@:optional public var onFile:(String, RARFileFlags)->String;
}

typedef RARFlags = {
	/**
	 * Is this archive multi-parted?
	 */
	public var volume:Bool;

	/**
	 * Does this archive have a comment?
	 */
	public var comment:Bool;

	/**
	 * Is this archive locked?
	 */
	public var locked:Bool;

	/**
	 * Is compression of previous files used? (Solid compression)
	 */
	public var solid:Bool;

	/**
	 * New volume naming scheme.
	 */
	public var newNaming:Bool;

	/**
	 * Does this archive have a recovery record?
	 */
	public var recovery:Bool;

	/**
	 * Are the headers encrypted?
	 */
	public var encryptedHeaders:Bool;

	/**
	 * Is this archive the first volume?
	 */
	public var firstVolume:Bool;
}

typedef RARFileFlags = {
	/**
	 * Is file continued from previous volume?
	 */
	public var continuedPrev:Bool;

	/**
	 * Is file continued on next volume?
	 */
	public var continuedNext:Bool;

	/**
	 * Is file encrypted with password?
	 */
	public var password:Bool;

	/**
	 * Is compression of previous files used? (Solid compression)
	 */
	public var solid:Bool;

	/**
	 * Is file a directory?
	 */
	public var isDirectory:Bool;
}