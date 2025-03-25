# Once the EBS CSI driver is installed, define a StorageClass

resource "kubernetes_storage_class" "ebs_sc" {
  metadata {
    name = "apigee-sc"
     annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  parameters = {
    type = "gp3"
    fsType = "ext4"
  }
  reclaim_policy = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  allow_volume_expansion = true

  depends_on = [ aws_eks_addon.ebs_csi_driver ]
}
