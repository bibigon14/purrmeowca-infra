terraform {
  required_version = ">= 1.7.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # Local state for now — fine for a single-operator homelab project.
  # If this ever needs to be applied from more than one machine, switch
  # to a remote backend (Terraform Cloud free tier, or an S3-compatible
  # backend like Cloudflare R2 itself).
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "cloudflare" {
  # Reads from the CLOUDFLARE_API_TOKEN environment variable.
  # Never hardcode the token here or in any committed file.
}
