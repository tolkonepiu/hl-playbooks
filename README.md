# Ansible Playbooks

This repository contains a collection of Ansible playbooks and roles designed to
automate the configuration and management of my infrastructure.

> [!WARNING]
>
> These playbooks are provided as-is and should be used at your own risk. While
> they are designed to be reliable, there is no guarantee they will work in all
> environments.  
> It is recommended to use this repository primarily for learning and
> understanding Ansible, and to thoroughly test any modifications before
> applying them to your systems.

## K3s Kubernetes Cluster

This repository includes playbooks for setting up and managing a K3s Kubernetes
cluster:

- **Setup**: `playbooks/k3s_site.yml` - Configures server and agent nodes
- **Upgrade**: `playbooks/k3s_upgrade.yml` - Safely upgrades K3s version on all
  nodes
- **Reset**: `playbooks/k3s_reset.yml` - Removes K3s from all nodes

### System Requirements

Before deploying the K3s cluster, ensure your systems meet the following
requirements:

- Debian-based Linux distribution (Debian, Ubuntu, or Armbian)
- At least 2 nodes for the server group (for HA setup)
- IP forwarding enabled (automatically configured by the playbooks)
- Proper cgroup configuration for container orchestration
- Network connectivity between all cluster nodes

The prerequisites are automatically checked and configured by the `k3s_prereq`
role during deployment.

### Kubeconfig Export

The roles will automatically export the kubeconfig from the first server node to
your local machine at `~/.kube/config`. When using a multi-server setup, all
server IP addresses will be added to the kubeconfig for high availability. A
timestamped backup of any existing kubeconfig will be created before
overwriting.

This behavior can be controlled with the following variables:

```yaml
# Enable/disable kubeconfig export (default: true)
k3s_server_export_kubeconfig: true

# Path where to save the kubeconfig on the control machine
k3s_server_local_kubeconfig_path: "~/.kube/config"

# Path to the kubeconfig on the server node
k3s_server_kubeconfig_path: "/etc/rancher/k3s/k3s.yaml"
```

### High Availability Setup

The K3s playbooks support high availability (HA) mode with multiple server
nodes:

- The first server initializes the cluster and database
- Additional servers join as HA servers, connecting to the same database
- Server nodes run the etcd database internally for state management
- Agent nodes connect to the server nodes with a shared token
- Rolling upgrades are supported with proper node drain/cordoning

The roles automatically detect the first server node and establish it as the
initial server, while remaining servers are configured to join the cluster. For
proper HA operation, at least two server nodes are required.

### Inventory Configuration

For the K3s playbooks to work correctly, you need to properly structure your inventory. The inventory should define the following groups:

- `k3s_cluster`: Contains all K3s nodes (both servers and agents)
- `k3s_server`: Contains all server nodes that will run the Kubernetes control plane
- `k3s_agent`: Contains all agent nodes that will only run workloads

Example inventory structure:

```ini
[k3s_server]
k3s-server-1 ansible_host=192.168.1.101
k3s-server-2 ansible_host=192.168.1.102
k3s-server-3 ansible_host=192.168.1.103

[k3s_agent]
k3s-agent-1 ansible_host=192.168.1.201
k3s-agent-2 ansible_host=192.168.1.202
k3s-agent-3 ansible_host=192.168.1.203

[k3s_cluster:children]
k3s_server
k3s_agent
```

You can also define variables specific to each node or group in your inventory or in separate variable files. This allows for customizing settings like node labels, taints, or specific K3s installation parameters.

### Usage

To apply a playbook to your infrastructure, use the standard Ansible commands:

```bash
# Set up the K3s cluster
ansible-playbook playbooks/k3s_site.yml

# Upgrade K3s to a newer version
ansible-playbook playbooks/k3s_upgrade.yml

# Remove K3s from all nodes
ansible-playbook playbooks/k3s_reset.yml
```

## Server Configuration

The repository includes several roles for configuring and maintaining servers:

### Unattended Upgrades

The `unattended_upgrades` role configures automatic system updates on
Debian-based systems. It ensures security updates are applied regularly without
manual intervention.

### ZSH Setup

The `setup_zsh` role installs and configures ZSH as the default shell with a
customizable configuration:

- Installs ZSH and Git prerequisites
- Clones a specified dotfiles repository
- Creates a standardized shell environment across all servers

### APT Sources Management

The `manage_apt_sources` role handles the configuration of APT repositories.

### Host File Management

The `update_hosts` role ensures consistent `/etc/hosts` configuration across all
servers.

## Repository Structure

```text
playbooks/                 # Main playbook entry points
roles/                     # Individual role definitions
  ├── k3s_agent/           # K3s agent node configuration
  ├── k3s_prereq/          # Prerequisites for K3s installation
  ├── k3s_server/          # K3s server node configuration
  ├── k3s_upgrade/         # K3s version upgrade handling
  ├── manage_apt_sources/  # APT repository management
  ├── setup_zsh/           # ZSH shell configuration
  ├── unattended_upgrades/ # Automatic system updates
  └── update_hosts/        # Host file management
inventory/                 # Host definitions and grouping
```

---

## License

This repository is licensed under the [MIT License](LICENSE).
