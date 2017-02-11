#' Installing AWS SDK jars for R
#'
#' Downloads and installs the AWS SDK for Java jars from the \code{ARW.jars} packages, which also adds to the Java classpath to be easily used in other R packages.
#' @references \url{https://aws.amazon.com/sdk-for-java}
#' @docType package
#' @importFrom rJava .jpackage
#' @importFrom utils install.packages packageVersion
#' @name AWR-package
#' @examples \dontrun{
#' ## adding the jars to the Java classpath
#' library(rJava)
#'
#' ## creating a client in Java
#' kc <- .jnew("com.amazonaws.services.s3.AmazonS3Client")
#' ## listing the account name
#' kc$getS3AccountOwner()$getDisplayName()
#' }
NULL

.onLoad <- function(libname, pkgname) {

    ## check if the AWS Java SDK jars are available and install if needed
    if (requireNamespace('AWR.jars', quietly = TRUE) == FALSE) {
        warning('AWR.jars package not found, installing now...')
        install.packages('AWR.jars', repos = 'https://cardcorp.gitlab.io/AWR.jars')
    }

    ## make sure we have a recent version of the Java SDK
    if (packageVersion('AWR') > packageVersion('AWR.jars')) {
        warning(paste('AWR.jars package is older than current AWR package,',
                      'installing most recent version of the jars now...'))
        install.packages('AWR.jars', repos = 'https://cardcorp.gitlab.io/AWR.jars')
    }

    ## add jars to the Java classpath
    .jpackage('AWR.jars')

}
