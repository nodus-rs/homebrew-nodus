class NodusAT033 < Formula
  desc "Add agent packages to your repo with one command"
  homepage "https://github.com/nodus-rs/nodus"
  version "0.3.3"
  license "Apache-2.0"
  keg_only :versioned_formula
  head "https://github.com/nodus-rs/nodus.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/nodus-rs/nodus/releases/download/v0.3.3/nodus-v0.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "e2f7667ac18b174f08a7c40dde88e8bf8ceb2cc44ccdedfe00eb2f05558db5af"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.3.3/nodus-v0.3.3-x86_64-apple-darwin.tar.gz"
      sha256 "2ca8a4cd28ce73c83b363d5575f8832472067515feaa9dd2cb59477b362050e4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      odie "Linux ARM is not supported for nodus #{version}"
    else
      url "https://github.com/nodus-rs/nodus/releases/download/v0.3.3/nodus-v0.3.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5a67f2707543d69b874bc5321ec6e4ff0a1f26c0fbebce37c8e88ceb725650c8"
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
