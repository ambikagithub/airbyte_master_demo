{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('master_ab3') }}
{% set customer_domains = ["hpe.com", "arubanetworks.com", "hpe.hr","hpecds.com","jpn.hpe.com","hpecds.com"] %}

select
    _id,
    customer_domain,
    {% for customer_domain in customer_domains %}
    (case when customer_domain = '{{customer_domains}}' then 'Internal' end) as {{customer_type}}
    {% if not loop.last %},{% endif %}
    {% endfor %},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_master_hashid
from {{ ref('master_ab3') }}
-- master from {{ source('public', '_airbyte_raw_master') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

