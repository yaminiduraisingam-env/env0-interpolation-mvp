###############################################################################
# REMOTE BACKEND
#
# Points this workflow step's state at the bucket + lock table created by
# terraform-s3-remote-backend/bootstrap. The "workflow/network/" key keeps it
# separate from the standalone terraform-s3-remote-backend/infra deployment,
# which uses "infra/terraform.tfstate" in the same bucket.
###############################################################################

terraform {
  backend "s3" {
    bucket         = "tf-remote-backend-state-013141018419-eu-central-1"
    key            = "workflow/network/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-remote-backend-locks"
    encrypt        = true
  }
}
