#!/bin/sh
# A new user on macOS arm64: brew install from this tap, xisto init, xisto add (the real package registry), a NestJS
# hello, build, run, curl; then the lock file alone brings the packages back (rm -rf .xisto && xisto install).
# XISTO_EXPECT, when set, is the version xisto --version must print.
set -eu
W=$(mktemp -d "${TMPDIR:-/tmp}/xisto-new-user.XXXXXX")
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_INSTALL_CLEANUP=1
brew tap -q xistolang/tap 2>/dev/null || true
git -C "$(brew --repository xistolang/tap)" pull -q
brew upgrade -q xistolang/tap/xisto 2>/dev/null || brew install -q xistolang/tap/xisto
V=$(xisto --version)
echo "$V"
if [ -n "${XISTO_EXPECT:-}" ] && [ "$V" != "xisto $XISTO_EXPECT" ]; then
  echo "expected xisto $XISTO_EXPECT, got: $V" >&2
  exit 1
fi
cd "$W"
xisto init hello-nest
cd hello-nest
xisto run
xisto add @nestjs/common @nestjs/core @nestjs/platform-express
cat > src/main.ts <<'TS'
import { Controller, Get, Module } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

@Controller()
class AppController {
  @Get()
  hello(): string {
    return 'Hello from xisto';
  }
}

@Module({ controllers: [AppController] })
class AppModule {}

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  await app.listen(3123);
}
bootstrap();
TS
xisto build
./hello-nest > server.log 2>&1 &
PID=$!
i=0
until curl -s -o /dev/null http://127.0.0.1:3123/ || [ $i -ge 100 ]; do sleep 0.1; i=$((i + 1)); done
BODY=$(curl -s http://127.0.0.1:3123/)
kill $PID
echo "GET / -> $BODY"
[ "$BODY" = "Hello from xisto" ] || { echo "unexpected answer" >&2; cat server.log >&2; exit 1; }
rm -rf .xisto
xisto install
xisto build
echo "new user: ok"
