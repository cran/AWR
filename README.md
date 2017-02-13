# AWR

This R package bundles the [AWS SDK for Java](https://aws.amazon.com/sdk-for-java) `jar` files to be used in downstream R packages.

## Why the name?

This is an R package to interact with AWS, but S is so 1992.

## What is it good for?

The bundled Java SDK is useful for R package developers working with AWS so that they can easily import this package to get access to the Java `jar` files. Quick example on using the Amazon S3 Java client:

```r
> library(rJava)
> kc <- .jnew('com.amazonaws.services.s3.AmazonS3Client')
> kc$getS3AccountOwner()$getDisplayName()
[1] "foobar"
```

## Installation

![CRAN version](http://www.r-pkg.org/badges/version-ago/AWR)

The package is hosted on [CRAN](https://cran.r-project.org/package=AWR), so installation is as easy as:

```r
install.packages('AWR')
```

But you can similarly easily install the most recent version of the SDK from the development git repository as well thanks to `drat`:

```r
install.packages('AWR', repos = 'https://cardcorp.gitlab.io/AWR')
```

If you want to install a specific version of the AWS SDK, then refer to the version tag, eg installing `1.11.76`:

```r
install.packages('https://gitlab.com/cardcorp/AWR/repository/archive.tar.gz?ref=1.11.76', repos = NULL)
```
