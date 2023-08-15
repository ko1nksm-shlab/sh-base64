# shellcheck shell=sh disable=SC2016

base64encode() {
  set -- "${1:-"+/="}"
  set -- "$@" "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  od -v -An -tx1 | LC_ALL=C tr -d ' \t\n' | LC_ALL=C fold -b -w6 | {
    LC_ALL=C awk -v x="$2${1%=}" -v p="${1#??}" '
      function dec2bin(n, w,  r) {
        r = ""
        do { r = (n % 2) r } while ( n = int(n / 2) )
        return sprintf("%0" w "d", r)
      }
      BEGIN {
        for (i = 0; i < 256; i++) b[sprintf("%02x", i)] = dec2bin(i, 8)
        for (i = 0; i < 256; i++) b[sprintf("%02X", i)] = dec2bin(i, 8)
        for (i = 0; i < 64; i++) c[dec2bin(i, 6)] = substr(x, i + 1, 1)
      }
      {
        pad = 3 - (length / 2); bits = chars = ""
        for (i = 0; i < pad; i++) $0 = $0 "00"
        for (i = 1; i <= 6; i+=2) bits = bits b[substr($0, i, 2)]
        for (i = 1; i <= 24; i+=6) chars = chars c[substr(bits, i, 6)]
        if (pad > 0) chars = substr(chars, 1, 4 - pad)
        while (pad--) chars = chars p
        printf "%s", chars
      }
      END { print "" }
    '
  }
}

base64decode() {
  set -- "${1:-"+/="}"
  set -- "$@" "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  LC_ALL=C fold -b -w100 | { # fold width must be a multiple of 4
    LC_ALL=C awk -v x="$2${1%=}" -v p="${1#??}" '
      function dec2bin(n, w,  r) {
        r = ""
        do { r = (n % 2) r } while ( n = int(n / 2) )
        return sprintf("%0" w "d", r)
      }
      BEGIN {
        for (i = 0; i < 64; i++) b[substr(x, i + 1, 1)] = dec2bin(i, 6)
        for (i = 1; i < 256; i++) c[dec2bin(i, 8)] = sprintf("%c", i)
        for (i = 48; i < 56; i++) c[dec2bin(i, 8)] = sprintf("\\\\%03o", i)
        c["00000000"] = "\\\\000"; c["00001001"] = "\\\\011" # NUL HT
        c["00001010"] = "\\\\012"; c["00001011"] = "\\\\013" # LF  VT
        c["00001100"] = "\\\\014"; c["00001101"] = "\\\\015" # FF  CR
        c["00100000"] = "\\\\040"; c["00100010"] = "\\\\042" # SPC DQ
        c["00100101"] = "\\\\045"; c["00100111"] = "\\\\047" # %   SQ
        c["01011100"] = "\\\\\\\\"
      }
      {
        bits = chars = ""; len = length
        for (i = 1; i <= len; i++) bits = bits b[substr($0, i, 1)]
        for (i = 1; i <= len * 6; i+=8) chars = chars c[substr(bits, i, 8)]
        print chars
      }
    '
  } | (
    for_mksh='[ ${KSH_VERSION:+x} ] && alias printf="print -n";'
    code='IFS=; printf -- "$*"' prog="${ZSH_ARGZERO:-"$0"}"
    LC_ALL=C xargs -n 1000 -E '' sh -c "${for_mksh}${code}" "$prog"
  )
}
