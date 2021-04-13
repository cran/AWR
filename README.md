# AWR

This R package makes the [AWS SDK for
Java](https://aws.amazon.com/sdk-for-java) `jar` files available to be
used in downstream R packages.

## Lifecycle

Please note that this package was originally created in 2015, when the
Python integration in R was much less mature, so using the Java SDK
made sense. Since then, using the Python SDK is much easier than relying
on the Java SDK from R, so thus this package will be deprecated in the
future, and I rather suggest using the `botor` R package (using the `boto3`
Python package in the background) when possible:

https://cran.r-project.org/package=botor

This package is still maintained for the near future to provide support
for the R packages depending on it, especially `AWR.Kinesis` that will
still need Java support due to the `MultiLangDaemon`.

## Why the name?

This is an R package bundling AWS files, but S is so 1992.

## What is it good for?

The AWS Java SDK is useful for R package developers working with AWS
so that they can easily import this package to get access to the Java
`jar` files. Quick example on using the Amazon S3 Java client:

```r
> ## adding the jars to the Java classpath
> library(rJava)

> ## creating a client in Java
> kc <- .jnew("com.amazonaws.services.s3.AmazonS3Client")
> ## listing the account name
> kc$getS3AccountOwner()$getDisplayName()
[1] "foobar"
```

For a more complete (yet simple) example implementation, see the
`AWR.KMS` package hosted on
[CRAN](https://cran.r-project.org/package=AWR.KMS) and
[GitHub](https://github.com/daroczig/AWR.KMS), or `AWR.Kinesis` at
[GitHub](https://github.com/daroczig/AWR.Kinesis)

## Installation

![CRAN version](http://www.r-pkg.org/badges/version-ago/AWR)

Although the package is hosted on
[CRAN](https://cran.r-project.org/package=AWR), so installation is as
easy as:

```r
install.packages('AWR')
```

But due to the large size of the Java SDK and the related CRAN policy,
it only includes the very lightweight wrapper around the `jar` files
and not the actual Java SDK files.

To install the required Java files, you can download the most recent
compiled version from
https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip,
then extract the `jar` files either directly to the installed `AWR`
package's `java` folder, or at any other folder on your computer and
use `rJava::.jaddClassPath` to reference those.

Compiling from source can be done by downloading the sources from
https://github.com/aws/aws-sdk-java and following the instructions
using `maven` -- a quick example that was used in automated builds
for older version of `AWR`:

```sh
VERSION=1.11.189

wget -q https://github.com/aws/aws-sdk-java/archive/$VERSION.tar.gz
tar xzf $VERSION.tar.gz
rm $VERSION.tar.gz

cd aws-sdk-java-$VERSION
DATE=`date -r pom.xml +'%Y-%m-%d %H:%M'`

# the folder structure changed over time and different dependencies were also required, so this these checks
if [ -d aws-java-sdk ]; then
    cd aws-java-sdk
    mvn dependency:copy-dependencies > /dev/null
    cp target/dependency/*.jar ../../
    cd ..
else
    # wget https://maven.repository.redhat.com/ga/net/sf/saxon/saxon9he/9.4.0.4/saxon9he-9.4.0.4.jar
    # mvn install:install-file -Dfile=saxon9he-9.4.0.4.jar -DgroupId=net.sf.saxon \
    #     -DartifactId=saxon9he -Dversion=9.4.0.4 -Dpackaging=jar
    mvn clean package  -DskipTests -Dmaven.test.skip=true -Dgpg.skip=true
    mvn dependency:copy-dependencies
    cp target/dependency/*.jar ../
    cp target/*.jar ../
fi

cd ..
rm -rf aws-sdk-java-$VERSION
cd ../..
```

If you just want to quickly install even an older version of the Java SDK,
you can also use the `drat` repo created a long time ago on GitLab:

```r
install.packages('AWR', repos = 'https://daroczig.gitlab.io/AWR')
```

Note that this will overwrite your `AWR` installation.

## Changelog

This R package is a very thin layer on the top of the AWS Java SDK, so please consult https://github.com/aws/aws-sdk-java/blob/master/CHANGELOG.md directly for the list of changes.
