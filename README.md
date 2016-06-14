
# fswatch

> Watch a File or Directory for Changes

[![Linux Build Status](https://travis-ci.org/gaborcsardi/fswatch.svg?branch=master)](https://travis-ci.org/gaborcsardi/fswatch)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/gaborcsardi/fswatch?svg=true)](https://ci.appveyor.com/project/gaborcsardi/fswatch)
[![](http://www.r-pkg.org/badges/version/fswatch)](http://www.r-pkg.org/pkg/fswatch)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/fswatch)](http://www.r-pkg.org/pkg/fswatch)

Get notification is a file or any file in a directory changes. It uses the
fswatch tool (see https://github.com/emcrisostomo/fswatch) and works on
major platforms.

## Installation

Make sure you install the standalone `fswatch` program first, from
https://github.com/emcrisostomo/fswatch

Then install the R package as:

```r
source("https://install-github.me/gaborcsardi/fswatch")
```

## Usage

```r
library(fswatch)
```

Create a directory and start watching it. The callback will simply print
the file(s) that has changed.

```r
tmp <- tempfile()
dir.create(tmp)
id <- fswatch(tmp, callback = function(f) print(f))
```

Now modify the directory to see a notification.

```r
cat("hello", file = file.path(tmp, "foobar"))
```

```
#> [1] "/private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/Rtmpgj5lSY/file12c557f73ef61/foobar"
```

Removing the file will also trigger a notification.

```r
file.remove(file.path(tmp, "foobar"))
```

```
#> [1] "/private/var/folders/ws/7rmdm_cn2pd8l1c3lqyycv0c0000gn/T/Rtmpgj5lSY/file12c557f73ef61/foobar"
```

## License

GPL-3 © Gábor Csárdi
