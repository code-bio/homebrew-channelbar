class Channelbar < Formula
  desc "CLI tool for channelBar"
  homepage "https://channelbar.app"
  license "Copyright © 2026 code.bio GmbH"

  on_macos do
    url "https://github.com/code-bio/homebrew-channelbar/releases/download/v1.1.0/channelbar-cli-1.1.0.tar.gz"
    sha256 "612fb452fefc013799036b411fbdc9422848c107f7c682cb2556f061b00ee05e"

    def install
      libexec.mkpath
    end

    def post_install
      tarball_url = "https://github.com/code-bio/homebrew-channelbar/releases/download/v#{version}/channelbar-cli-#{version}.tar.gz"

      require "tempfile"
      tmpfile = Tempfile.new(["channelbar-cli", ".tar.gz"])
      tmppath = tmpfile.path
      tmpfile.close

      system "rm", "-rf", libexec/"channelbar", libexec/"Frameworks", libexec/"THIRD-PARTY-LICENSES.txt"
      system "curl", "-L", tarball_url, "-o", tmppath
      system "tar", "-xzf", tmppath, "-C", libexec
      system "rm", "-f", tmppath
      system "chmod", "755", libexec/"channelbar"

      system "ln", "-sf", libexec/"channelbar", HOMEBREW_PREFIX/"bin/channelbar"

      license_src = libexec/"THIRD-PARTY-LICENSES.txt"
      if File.exist?(license_src)
        doc.mkpath
        system "cp", "-p", license_src, doc/"THIRD-PARTY-LICENSES.txt"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/code-bio/homebrew-channelbar/releases/download/v1.1.0/channelbar-cli-1.1.0-linux-x86_64.tar.gz"
      sha256 "LINUX_X86_64_SHA256_PLACEHOLDER"
    end

    on_arm do
      url "https://github.com/code-bio/homebrew-channelbar/releases/download/v1.1.0/channelbar-cli-1.1.0-linux-arm64.tar.gz"
      sha256 "LINUX_ARM64_SHA256_PLACEHOLDER"
    end

    def install
      bin.install "channelbar-cli-#{version}/channelbar" => "channelbar"
      license_file = "channelbar-cli-#{version}/THIRD-PARTY-LICENSES.txt"
      doc.install license_file => "THIRD-PARTY-LICENSES.txt" if File.exist?(license_file)
    end
  end

  def caveats
    if OS.mac?
      <<~EOS

        The channelbar CLI requires the channelBar app to be running.
        Get the app from: https://channelbar.app

        Usage:
          channelbar version               # Show current version
          channelbar                       # Show all commands
          channelbar --licenses            # Show third-party licenses

      EOS
    else
      <<~EOS

        channelbar on Linux supports cloud functionality only.
        Local app communication is not available on Linux.

        Usage:
          channelbar set "message" --channel name --cloud
          channelbar ping --cloud
          channelbar version
          channelbar --licenses

      EOS
    end
  end

  test do
    assert_match(/channelbar|version/i, shell_output("#{bin}/channelbar version", 0))
  end
end
