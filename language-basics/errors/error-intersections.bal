import ballerina/io;

type FileError distinct error<record {string message;}>;

type IOError distinct error<record {int length;}>;

type FileIOError FileError & IOError;

// By the definition of intersection types, an error value e will belong 
// to FileIOError if and only if it belongs to both FileError and IOError 
public function main() {
    FileError fileError = error("File Error", message = "no extension");
    IOError ioError = error("IO Error", length = 4);
    FileIOError fileIOError = error("File IO Error", message = "Invalid file length", length = 4);

    io:println(fileIOError is FileIOError);
    io:println(fileIOError is FileError);
    io:println(fileIOError is IOError);

}
