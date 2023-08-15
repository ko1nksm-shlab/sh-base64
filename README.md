# sh-base64

Base64 encoder/decoder implementation for portable shell scripts

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
```
