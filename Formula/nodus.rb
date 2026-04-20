class Nodus < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.10.1"
  license "Apache-2.0"
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.1/nodus-v0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "bfdda9eed1f2fe8ca42aba5953c3507bcff738d0f0532001ead06f0754aff3d8"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.1/nodus-v0.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "c607b1795916e2cb56b8bcc0c49ec01fc3db30ec1f18ec1f2638dcf0b4fbf67b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.1/nodus-v0.10.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ae7b09df133a0102505c371da6a8b5c1779e3d0f43ac44a3df5c08fd27af104a"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.10.1/nodus-v0.10.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "296461e2b2bb6dd47ca53535b1ba782a1d72c5292e7481d72d2cf5fecdbbf4aa"
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
