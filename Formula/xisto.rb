# Generated from packaging/homebrew/xisto.rb.in (xistolang/xisto) by the tap's update workflow: edit it there.
class Xisto < Formula
  desc "Native compiler for typed TypeScript"
  homepage "https://github.com/xistolang/xisto"
  url "https://github.com/xistolang/xisto/releases/download/v0.4.3/xisto-0.4.3-macos-arm64.tar.gz"
  version "0.4.3"
  sha256 "6e5ca133cc94e04eecbcd6ae56d519aba601a70012a0fd74d3d462d186160783"
  license "Apache-2.0" => { with: "LLVM-exception" }

  depends_on arch: :arm64
  depends_on :macos

  def install
    libexec.install Dir["*"]
    # a script, not a link: xisto finds qbe, the runtime objects and the packages next to its real executable
    bin.write_exec_script libexec/"build/xisto"
  end

  test do
    assert_match "xisto #{version}", shell_output("#{bin}/xisto --version")
    (testpath/"hello.ts").write <<~TS
      const xs: number[] = [1, 2, 3];
      console.log(`hello ${xs.reduce((a, b) => a + b, 0)}`);
    TS
    system bin/"xisto", "build", "-o", "hello", "hello.ts"
    assert_equal "hello 6", shell_output("./hello").strip
  end
end
