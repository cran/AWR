#' Installing AWS SDK jars for R
#'
#' Downloads and installs the AWS SDK for Java jars and adds those to the Java classpath to be easily used in other R packages.
#'
#' The first time the package is loaded (which should happen in most cases automatically right after installation), this will check if the jar files are available and if not, then the package will try to automatically download  the specific version of jar files from the \url{https://gitlab.com/daroczig/AWR} private repository and push the files to the local \pkg{AWR} package's installation folder. If it does not succeed, please install the package directly from the private repository via \code{install.packages("AWR", repos = "https://daroczig.gitlab.io/AWR")}, which will download the jars bundled with the source package, so no separate downloads will be required. This is also suggested if you want to run the most recent version of the AWS SDK, as there is a new AWS SDK patch version rolled out almost every other day, while the CRAN updates happen less frequently.
#' @references \url{https://aws.amazon.com/sdk-for-java}
#' @docType package
#' @importFrom rJava .jpackage
#' @importFrom utils packageVersion unzip download.file
#' @name AWR-package
#' @examples \dontrun{
#' library(rJava)
#' kc <- .jnew("com.amazonaws.services.s3.AmazonS3Client")
#' kc$getS3AccountOwner()$getDisplayName()
#' }
NULL

.onLoad <- function(libname, pkgname) {

    ## path to the jars
    path <- file.path(system.file('', package = pkgname), 'java')

    ## check if the AWS Java SDK jars are available and install if needed (on first load)
    if (length(list.files(path)) == 0) {

        ## download the package from the private repo (storing the jars as well) to a temp location
        tzip <- tempfile()
        dres <- tryCatch(download.file(
            url = sprintf(
                'https://gitlab.com/daroczig/AWR/repository/archive.zip?ref=%s',
                packageVersion('AWR')),
            destfile = tzip, mode = 'wb'), error = function(e) e)

        ## create the java folder in the package install folder if not yet available
        if (!dir.exists(path)) {
            dir.create(path, recursive = TRUE)
        }

        ## compile a full list of files in the zip archive (also good for checkin)
        files <- tryCatch(unzip(tzip, list = TRUE), error = function(e) e)

        ## skip unzipping when there's a problem with the download
        if (!inherits(dres, 'error') && dres == 0 && !inherits(files, 'error')) {

            ## unzip the list of jars to the java folder
            files <- grep('.jar$', files$Name, value = TRUE)
            unzip(tzip, files = files, exdir = path, junkpaths = TRUE)

        }

        ## clean up temp files
        unlink(tzip)

    }

    ## add the jars to the Java classpath
    .jpackage(pkgname, lib.loc = libname,
              ## for devtools::load_all in the development environment
              morePaths = list.files(system.file('java', package = pkgname), full.names = TRUE))

}

.onAttach <- function(libname, pkgname) {

    ## let the user know if the AWR jar installation failed and provide hints on how to fix it
    path <- file.path(system.file('', package = pkgname), 'java')
    if (length(list.files(path)) == 0) {
        packageStartupMessage(
            'The automatic installation of the AWR jars seems to have failed.\n',
            'Please check your Internet connection and if the current user can write to ', path, '\n',
            'If still having issues, install the package from the private repo also including the jars:\n',
            '\ninstall.packages("AWR", repos = "https://daroczig.gitlab.io/AWR")\n')
    }

}
