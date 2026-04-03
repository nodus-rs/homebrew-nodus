class NodusAT080 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.8.0"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.8.0/nodus-v0.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "c4e5741533675ee5f5e305850809a2f09d52b16dabb0a75b18a05c7b7712f6b9"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.8.0/nodus-v0.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "0d14aa5ce6ef38a82957012eb9eab3d06350e945a72d9ce70cf1b2769836591d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.8.0/nodus-v0.8.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "de9da07dadc1f983b22bc0aa794c263528a3d4aeb2a98f2b2e082af449452a99"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.8.0/nodus-v0.8.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0da6a6c11c9a155cc868889b7d87eedf18cf266ceea9217820b5ef12bd8fbcfe"
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
