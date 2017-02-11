# AWR

This R package installs the [AWS SDK for Java](https://aws.amazon.com/sdk-for-java) `jar` files from [AWR.jars](https://gitlab.com/cardcorp/AWR.jars) to be used in downstream R packages.

## Why the name?

This is an R package bundling AWS jars, but S is so 1992.

## What is it good for?

The bundled Java SDK is useful for R package developers working with AWS so that they can easily import this package to get access to the Java `jar` files. Quick example on using the Amazon S3 Java client:

```r
> ## adding the jars to the Java classpath
> library(rJava)

> ## creating a client in Java
> kc <- .jnew("com.amazonaws.services.s3.AmazonS3Client")
> ## listing the account name
> kc$getS3AccountOwner()$getDisplayName()
[1] "foobar"
```
