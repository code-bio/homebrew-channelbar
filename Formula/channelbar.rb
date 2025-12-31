class Channelbar < Formula
  desc "CLI tool for channelBar"
  homepage "https://channelbar.app"
  # Real URL - post_install re-downloads to preserve code signature
  url "https://github.com/code-bio/homebrew-channelbar/releases/download/v0.9.4/channelbar-cli-0.9.4.tar.gz"
  sha256 "1d5bfd5d06bc836dc5640878788d9d68dee47ac068ebfda4f8221dbeddbf36ca"
  license "Copyright 2025 Christian Franzl, code.bio GmbH"

  depends_on :macos

  def install
    # Create directories only - files come in post_install
    libexec.mkpath
  end

  def post_install
    # Download and extract AFTER Homebrew's post-processing
    tarball_url = "https://github.com/code-bio/homebrew-channelbar/releases/download/v#{version}/channelbar-cli-#{version}.tar.gz"

    # Clear and re-extract to preserve signatures
    system "rm", "-rf", libexec/"channelbar", libexec/"Frameworks"
    system "curl", "-L", tarball_url, "-o", "/tmp/channelbar-cli.tar.gz"
    system "tar", "-xzf", "/tmp/channelbar-cli.tar.gz", "-C", libexec
    system "rm", "/tmp/channelbar-cli.tar.gz"
    system "chmod", "755", libexec/"channelbar"

    # Create symlink manually after binary exists
    system "ln", "-sf", libexec/"channelbar", HOMEBREW_PREFIX/"bin/channelbar"
  end

  def caveats
    <<~EOS
      The channelbar CLI requires the channelBar app to be running.
      Get the app from: https://channelbar.app

      Usage:
        channelbar version               # Show current version
        channelbar                       # Show all commands
    EOS
  end

  test do
    assert_match(/channelbar|version/i, shell_output("#{bin}/channelbar version", 0))
  end
end
