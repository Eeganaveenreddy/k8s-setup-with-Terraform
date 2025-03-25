# Create an IAM Policy for EBS CSI Driver
resource "aws_iam_policy" "ebs_csi_policy" {
  name        = "AmazonEBSCSIDriverPolicy"
  description = "IAM policy for EBS CSI driver"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeVolumesModifications",
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:CreateTags"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTags"
        ]
        Resource = "arn:aws:ec2:*:*:volume/*"
        Condition = {
          StringEquals = {
            "ec2:CreateAction" = "CreateVolume"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume"
        ]
        Resource = "*"
      },
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Resource": "*"
      }
    ]
  })
}
