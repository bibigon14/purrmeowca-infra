# R2 buckets used by purrmeowca.com.
#
# `purrmeowca-media` is served publicly via the media.purrmeowca.com CNAME
# (see dns.tf — that record is owned by R2's public-access config, not
# managed here). `purrmeowca-reviews` is a private bucket (no public CNAME),
# presumably consumed directly by the Worker via an R2 binding.
#
# These buckets already exist, so they're imported into state — see
# README.md. `location` is omitted because Cloudflare doesn't let you
# change it after creation, and the API doesn't return one for buckets
# created without an explicit location hint, so leaving it unset avoids a
# spurious diff against the live (empty) value. If `terraform plan` shows
# a location diff after import, set it explicitly here to whatever's
# already there rather than guessing.

resource "cloudflare_r2_bucket" "media" {
  account_id = var.account_id
  name       = "purrmeowca-media"
}

resource "cloudflare_r2_bucket" "reviews" {
  account_id = var.account_id
  name       = "purrmeowca-reviews"
}
