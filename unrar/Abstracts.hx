package unrar;

class Abstracts {}

enum abstract Mode(Int) from Int to Int {
	/**
	 * This mode extracts files from the archive to `destPath`
	 */
	var EXTRACT;

	/**
	 * This mode lists all files by only reading their headers.
	 */
	var LIST;

	/**
	 * This mode tests files for valid data.
	 */
	var TEST;
}

enum abstract ErrorCode(Int) from Int to Int {
	/**
	 * Not enough memory to initialize data structures.
	 */
	var ERAR_NO_MEMORY = 11;

	/**
	 * Archive header or data is invalid.
	 */
	var ERAR_BAD_DATA = 12;

	/**
	 * File is not a valid RAR archive.
	 */
	var ERAR_BAD_ARCHIVE = 13;

	/**
	 * Unknown archive format.
	 */
	var ERAR_UNKNOWN_FORMAT = 14;

	/**
	 * File open error.
	 */
	var ERAR_EOPEN = 15;

	/**
	 * File create error.
	 */
	var ERAR_ECREATE = 16;

	/**
	 * File close error
	 */
	var ERAR_ECLOSE = 17;

	/**
	 * Read error.
	 */
	var ERAR_EREAD = 18;

	/**
	 * Write error.
	 */
	var ERAR_EWRITE = 19;

	/**
	 * Buffer for archive comment is too small, comment truncated.
	 */
	var ERAR_SMALL_BUF = 20;

	/**
	 * Unknown error.
	 */
	var ERAR_UNKNOWN = 21;

	/**
	 * Password for encrypted file or header was not specified.
	 */
	var ERAR_MISSING_PASSWORD = 22;

	/**
	 * Cannot open file source for reference record.
	 */
	var ERAR_EREFERENCE = 23;

	/**
	 * Wrong password was specified.
	 */
	var ERAR_BAD_PASSWORD = 24;

	/**
	 * File dictionary sizes exceeds the limit.
	 */
	var ERAR_LARGE_DICT = 25;

	public function toString():String {
		switch (this) {
			case ERAR_NO_MEMORY:
				return "Not enough memory to initialize data structures";
			case ERAR_BAD_DATA:
				return "Archive header or data is invalid";
			case ERAR_BAD_ARCHIVE:
				return "File is not a valid RAR archive";
			case ERAR_UNKNOWN_FORMAT:
				return "Unknown archive format";
			case ERAR_EOPEN:
				return "File open error";
			case ERAR_ECREATE:
				return "File create error";
			case ERAR_ECLOSE:
				return "File close error";
			case ERAR_EREAD:
				return "Read error";
			case ERAR_EWRITE:
				return "Write error";
			case ERAR_SMALL_BUF:
				return "Buffer for archive comment is too small, comment truncated";
			case ERAR_UNKNOWN:
				return "Unknown error";
			case ERAR_MISSING_PASSWORD:
				return "Password for encrypted file or header was not specified";
			case ERAR_EREFERENCE:
				return "Cannot open file source for reference record";
			case ERAR_BAD_PASSWORD:
				return "Wrong password was specified";
			case ERAR_LARGE_DICT:
				return "File dictionary sizes exceeds the limit";
		}
		return "???";
	}
}

enum abstract ErrorType(Int) from Int to Int {
	/**
	 * Happens when the archive couldn't be opened.
	 */
	var ERR_OPEN;

	/**
	 * Happens while reading archive data.
	 */
	var ERR_READ;

	/**
	 * Happens while processing a file inside of the archive.
	 */
	var ERR_PROCESS;

	public function toString():String {
		switch (this) {
			case ERR_OPEN:
				return "Archive couldn't be opened";
			case ERR_READ:
				return "Couldn't read archive data";
			case ERR_PROCESS:
				return "Couldn't process a file inside of the archive";
		}
		return "???";
	}
}