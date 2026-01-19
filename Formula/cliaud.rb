class Cliaud < Formula
  desc "CLI audio output switcher + hotkey agent for macOS"
  homepage "https://github.com/Swas26/CliAud"
  url "https://github.com/Swas26/CliAud/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c98ba1d3bba45d47e52a753c19f792288b81ec0612cb1a51b666c4ecce8ff59b"

  license "MIT"

  depends_on :macos

  def install
    system "clang++", "-std=c++17", "cliaud.cpp", "-o", "cliaud",
           "-framework", "CoreFoundation", "-framework", "CoreAudio"
    bin.install "cliaud"

    system "clang++", "-std=c++17", "agent.cpp", "-o", "cliaud-agent",
           "-framework", "Carbon", "-framework", "ApplicationServices"
    bin.install "cliaud-agent"
  end

  service do
    run [opt_bin/"cliaud-agent"]
    keep_alive true
    environment_variables PATH: "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    log_path var/"log/cliaud-agent.log"
    error_log_path var/"log/cliaud-agent.err.log"
   end


  def caveats
    <<~EOS
      To run the hotkey agent at login:
        brew services start cliaud

      To stop it:
        brew services stop cliaud

      Hotkey: Cmd + Option + 9
    EOS
  end

  test do
    system "#{bin}/cliaud", "list"
  end
end
