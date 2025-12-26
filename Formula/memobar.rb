class Memobar < Formula
  desc "CLI tool for memoBar"
  homepage "https://memobar.app"
  # Use a dummy URL - we extract manually to preserve signatures
  url "https://github.com/code-bio/homebrew-memobar/releases/download/v0.3.3/memobar-cli-0.3.3.tar.gz"
  sha256 "a3b76cb58253462223a0445a36b5da8150e157db2be08e4c0a2a03f6a8b0b74a"
  license "Copyright 2025 Christian Franzl, code.bio GmbH"

  depends_on :macos

  def install
    # Create directories only - files come in post_install
    libexec.mkpath
  end

  def post_install
    # Download and extract AFTER Homebrew's post-processing
    tarball_url = "https://github.com/code-bio/homebrew-memobar/releases/download/v#{version}/memobar-cli-#{version}.tar.gz"

    # Clear and re-extract to preserve signatures
    system "rm", "-rf", libexec/"memobar", libexec/"Frameworks"
    system "curl", "-L", tarball_url, "-o", "/tmp/memobar-cli.tar.gz"
    system "tar", "-xzf", "/tmp/memobar-cli.tar.gz", "-C", libexec
    system "rm", "/tmp/memobar-cli.tar.gz"
    system "chmod", "755", libexec/"memobar"

    # Create symlink manually after binary exists
    system "ln", "-sf", libexec/"memobar", HOMEBREW_PREFIX/"bin/memobar"
  end

  def caveats
    <<~EOS
      The memobar CLI requires the memoBar app to be running.
      Get the app from: https://memobar.app

      Usage:
        memobar version                  # Show current version
        memobar --help                   # Show all commands

      macOS Tahoe (26+):
        If you see a dialog about accessing data from other apps,
        grant Full Disk Access to your terminal:
        System Settings → Privacy & Security → Full Disk Access
    EOS
  end

  test do
    assert_match(/memobar|version/i, shell_output("#{bin}/memobar version", 0))
  end
end
