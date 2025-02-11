#!/bin/bash

curl -X POST \
    -H "Content-Type: application/json" \
    -d'{"tx_bytes":"CogBCoUBChwvY29zbW9zLmJhbmsudjFiZXRhMS5Nc2dTZW5kEmUKKnNlaTFkZGZra241OWdjbjJ3eXdma2Vqbmc2ZnpxdXRlZGhuNXh1ZHpqOBIqc2VpMWRkZmtrbjU5Z2NuMnd5d2ZrZWpuZzZmenF1dGVkaG41eHVkemo4GgsKBHVzZWkSAzEwMBJkCk4KRgofL2Nvc21vcy5jcnlwdG8uc2VjcDI1NmsxLlB1YktleRIjCiEDyfccgc+MznFwDNwJopFFeHnUR0jwDV3hr06mmtI6qqkSBAoCCAESEgoMCgR1c2VpEgQyMDAwEMCaDBpA6SME5JnP6I+9+speLGI1T8FngynUFwXkdmTJiOyXVCE0Xx+78BrAsg906+X5tUw1vUd0zzUsKyzjUuXU8PjG/g==","mode":"BROADCAST_MODE_SYNC"}' \
    147.46.240.248:32200/cosmos/tx/v1beta1/txs

