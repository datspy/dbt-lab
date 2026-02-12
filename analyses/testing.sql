-- This is to test the environment variable
{% set schema_name=env_var('DBT_PROD_SCHEMA') %}
select * 
from {{ schema_name }}.activity