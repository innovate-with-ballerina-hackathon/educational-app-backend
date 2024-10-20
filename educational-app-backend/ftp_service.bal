import ballerina/ftp;
import ballerina/log;
import ballerinax/kafka;

listener ftp:Listener fileListener = new ({
    host: "localhost",
    auth: {
        credentials: {
            username: "one",
            password: "12345678"
        }
    },
    path: "/home/in",
    fileNamePattern: "(.*).pdf"
});

service on fileListener {
    final kafka:Producer producer;

    function init() returns error? {
        self.producer = check new (kafka:DEFAULT_URL);
    }
    remote function onFileChange(ftp:WatchEvent & readonly event, ftp:Caller caller) returns error? {
        foreach ftp:FileInfo addedFile in event.addedFiles {
            log:printInfo(string `New movie has uploaded: ${addedFile.name}`);
            //stream<byte[] & readonly, io:Error?> fileStream = check caller->get(addedFile.pathDecoded);

            // check io:fileWriteBlocksFromStream(string `./local/${addedFile.name}`, fileStream);
            // check fileStream.close();
        }
    }
}