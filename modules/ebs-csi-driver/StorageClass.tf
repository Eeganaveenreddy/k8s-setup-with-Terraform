# Once the EBS CSI driver is installed, define a StorageClass

resource "kubernetes_storage_class" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  parameters = {
    type = "gp3"
    fsType = "ext4"
  }
  reclaim_policy = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  depends_on = [ aws_eks_addon.ebs_csi_driver ]
}
