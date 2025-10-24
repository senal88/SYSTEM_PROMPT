#!/bin/bash
# =====================================================
# 🧩 sync_1password_env.sh
# Script automático para sincronizar variáveis .env no 1Password
# =====================================================

# 🔐 Autenticação no 1Password
echo "🔑 Conectando ao 1Password CLI..."
op account add --address my.1password.com   --email "luiz.sena88@icloud.com"   --secret-key "A3-YEBP46-396NV5-RDFNK-7LCQK-A43DB-H4XKC"   --signin <<EOF
Gm@1L#Env@hard
EOF

# ⚙️ Inicializa sessão ativa
eval $(op signin my.1password.com luiz.sena88@icloud.com)

# 🏦 Cria item principal
echo "🏦 Criando item 'Google Cloud Credentials (.env.base64)' no vault_senamfo_local..."
op item create --vault "vault_senamfo_local"   --category "Database"   --title "Google Cloud Credentials (.env.base64)"   --tags "gcp,env,secrets,etl,n8n"   --url "https://console.cloud.google.com/"   "description=Credenciais codificadas do projeto GCP ETL / N8N"

# 🧩 Adiciona variáveis codificadas
echo "📦 Adicionando variáveis codificadas..."
op item edit "Google Cloud Credentials (.env.base64)" --vault "vault_senamfo_local"   "GOOGLE_CLIENT_ID=NTAxMjg4MzA3OTIxLTNscnRxdTVycWNtZm9pY2h0M2NmNWVjbDV0bWEydXUyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29t"   "GOOGLE_PROJECT_ID=Z2NwLWFpLXNldHVwLTI0NDEw"   "GOOGLE_AUTH_URI=aHR0cHM6Ly9hY2NvdW50cy5nb29nbGUuY29tL28vb2F1dGgyL2F1dGg="   "GOOGLE_TOKEN_URI=aHR0cHM6Ly9vYXV0aDIuZ29vZ2xlYXBpcy5jb20vdG9rZW4="   "GOOGLE_CLIENT_SECRET=R09DU1BYLXZsQjdxdzBYNldrd3kzTXVxaXZ1ZWg2MmxsRzk="   "GCP_PRIVATE_KEY=LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRQ2E0S2dIQnk4cnRBRDEKTUZWWjRpeGMzR2lleFNQekl1OUN4RXlRN29EREFKd01ubnpHK05NajI0WVhsQjZUelNkZFhLNTBEbndaWWpwTQozL0wrL2Z4Y3lZY1JKQlNRT3V3clM3bzdJenVqZVR5ZS96cUI5cXl6UVlHamlHNFAwaHB1VTFsY3hDTlJEbHhnCnZFNlBHdUN5MXRlS2dCbVVyMFR4OXcyTlA2amsraENIR3dhQmN0MTI2RG5QUGhhSWo0N2U2dzZZOGR2Wi9ZdkwKeG1TSERZb2dMaFRrOEo3L2R3WXhKMkwzbFJkUDl3ZURudDNGdHdFQmVUYmo3TVdFZHVsV2lDQzcrejlzTUFMYwpJT0JUOHYwZVBqdllFL2lxMldncGt1L254TDVVeXBLOVVlRWhJTWJ2RVlPcFdoUzFCREJDdVdOYnA5OU9NZWx0CmhJRmhOYVBiQWdNQkFBRUNnZ0VBSCsyWlpoMkNpWEZwMHlJY0xsUDBqazQzMlNkT0FuVWN1dmhweW1VSXNXcWkKUU8yNVRuR0VZWHVEZUwvbHo5VjJ2SVg3UnR5bms3b094OE5SUG1VUXpmWVR2S0ppQk52SXpTSW02Y01aSzltMQorQmNvc2hzdXZpT09mSzZHOWdiN3dPdTQyK2xwV0cvcjlsdExuSy9QUzc4RG56OUtScjhkS1A2ajBnOGlHOVhwCk9PUnNzUlR0SEVEVW9DcGJMMFdXMzRjODFOMjRGSHlXNC9VRU9WeEdBemlYWk5oMGlObis0TFBHVnBkUjgxTXAKQ1pLNmg0cHpOV2VTVlRIT21IRkU2dVJiZ3NyU2VkTE1kbUZqVmVoUExWSDZzOXFtanFOMzlpNzF2b3g1UFFqZQpQMldYU0tiV0haUVdQVExmRW9waWFYeFptd3YxWHJUYnV0VHJvK0lqQlFLQmdRRFJIWVBSWjJFS1ZaRVN0VjhSCkdDaE55T281Q1Z1d0pCOHh1aU9WV0ZrcHF1MU5veklzQ2hJUGM4MWxiNVhMbU1ObjBURldrcm9lUkdYUnFoY2MKYndsZkljTVM1ZXFWR2o5dW9zQTkvb0c5U1hackIwUVVtREFjN2d3bmZ4ZDdGdkh4VnF3eFhyMU1lRlJmcFJWKwo2bFRWQjIzTDVKSjJPZVVvYjFidG9zcEJmUUtCZ1FDOW1oWDZtOGwxTTFMTUJGc1diSG5TSFFwWlVMNXRZWTRqCkNHdGZjblE2MzlOTEZ4MEF3dU1ubUFvaDNmUHZmZXRJTjlQcHRMVXd1M05NSDdzVWdZVkdjYmlScW1idWR2REEKNjJyM1hpZmp3bUQ3dFVoNE9UMUpmdklkenZJYkNJWWRkWjZQQUxLU213QjhjN3o4aWtmaGlnSytWSGJKZHo0OQpvWFltUEh4Nk53S0JnUUMvM05hdThLMEdjRSswM0pnbTlRVTFxUnZOelJwRTJEK092bndiY0g0T1R2ZC9malp3ClZhVVFiRzJObmYzUVdZOGYxNzN1OHB5MVhJZ1hBSHBINmxDczZpc3pVYVFUdll0cGxRWFJXNHZxQWxjV0NBcWMKNHExeVBhOEZKZ1NET1NBdkVCalpDMVdmcmQrc0NhbFpVdU1XdWNReGlMd2dvU255R1lXbWJ2QW5lUUtCZ0NLMApmYWx0c3FaOVNuNkZuWmF4TEd0RlhZdVR1QWVWZjhyeDA1V1pBYVYxS3R2bjB5czhnUS9TU0tpQ1ZCQldZQ2JMCjhVSXFEYkJwMzJUanVmNjY1b1pLY3BwWE1wZ2J0VjNhdWEybDBtOWlPUlpaekhZVkpCNjcyZDJTNzhYNi9YR1AKQWdMekFiek1HbjZ0UUw2SklUY3JaKzBtME1kM3lEREh5VFNlaGJwcEFvR0FONHhYdkxVUVJNL240NExnbXJoZApvWUVNS2VEL3M0V2RCdm02a1B1RllXdlN6MlpHSkZtRHYzKzh3RGZmcXV0cmQwSko0SWJmWllDOWhBLzVqK2RNClVVZkh4N1pLaHBOdDN4S1FIU0YveE51Snl2Y3Q1RkdMaUg1VlZPWlJJZGNZUENlaTBNRGRhcHI1am9CWlFnelYKZ0d1K3p4SG1JY24zbktzQXdrN0FVTVU9Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0="

# ✅ Confirmação final
echo "✅ Variáveis .env base64 foram salvas com sucesso no vault 'vault_senamfo_local'."
