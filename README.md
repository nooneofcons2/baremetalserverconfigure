# Note: Every config/playbook on this project was tested by Osman on a homelab Ubuntu server
# I was able to retrieve nginx logs on Grafana dashboard

# Bare Metal Remote Server configure

- I am first pinging to remote server to test the connection
- I am allowing (enabling) ports: 80,443,3100,9095 and protocols (tcp) needed through UFW
- Installing and configuring nginx webserver
- Setting up loki on the remote server for log shipping to already installed Grafana instance localhost:3000 for log views through UI
- Setting up promtail for log collection and sending them to the local loki instance localhost:3100
- Finally setting up the devops and bob user needed


# To use this script against your own remote servers
- Change ansible_user in inventory to your remote user
- Change ansible_ssh_private_key_file inventory to ssh private key
- Change ansible_host=<your remote machine ip address> in the inventory file, you can retrieve with ifconfig
- For additional servers, add  more servers 
<remote_server_2> 
<remote_server_3> 

# If you want to run sudo command on the remote servers you have 2 options
# 1. You will pass your remote server password to ansible vault, and add --ask-vault-pass flag to run playbook command 
- ansible-vault create sudo_password.yml 
- ansible-playbook -i inventory allplaybooks.yml --ask-vault-pass
- sudo_password.yml is empty intentionally you have to generate yours following above and add your remote server password

# 2. or set up no password needed rule for the remote servers if they are isolated and secure work envs
# concept

- create a playbook passwordless_sudo.yml
##############################################################################
---
- name: Configure passwordless sudo
  hosts: servers
  become: yes
  tasks:
    - name: Ensure the sudoers file allows passwordless sudo 
      lineinfile:
        path: /etc/sudoers
        line: "{{ ansible_user }} ALL=(ALL) NOPASSWD: ALL"
        validate: '/usr/sbin/visudo -cf %s'
###############################################################################
- configure above using ansible-playbook -i inventory allplaybooks.yml  --ask-become-pass
- then in the Makefile, change command to (remove ) < --ask-vault-pass > flag
- final command for password ansible run: 
- ansible-playbook -i inventory main-playbook.yml  



# To run the whole project at once use make Makefile
- command: make allplaybooks 

