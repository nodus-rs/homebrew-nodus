class NodusAT0161 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.16.1"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.16.1/nodus-v0.16.1-aarch64-apple-darwin.tar.gz"
      sha256 "80afa292efc89d0db0c9d9fba135b099ccee6c6bf66a06b427440fd45b99bf52"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.16.1/nodus-v0.16.1-x86_64-apple-darwin.tar.gz"
      sha256 "4e7781df7c6cb820abde2f31b9b8930e1e8a86dea33d1270bca8eb3699d04262"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.16.1/nodus-v0.16.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3bfd4b96c3f815676d7e831f2396f7a24fe25a669ed84fdca7447f752361ebcd"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.16.1/nodus-v0.16.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5f59ae75608598649e72f7c4ded856582b914c4ac9409de7104cac13635af7fc"
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
