{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "public",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('master_ab3') }}
select
    _id,
    customer_type,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_master_hashid
from {{ ref('master_ab3') }}
-- master from {{ source('public', '_airbyte_raw_master') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

