# Generated from packaging/homebrew/xisto.rb.in (xistolang/xisto) by the tap's update workflow: edit it there.
class Xisto < Formula
  desc "Native compiler for typed TypeScript"
  homepage "https://github.com/xistolang/xisto"
  version "0.5.1"
  license "Apache-2.0" => { with: "LLVM-exception" }

  on_macos do
    depends_on arch: :arm64 # (Intel Macs: build from source)
    on_arm do
      url "https://github.com/xistolang/xisto/releases/download/v0.5.1/xisto-0.5.1-macos-arm64.tar.gz"
      sha256 "6dfed73476167ff7e43dbf5cec98b822b9ca0253250e079778c63d1a720efe92"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/xistolang/xisto/releases/download/v0.5.1/xisto-0.5.1-linux-x64.tar.gz"
      sha256 "5d225f3376ec588e84d6c48c3bacabb8253827581fc4d14ffeecc6cb101aa6e8"
    end
    on_arm do
      url "https://github.com/xistolang/xisto/releases/download/v0.5.1/xisto-0.5.1-linux-arm64.tar.gz"
      sha256 "d6e847ba715b895f883ebe324a71edd7ff47b5444a9e6d3e5e104789754f31be"
    end
  end

  # xisto compiles the C it generates with the system C compiler (XISTO_CC, else clang, else cc): on macOS clang from
  # the Xcode Command Line Tools, on Linux the gcc or clang Homebrew on Linux itself asks for (build-essential,
  # "Development Tools"). No Homebrew compiler is pulled in: it would add hundreds of megabytes to every install
  # for a compiler Homebrew on Linux already requires on the machine.

  def install
    libexec.install Dir["*"]
    # a script, not a link: xisto finds qbe, the runtime objects and the packages next to its real executable
    bin.write_exec_script libexec/"build/xisto"
  end

  def caveats
    on_linux do
      <<~EOS
        xisto calls the system C compiler (clang if it is on PATH, else cc). If `cc --version` fails, install one:
          sudo apt-get install build-essential     # Debian, Ubuntu
          sudo dnf install gcc                     # Fedora, RHEL, Amazon Linux
        clang makes faster programs than gcc: sudo apt-get install clang / sudo dnf install clang.
      EOS
    end
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
