# purrmeowca-infra

Terraform configuration for the Cloudflare-side infrastructure behind
[purrmeowca.com](https://purrmeowca.com) — DNS records today, with Workers
Static Assets / R2 / KV planned as a follow-up once the DNS layer is
comfortable.

This repo intentionally contains **no secrets**. The Cloudflare API token is
supplied via an environment variable at apply time and is never written to
any committed file. State is local (`terraform.tfstate`, gitignored) since
this is a single-operator project; see `provider.tf` for notes on moving to
a remote backend if that ever changes.

## Prerequisites

- Terraform >= 1.7.0
- A Cloudflare API Token with at least `Zone:DNS:Edit` and `Zone:Zone:Read`
  for the `purrmeowca.com` zone. Create one at
  <https://dash.cloudflare.com/profile/api-tokens>.

## Setup

```bash
export CLOUDFLARE_API_TOKEN="paste-your-token-here"
terraform init
```

## First-time import

These DNS records already exist in the live zone (they were created
manually before this repo existed). They must be imported into Terraform
state before running `plan`/`apply` — otherwise Terraform will try to
create duplicates and Cloudflare will reject them.

```bash
terraform import cloudflare_record.apex_aaaa        796252eba98cabb88f25f9f5e65d8a72/8e396e91b1478659418d7123352669de
terraform import cloudflare_record.www_aaaa          796252eba98cabb88f25f9f5e65d8a72/f6514dc4aa47c0dfcbe1f0af544caa57
terraform import cloudflare_record.media_cname        796252eba98cabb88f25f9f5e65d8a72/f870b978a9677fbf70e67724fdf8867a
terraform import cloudflare_record.mx_route1         796252eba98cabb88f25f9f5e65d8a72/125545c31f3443b1e58dbde7f30a1205
terraform import cloudflare_record.mx_route2         796252eba98cabb88f25f9f5e65d8a72/ba2a498fe323ecc2350b91e3ab532b03
terraform import cloudflare_record.mx_route3         796252eba98cabb88f25f9f5e65d8a72/221800599e4b7a46a3ad5cd624b0eb5a
terraform import cloudflare_record.mx_send_ses        796252eba98cabb88f25f9f5e65d8a72/c395109c8bae0943ac672aced071fee1
terraform import cloudflare_record.spf_apex          796252eba98cabb88f25f9f5e65d8a72/b26f38b37e815f236d3791b9aef38859
terraform import cloudflare_record.spf_send          796252eba98cabb88f25f9f5e65d8a72/b9d6227ddfc9f83e238ac1faacbcc4e9
terraform import cloudflare_record.dmarc             796252eba98cabb88f25f9f5e65d8a72/1f3c4d7c4bf7b56bbb0986ffb631ebfe
terraform import cloudflare_record.dkim_cloudflare    796252eba98cabb88f25f9f5e65d8a72/107dbc1c02e7f2ac16778932a98dd4d5
terraform import cloudflare_record.dkim_resend       796252eba98cabb88f25f9f5e65d8a72/83ee08d77860f04abfa604402e4d6fc3
```

After every import, run:

```bash
terraform plan
```

**It must show "No changes."** If it shows a diff for a record you just
imported, the `.tf` definition doesn't byte-for-byte match the live value
(easy to get wrong on long TXT records like DKIM keys) — fix the `.tf` file
to match what `plan` says is the real value, don't force-apply a guess.

## Day-to-day use

```bash
terraform plan    # review changes before applying
terraform apply   # apply after reviewing the plan
```

Add new DNS records by adding a new `cloudflare_record` resource block in
`dns.tf`, then `terraform apply` — no import needed for genuinely new
records, only for things that already exist outside Terraform's knowledge.

## Layout

```
provider.tf    # Terraform + Cloudflare provider configuration
variables.tf   # zone_id, domain
dns.tf         # all DNS record resources
```

## Roadmap

- [x] Workers Custom Domain attachments (apex + www)
- [x] R2 buckets (media + reviews)
- [x] Workers KV namespaces (ip-cache + sms-state)
- [x] Zone security settings (SSL mode, HTTPS redirect, HSTS)
- [x] Turnstile widget configuration (bot protection on review/contact forms)
- [ ] Cron Trigger for the Worker's `scheduled` handler (currently
      configured via wrangler.toml, not imported here)
- [ ] Consider a remote backend if a second operator or machine starts
      applying changes
