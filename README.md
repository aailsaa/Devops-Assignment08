## assignment description:

A. Create a custom AWS AMI using Packer that contains the following:

Amazon Linux
Docker
Your SSH public key is set so you can login using your private key
B. Terraform scripts to provision AWS resources:

VPC, private subnets, public subnets, all necessary routes (use modules!) 
1 bastion host in the public subnet (accept only your IP on port 22) 
6 EC2 instances in the private subnet using your new AMI created from Packer

## Setup Instructions

### 1. Build the Docker AMI

paste in your terminal:

cd packer <\br>
packer init docker-ami.pkr.hcl  <\br>
packer build docker-ami.pkr.hcl <\br>

you will get lots of output like this:

<img width="2323" height="1670" alt="image" src="https://github.com/user-attachments/assets/1d4250d5-30ec-44fb-804d-7b66f8633232" />

eventually at the end of the output your ami should be printed:

<img width="2454" height="1679" alt="image" src="https://github.com/user-attachments/assets/0950c916-fa5f-40a5-bd27-8e15e6c6a77f" />

This will generate a new AMI with Docker installed. Note the new AMI ID printed by Packer.

### 2. Deploy Infrastructure with Terraform

paste in your terminal: 

cd ../terraform
terraform init
terraform apply

Provide yes when prompted to create resources.

<img width="2199" height="1677" alt="image" src="https://github.com/user-attachments/assets/70eca8aa-49c2-478d-b0b5-b3d21911c043" />


Terraform will output:
bastion_ip – public IP of the Bastion host.
private_ips – private IPs of your EC2 instances.

### 3. SSH into the Bastion Host

in your terminal:

ssh -i <your-key>.pem ec2-user@<bastion_ip>

Replace <your-key> with your private key file and <bastion_ip> with the Bastion host IP.

you should get this output:

<img width="1300" height="586" alt="image" src="https://github.com/user-attachments/assets/3e98a43c-58e8-454a-a052-d724c0243ecb" />


### 4. Connect to Private Instances from Bastion

First copy your pem file to the bastion host so that you can ssh into your private instances.

Once on the Bastion host, use SSH agent forwarding or the private key to reach private instances:

ssh -i <your-key>.pem ec2-user@<private_ip>

You should now be connected to the private instance. Docker should be available:

<img width="1417" height="433" alt="image" src="https://github.com/user-attachments/assets/b7d457ca-04b5-4734-86fa-eb9f3a34e799" />




