
import ballerina/ftp;
import ballerina/io;
// import ballerina/lang.'string as strings;

ftp:ClientConfiguration config = {
        protocol: ftp:FTP,
        host: "localhost",
        port: 21,
        // username is set to `one` and the password is set to `1234` as we've given when running the docker ftp server.
        auth: {credentials: {username: "one", password: "12345678"}}
};

ftp:Client clientEp = check new(config);

public function main() returns error? {
    //can upload a file to the ftp server when the file is in the  directory
    stream<io:Block, io:Error?> bStream = check io:fileReadBlocksAsStream("./resources/docs/mid_exam.pdf", 5);
    ftp:Error? response = check clientEp->put("/home/in/final_exam_1.pdf", bStream);

    //TODO: need a way to upload a file and that uplaoded file should be uploaded to the ftp server
    //TODO: integrate kafka to this

    // Read back the file from the ftp server. Give the same location given in the `put` operation and the size of the byte array. 
    // stream<byte[] & readonly, io:Error?> str = check clientEp->get("/home/in/test2.txt");
    // record {|byte[] value;|}|io:Error? bArray = str.next();
    // if (bArray is record {|byte[] value;|}) {
    //     string fileContent = check strings:fromBytes(bArray.value);
    //     // This will print the content that will fix into the given byte array size.
    //     io:println(fileContent);
    // }
    // io:Error? closeResult = str.close();
    // if (closeResult is io:Error) {
    //     io:println("Error while closing stream in `get` operation.");
    // }
}