# Zone-level settings for purrmeowca.com.
#
# Cloudflare's zone has 50+ configurable settings; almost all of them are
# left at Cloudflare's defaults. This resource intentionally declares only
# the handful that were deliberately customized (confirmed via the zone
# settings API — these are the only ones with a non-null `modified_on`):
#
#   - ssl: "strict" (Full strict mode — origin must present a valid cert)
#   - always_use_https: "on"
#   - security_header: HSTS enabled, max_age 180 days
#
# `cloudflare_zone_settings_override` is unusual among Cloudflare resources:
# it doesn't represent a creatable/deletable object, it represents the
# current state of zone-wide settings. Terraform will only ever modify the
# settings explicitly listed in the `settings` block below — anything
# omitted is left alone (read but not managed), so this resource is safe to
# scope down to just what's actually been customized rather than mirroring
# every default.

resource "cloudflare_zone_settings_override" "purrmeowca" {
  zone_id = var.zone_id

  settings {
    ssl               = "strict"
    always_use_https  = "on"

    security_header {
      enabled            = true
      max_age            = 15552000 # 180 days, matches live value
      include_subdomains = false
      preload            = false
      nosniff            = false
    }
  }
}
