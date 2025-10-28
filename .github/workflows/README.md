##################################################################
# Required GitHub Secrets
##################################################################
| Secret Name              |               Description             ------------------------------------------------------------------ |
| `AWS_TERRAFORM_ROLE_ARN` | IAM role ARN with Terraform permissions (VPC, ECS, ALB    RDS, etc.) |

| `AWS_ECR_ROLE_ARN`       | IAM role ARN for ECR & ECS deployment
                        
| `TF_BACKEND_BUCKET`      | S3 bucket name for Terraform state                   
              
| `TF_BACKEND_DYNAMODB`    | DynamoDB table name for state locking       
                       
| `ECS_CLUSTER_NAME`       | ECS cluster name                   
                                
| `ECS_SERVICE_NAME`       | ECS service name                            
                       
| `AWS_ACCOUNT_ID`         | Your AWS account ID (used internally by some ECR steps if needed) 

###################################################################
# Terraform IAM Role (AWS_TERRAFORM_ROLE_ARN):
###################################################################
AmazonEC2FullAccess

AmazonVPCFullAccess

AmazonRDSFullAccess

AmazonECSFullAccess

ElasticLoadBalancingFullAccess

AmazonS3FullAccess

AWSCloudFormationFullAccess

AWSWAFFullAccess

AmazonCloudFrontFullAccess

CloudWatchFullAccess

IAMFullAccess (for role creation; least privilege preferred)

ECR/ECS Deploy Role (AWS_ECR_ROLE_ARN):

AmazonECRFullAccess

AmazonECSFullAccess

CloudWatchFullAccess
