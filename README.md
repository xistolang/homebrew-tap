# xistolang/homebrew-tap

Homebrew formulae for [xisto](https://github.com/xistolang/xisto), the native compiler for typed TypeScript.

```sh
brew install xistolang/tap/xisto
```

The tap keeps itself current: `.github/workflows/update.yml` runs every 30 minutes, renders the formula of
xisto's latest release from that release's `packaging/homebrew/xisto.rb.in` and the published sha256, commits it, and
then installs it on a clean macOS runner and builds a NestJS app as a new user would (`test/new-user.sh`). Edit the
template in the xisto repository, not `Formula/xisto.rb`.
