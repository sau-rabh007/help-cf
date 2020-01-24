resource "aws_s3_bucket" "faro-help-staging-backend-bucket-storage-production" {
  bucket = "faro-help-staging-backend-bucket-storage-production"
  acl    = "private"

  tags = {
    Name = "${var.tag_name}"
    Environment = "${var.tag_Environment}"
    Project = "${var.tag_Project}"
  }
}
