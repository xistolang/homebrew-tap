# xistolang/homebrew-tap

Homebrew formulae for [xisto](https://github.com/xistolang/xisto), the native compiler for typed TypeScript.

```sh
brew install xistolang/tap/xisto
```

macOS on Apple silicon and Linux (x86-64 and ARM64, glibc 2.28 or newer) through Homebrew on Linux. xisto calls the
system C compiler at build time: the Xcode Command Line Tools on macOS, `build-essential` (or gcc/clang) on Linux.

The tap keeps itself current: `.github/workflows/update.yml` runs every 30 minutes, renders the formula of
xisto's latest release from that release's `packaging/homebrew/xisto.rb.in` and the published sha256, commits it, and
then installs it on clean macOS arm64, Linux x64 and Linux arm64 runners and builds a NestJS app as a new user would (`test/new-user.sh`). Edit the
template in the xisto repository, not `Formula/xisto.rb`.
