# Turnstile widget for PurrmeowCA's review/contact forms.
#
# `secret` is a computed, sensitive attribute on this resource — Terraform
# will read it into state (where it's protected the same way any other
# sensitive value is), but it's never declared here. The Worker consumes
# the secret via a `wrangler secret put TURNSTILE_SECRET` binding, kept
# entirely separate from this Terraform-managed widget configuration.

resource "cloudflare_turnstile_widget" "reviews" {
  account_id     = var.account_id
  name           = "PurrmeowCA reviews"
  domains        = ["purrmeowca.com", "www.purrmeowca.com"]
  mode           = "managed"
  bot_fight_mode = false
}
