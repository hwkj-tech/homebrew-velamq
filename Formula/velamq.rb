class Velamq < Formula
  desc "High-performance MQTT broker for IoT"
  homepage "https://velamq.com"
  version "0.0.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://repo.velamq.com/downloads/velamqd-0.0.1-macos-aarch64.zip"
      sha256 "381adf8aa5c1ac5214e17794d851113e687963bfcf4cb03e4c8114c0c2d3fb2d"
    else
      url "https://repo.velamq.com/downloads/velamqd-0.0.1-macos-x86_64.zip"
      sha256 "6bd21c322c69d416b1eb8530fcacfa40c1ebb8b7341a249fc7f5683cc295b2a9"
    end
  end

  def install
    package_dir = Dir["velamqd-*"].first
    cd package_dir if package_dir

    bin.install "bin/velamqd"
    bin.install "bin/velamq-bench" if File.exist?("bin/velamq-bench")

    (etc/"velamq").mkpath
    if File.exist?("config.toml") && !(etc/"velamq/config.toml").exist?
      (etc/"velamq/config.toml").write File.read("config.toml")
    end

    (var/"lib/velamq").mkpath
    (var/"log/velamq").mkpath
  end

  service do
    run [opt_bin/"velamqd"]
    keep_alive true
    working_dir var/"lib/velamq"
    environment_variables VELAMQ_CONFIG_FILE: etc/"velamq/config.toml"
    log_path var/"log/velamq/velamq.log"
    error_log_path var/"log/velamq/velamq.err.log"
  end

  test do
    system "#{bin}/velamqd", "--version"
  end
end
