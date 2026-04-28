{% docs customer_id %}
Surrogate key identifying a single customer across the jaffle-shop
business. Stable across staging and marts; downstream models join on
this key. Never null in marts; staging may carry nulls when source
records are mid-onboarding.
{% enddocs %}

{% docs customer_email %}
Primary email address used for account login, receipts, and marketing
opt-ins. Treated as PII and tagged accordingly — see the policy pack at
`.datalex/policies/jaffle.policy.yaml` for the classification rule.
{% enddocs %}

{% docs order_id %}
Surrogate key identifying a single customer order. One row per order in
`fct_orders` and one row per order line in `order_items`.
{% enddocs %}

{% docs order_total %}
Order total in USD, including tax. Computed downstream of the staging
layer; the staging models carry `subtotal` instead.
{% enddocs %}

{% docs ordered_at %}
Timestamp (UTC) when the customer placed the order. Used as the grain
column for `fct_orders` and as the time spine join key.
{% enddocs %}
