# Cloudflare Workers custom domains for purrmeowca.com.
#
# These attach the apex and www hostnames to the "purrmeowca" Worker. The
# Worker's own code/deployment is NOT managed here — it's deployed via
# `wrangler deploy` from the application repo. Terraform only owns the
# domain-to-Worker attachment, not the Worker script itself.
#
# Resource type is `cloudflare_workers_domain` in provider v4 (the v5
# docs call it `cloudflare_workers_custom_domain`, but that name isn't
# valid here — confirmed against the locally installed v4.52.7 schema
# via `terraform providers schema -json`).
#
# These records already exist (created via the Cloudflare dashboard /
# wrangler), so they're imported into state — see README.md.

resource "cloudflare_workers_domain" "apex" {
  account_id = var.account_id
  zone_id    = var.zone_id
  hostname   = var.domain
  service    = "purrmeowca"
  environment = "production"
}

resource "cloudflare_workers_domain" "www" {
  account_id  = var.account_id
  zone_id     = var.zone_id
  hostname    = "www.${var.domain}"
  service     = "purrmeowca"
  environment = "production"
}
