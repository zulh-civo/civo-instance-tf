# Query small instance size
data "civo_size" "small" {
  filter {
    key      = "name"
    values   = [var.instance_type]
    match_by = "re"
  }

  filter {
    key    = "type"
    values = ["instance"]
  }
}

# Query instance disk image
data "civo_disk_image" "ubuntu" {
  filter {
    key    = "name"
    values = [var.disk_image_name]
  }

  filter {
    key    = "version"
    values = [var.disk_image_version]
  }

  region = var.region
}

# For debugging only
output "all_disk_images" {
  value = data.civo_disk_image.ubuntu.diskimages
}

# For debugging only
output "ubuntu_jammy_disk_image_id" {
  value = element(data.civo_disk_image.ubuntu.diskimages, 0).id
}

# Create a new instance
resource "civo_instance" "instances" {
  count        = var.instance_count
  hostname     = "terraform-test"
  size         = element(data.civo_size.small.sizes, 0).name
  disk_image   = element(data.civo_disk_image.ubuntu.diskimages, 0).id
  initial_user = "ubuntu"
  region       = var.region
}
