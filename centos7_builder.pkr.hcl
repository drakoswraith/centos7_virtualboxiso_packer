build {
  sources = ["sources.virtualbox-iso.centos7"]

  post-processor "manifest" {
    output = "manifest.json"
    strip_path = true
    custom_data = {
      the_maker = "default_email@me.local"
    }
  }

  provisioner "shell" {
    scripts = [
      "scripts/sshd.sh",
      "scripts/virtualbox.sh",
      "scripts/cleanup.sh",
    ]
  }
}