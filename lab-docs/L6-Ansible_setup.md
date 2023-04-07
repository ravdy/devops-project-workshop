
# Setup Ansible
1. Install Ansible on amazon Linux 2023 using pip. 
   ```sh 
   sudo yum -y install python-pip
   pip install ansible
   ```

2. Add Jenkins master and slave as hosts 
Add jenkins master and slave private IPs in the inventory file 
in this case, we are using /opt is our working directory for Ansible. 
   ```
    [jenkins-master]
    18.209.18.194
    [jenkins-master:vars]
    ansible_user=ec2-user
    ansible_ssh_private_key_file=/opt/dpo.pem
    [jenkins-slave]
    54.224.107.148
    [jenkins-slave:vars]
    ansible_user=ec2-user
    ansible_ssh_private_key_file=/opt/dpo.pem
   ```

3. Test the connection  
   ```sh
   ansible -i hosts all -m ping 
   ```
