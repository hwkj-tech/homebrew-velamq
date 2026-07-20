class Velamq < Formula
  desc "High-performance MQTT broker for IoT"
  homepage "https://yunliu.tech/velamq"
  version "0.0.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://repo.yunliu.tech/velamq/downloads/velamqd-0.0.1-macos-aarch64.zip"
      sha256 "12116bcf29e1c544272feac6f9d651f668ed69a4410191be2175a19a33906b6d"
    else
      url "https://repo.yunliu.tech/velamq/downloads/velamqd-0.0.1-macos-x86_64.zip"
      sha256 "c7283209623e6ef6b12a1846239118ed9a1647a7adb44ac0aafe2baba50f997b"
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
