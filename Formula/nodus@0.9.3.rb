class NodusAT093 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.9.3"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.3/nodus-v0.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "3972f39f6e9aaadaee3741ebdc927e639d50b0f3783547c922da462009852840"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.3/nodus-v0.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "9ab66036b18688f470f6dd95f4e5b512e294441c8bf18dddf44499b645745535"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.3/nodus-v0.9.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5bd4ba593fa590f0958c6bc210ba59e751f5ba501c3a8ed4632447aff8019ec1"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.9.3/nodus-v0.9.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9ea555ba4d5ccaea702012719422137da6827f757422307433a9e7d91341c6f0"
    end
  end

  def install
    bin.install "nodus"
    generate_completions_from_executable(bin/"nodus", "completion")
    doc.install "README.md" if File.exist?("README.md")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nodus --version")
    assert_match "_nodus", shell_output("#{bin}/completion zsh")
  end
end
