resource "aws_s3_bucket" "bucket-for-static-web" {
  bucket = "bucket-for-static-web"
  acl = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket-for-static-web.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.myOAI.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "mybucketpolicy" {
  bucket = aws_s3_bucket.bucket-for-static-web.id
  policy = data.aws_iam_policy_document.s3_policy.json

# Can be used when we want to use a policy from our template files
#  policy = templatefile("./templates/policy.json", { arn = "${aws_s3_bucket.bucket-for-static-web.arn}" })
}
