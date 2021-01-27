# terraform-vault-gcp
Automated Vault deployment on GCP Compute Instances with Terraform and Ansible.

## How to Use

```bash
$ cat <<EOF > terraform.tfvars
project = "my_gcp_project"
EOF

$ export GOOGLE_CREDENTIALS=path/to/sa.json

$ terraform init

$ terraform apply
...
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

consul_servers = [
  ...
]
vault_servers = [
  ...
]
```