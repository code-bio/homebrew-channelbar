class Channelbar < Formula
  desc "CLI tool for channelBar"
  homepage "https://channelbar.app"
  # Real URL - post_install re-downloads to preserve code signature
  url "https://github.com/code-bio/homebrew-channelbar/releases/download/v1.1.0/channelbar-cli-1.1.0.tar.gz"
  sha256 "612fb452fefc013799036b411fbdc9422848c107f7c682cb2556f061b00ee05e"
  license "Copyright © 2026 code.bio GmbH"

  depends_on :macos

  def install
    # Create directories only - files come in post_install
    libexec.mkpath
  end

  def post_install
    # Download and extract AFTER Homebrew's post-processing
    tarball_url = "https://github.com/code-bio/homebrew-channelbar/releases/download/v#{version}/channelbar-cli-#{version}.tar.gz"

    # Use unique temp file to avoid conflicts with parallel installs
    require "tempfile"
    tmpfile = Tempfile.new(["channelbar-cli", ".tar.gz"])
    tmppath = tmpfile.path
    tmpfile.close

    # Clear and re-extract to preserve signatures
    system "rm", "-rf", libexec/"channelbar", libexec/"Frameworks", libexec/"THIRD-PARTY-LICENSES.txt"
    system "curl", "-L", tarball_url, "-o", tmppath
    system "tar", "-xzf", tmppath, "-C", libexec
    system "rm", "-f", tmppath
    system "chmod", "755", libexec/"channelbar"

    # Create symlink manually after binary exists
    system "ln", "-sf", libexec/"channelbar", HOMEBREW_PREFIX/"bin/channelbar"

    # Install license file to doc directory (if present in tarball)
    license_src = libexec/"THIRD-PARTY-LICENSES.txt"
    if File.exist?(license_src)
      doc.mkpath
      system "cp", "-p", license_src, doc/"THIRD-PARTY-LICENSES.txt"
    end
  end

  def caveats
    <<~EOS

      The channelbar CLI requires the channelBar app to be running.
      Get the app from: https://channelbar.app

      Usage:
        channelbar version               # Show current version
        channelbar                       # Show all commands
        channelbar --licenses            # Show third-party licenses

    EOS
  end

  test do
    assert_match(/channelbar|version/i, shell_output("#{bin}/channelbar version", 0))
  end
end
