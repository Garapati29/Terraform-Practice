resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-5769"
  tags = {
    Name = "MyS3Bucket"
  }
}
