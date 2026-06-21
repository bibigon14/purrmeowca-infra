# Workers KV namespaces used by the "purrmeowca" Worker.
#
# Terraform owns the namespace containers only — not their contents. The
# Worker reads/writes individual keys at runtime (e.g. caching geolocation
# lookups, tracking SMS conversation state); that's application data, not
# infrastructure, and isn't reflected here.
#
# Binding names in the Worker's wrangler config differ from these namespace
# titles — `IP_CACHE` binds to the "ip-cache" namespace, `SMS_STATE` binds
# to "sms-state". The binding-to-namespace wiring lives in wrangler.toml
# alongside the Worker code, not here.

resource "cloudflare_workers_kv_namespace" "ip_cache" {
  account_id = var.account_id
  title      = "ip-cache"
}

resource "cloudflare_workers_kv_namespace" "sms_state" {
  account_id = var.account_id
  title      = "sms-state"
}
