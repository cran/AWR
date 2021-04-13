#' Making the AWS Java SDK JAR classes available in R
#'
#' This R package makes the \code{jar} files of the AWS SDK for Java
#' available to be used in downstream R packages. Please note the
#' installation instructions for the System Requirements in the
#' \code{README.md}.
#' @references \url{https://aws.amazon.com/sdk-for-java}
#' @docType package
#' @importFrom rJava .jpackage .jcall
#' @name AWR-package
#' @examples \dontrun{
#' library(rJava)
#' client <- .jnew("com.amazonaws.services.s3.AmazonS3Client")
#' kc$getS3AccountOwner()$getDisplayName()
#' }
NULL

.onAttach <- function(libname, pkgname) {

    if (!test_awr_jars()) {
        packageStartupMessage(check_awr_jars())
    }

}

.onLoad <- function(libname, pkgname) {

    ## add the package-bundled jars to the Java classpath
    rJava::.jpackage(
        pkgname, lib.loc = libname,
        ## for devtools::load_all in the development environment
        morePaths = list.files(system.file('java', package = pkgname), full.names = TRUE))

}
