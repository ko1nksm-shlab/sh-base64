# sh-base64

Base64 encoder/decoder implementation for portable shell scripts

This is **not** an extremely slow pure shell script implementation. sh-base64 uses some basic POSIX commands that are portable to improve performance (but still slower than native commands).

## Requirements

- POSIX shell (dash, bash, ksh, mksh, yash, zsh, etc)
- Basic POSIX commands (`od`, `tr`, `fold`, `xargs`, and `awk`)

## Usage

The `base64encode`/`base64decode` argument can be a 2 or 3 character string. If any other number of characters is specified, the behavior is undefined.

```sh
. ./base64.sh

# Base64 encode
base64encode       # Basic usage (base64 standard)
base64encode "+/"  # Use + and / for the 62nd and 63rd characters, no padding
base64encode "-_"  # Use - and _ for the 62nd and 63rd characters, no padding (base64url)
base64encode "+/=" # Use + and / for the 62nd and 63rd characters and = for padding

# Base64 decode
base64decode       # Basic usage (base64 standard)
base64decode "+/"  # Use + and / for the 62nd and 63rd characters
base64decode "-_"  # Use - and _ for the 62nd and 63rd characters (base64url)
```

## Example

```console
$ echo abc | ./base64
YWJjCg==

$ echo abc | ./base64 | ./base64 -d
abc

$ echo abc | AWK=mawk ./base64 | AWK=mawk ./base64 -d
abc
```

## Performance

Test environment: macOS (CPU: 2.4 GHz dual-core Intel Core i5)

Created a 10 MB file for performance testing

```console
$ head -c 10m /dev/urandom > data.bin
$ base64 < data.bin > data.base64

$ md5sum data.bin data.base64
a740084d87aaed16c1f4ea40a6acf1b0  data.bin
8096a63dc595bae96d6dfcf797c9429d  data.base64
```

Base64 encoder comparison with `base64` command

```console
$ time base64 < data.bin | md5sum
8096a63dc595bae96d6dfcf797c9429d  -

real	0m1.932s
user	0m1.930s
sys 	0m0.067s

$ time ./base64 < data.bin | md5sum
8096a63dc595bae96d6dfcf797c9429d  -

real	0m23.486s
user	0m34.771s
sys 	0m0.331s
```

Base64 decoder comparison with `base64` command

```console
$ time base64 -d < data.base64 | md5sum
a740084d87aaed16c1f4ea40a6acf1b0  -

real	0m0.247s
user	0m0.380s
sys 	0m0.102s

$ time ./base64 -d < data.base64 | md5sum
a740084d87aaed16c1f4ea40a6acf1b0  -

real	0m16.181s
user	0m19.320s
sys 	0m1.074s
```
