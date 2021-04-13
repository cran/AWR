#' Tests if AWS SDK for Java jar files are available
#' @return boolean
#' @export
test_awr_jars <- function() {
    jars <- rJava::.jcall('java/lang/System', 'S', 'getProperty', 'java.class.path')
    grepl('aws-java-sdk', jars)
}


#' Asserts if AWS SDK for Java jar files are available
#' @return invisible \code{TRUE} on success, otherwise error
#' @export
assert_awr_jars <- function() {
    stopifnot(test_awr_jars())
    invisible(TRUE)
}


#' Checks if AWS SDK for Java jar files are available
#' @return \code{TRUE} on success, informative message as a string on error
#' @export
check_awr_jars <- function() {
    if (test_awr_jars()) {
        return(TRUE)
    }
    paste(
        'The AWS Java SDK was not found in the Java JAR class path,',
        'which means the AWR R package is not ready to be used yet!\n',
        'If you already have the AWS Java SDK jar files,',
        'you can use rJava::.jaddClassPath to reference those,',
        'otherwise you need to compile or download the JAR files',
        'as described in the README.md of the AWR package.',
        sep = '\n'
    )
}
