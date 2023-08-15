# sh-base64

Base64 encoder/decoder implementation for portable shell scripts

This is not an extremely slow pure shell script implementation.
sh-base64 uses some basic POSIX commands that are highly portable to improve performance.

## Requirements

- POSIX shell (dash, bash, ksh, mksh, yash, zsh, etc)
- Basic POSIX commands (`od`, `tr`, `fold`, `xargs`, and `awk`)

## Usage

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

Preparation: Generate a 10MB file

```console
$ head -c 10m /dev/urandom > data.bin

$ md5sum data.bin
a740084d87aaed16c1f4ea40a6acf1b0  data.bin
```

Base64 encoder comparison with `base64` command

```console
$ time base64 < data.bin | md5sum
8096a63dc595bae96d6dfcf797c9429d  -

real	0m2.209s
user	0m2.073s
sys 	0m0.077s

$ time ./base64 < data.bin | md5sum
8096a63dc595bae96d6dfcf797c9429d  -

real	0m27.082s
user	0m38.066s
sys 	0m0.335s
```

Base64 decoder comparison with `base64` command

```console
$ time base64 -d < data.base64 | md5sum
a740084d87aaed16c1f4ea40a6acf1b0  -

real	0m0.348s
user	0m0.465s
sys 	0m0.134s

$ time ./base64 -d < data.base64 | md5sum
a740084d87aaed16c1f4ea40a6acf1b0  -

real	0m23.023s
user	0m27.822s
sys 	0m1.229s
```
