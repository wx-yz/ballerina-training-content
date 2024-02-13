import ballerina/http;
import ballerina/io;

public function main() returns error? {
    http:Client github = check new ("https://api.github.com");

    // `->` is used to access the resource/remote functions in the client class.
    //json[] repos = check github->get("/orgs/ballerina-platform/repos");

    // The above line can be written as below to use resource path style. 
    json[] repos = check github->/orgs/ballerina\-platform/repos;
    io:println("Repos: ", repos);
    io:println("Repo count: ", repos.length());
    io:println("First Repo:", repos[0].name);
}
