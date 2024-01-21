## Production-Grade (ish) server orchestration with Kamal

This is the architecture of our small cluster:

![Architecture](arch.png)

### Architecture

It creates two servers: `web` where our application lives and `accessories` where our dependencies like databases and caches live.
`web` exposes ports 80, 22 and 443, while `accessories` is not accessible from the outside.

### The machines

Both machines are `CPX11`: 2 AMD vCPUs, 2 GB of RAM and 50 GB of SSD storage, running Ubuntu 20.04. See `variables.tf` for more details and how to change them.

### Price

This setup will cost you around 10 EUR/month.
