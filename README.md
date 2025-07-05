## Production-Grade (ish) server orchestration with Kamal

This is the architecture of our small cluster:

![Architecture](arch.png)

### Architecture

It creates two servers: `web` where our application lives and `accessories` where our dependencies like databases and caches live.
`web` exposes ports 80, 22 and 443, while `accessories` is not accessible from the outside. Root access is disabled on both machines and only the `kamal` user can SSH into them.

You can create more servers by updating `web_servers_count` or `accessories_count` in `variables.tf`. If there is more than one web server, a load balancer will be created and all the web servers will be added to it.

In case multiple servers of different types are created, the naming will be `web-1`, `web-2`, `accessories-1`, and `accessories-2`, as opposed to `web`, `accessories`, the default naming convention.

> [!IMPORTANT]
> If you are copying this workflow, you should change the SSH keys in `cloudinit/base.yml` to your own.
> It is defined on `ssh_import_id` and imports the SSH keys from your GitHub account.

### Connecting to the servers

After running `terraform apply`, the script will output an SSH configuration that can be copied to your `~/.ssh/config` file. This is to help you connect to servers since accessory servers are not accessible from the outside, you need to use the web server as a jump host. It looks like this:

```ssh-config
ssh_01_web_config = <<EOT
Host web-1
  HostName 167.235.61.121
  User kamal
Host web-2
  HostName 5.75.160.210
  User kamal
EOT
ssh_02_accessories_config = <<EOT
Host accessories-1
  HostName 78.46.225.17
  User kamal
  ProxyJump web-1
Host accessories-2
  HostName 167.235.156.173
  User kamal
  ProxyJump web-1
Host accessories-3
  HostName 128.140.70.80
  User kamal
  ProxyJump web-1
EOT
```

### The machines

All machines are `CX22`: 2 AMD vCPUs, 2 GB of RAM and 40 GB of SSD storage, running Ubuntu 24.04. See `variables.tf` for more details and how to change them.

### Price

The default setup of 1 web server and 1 accessory server will cost you around 9 EUR/month.

### How to use it

1. Clone
2. Create a file `terraform.tfvars` with your credentials, it will look like this:
```terraform
hetzner_api_key = "your-api-key"
github_username = "your-github-username" # Make sure to add your SSH key to your GitHub account
ssh_public_key = "your-ssh-public-key" # The public SSH key you want to use to connect to the Hetzner servers
```
3. Update the `cloudinit/base.yml` file with your SSH keys (line #23)
4. Run `terraform init`
5. Run `terraform plan` (optional)
6. Run `terraform apply`
