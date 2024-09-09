data "aws_route53_zone" "main" {
  name         = "expense.internal"
  private_zone = true
}

data "aws_ami" "main" {
  most_recent = true
  name_regex  = "DevOps-LabImage-RHEL9"
  #name_regex = "b58-golden-image"
  owners     = ["355449129696"]
}

# Steps to make your own ami :
# 1) Use lab image and create instance 
# 2) Install ansible on that node using "pip3.11 install ansible"
# 3) Create an AMI using this and name it as "b58-golden-image"
# 4) Make sure you're the owner, so supply your account-id