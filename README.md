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

## Table of Contents

- [Overview](#overview)
- [Playbooks](#playbooks)
- [Roles](#roles)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [License](#license)

---

## Overview

This repository is built to streamline the configuration of various systems in a
consistent and repeatable way. It supports multiple groups of hosts defined in
the inventory.

The playbooks ensure that all hosts are properly configured, updated, and
aligned with the desired state.

---

## Playbooks

### `setup-all.yml`

The primary playbook that orchestrates the configuration of all hosts. It
includes the following roles:

- **`update_hosts`**: Updates `/etc/hosts` and ensures proper hostname
  resolution.
- **`manage_apt_sources`**: Configures APT repositories and mirrors.
- **`unattended_upgrades`**: Enables automatic security updates.
- **`setup_zsh`**: Installs Zsh, configures a custom Zsh environment, and sets
  up shell preferences.

---

## Roles

Each role is modular and reusable. Below are the main roles included in this
repository:

1. **`update_hosts`**:

   - Updates `/etc/hosts` with dynamic and local entries.
   - Ensures hostname consistency across the infrastructure.

1. **`manage_apt_sources`**:

   - Manages `/etc/apt/sources.list`.
   - Configures APT mirrors and sources for different distributions (Ubuntu,
     Armbian).

1. **`unattended_upgrades`**:

   - Enables and configures automatic updates.

1. **`setup_zsh`**:
   - Installs Zsh and configures the shell with a custom `ZDOTDIR`.

---

## Getting Started

### Prerequisites

- **Ansible**: Ensure you have Ansible installed on your control machine.
- **Inventory**: Prepare an inventory file that defines your hosts and groups.

### Installation

Clone the repository:

```bash
git clone https://github.com/tolkonepiu/ansible-setup.git
cd ansible-setup
```

---

## Dependencies

### Install Required Collections

Ensure you have all required collections installed before running the playbooks.
Use the following command:

```bash
ansible-galaxy collection install -r requirements.yml
```

This will install all dependencies specified in the `requirements.yml` file.

---

## Usage

### Run the Playbook

Run the main playbook to configure all hosts:

```bash
ansible-playbook -i inventory.ini playbooks/setup-all.yml
```

### Test Connectivity

Check if Ansible can connect to all hosts:

```bash
ansible all -i inventory.ini -m ping
```

---

## Inventory Example

Below is an example inventory file:

```ini
[servers]
node-1 ansible_host=10.0.0.1
node-2 ansible_host=10.0.0.2

[all:vars]
ansible_user=root
```

---

## License

This repository is licensed under the [MIT License](LICENSE).
