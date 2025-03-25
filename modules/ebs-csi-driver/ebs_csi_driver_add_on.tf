# Deploy the AWS EBS CSI Driver as an Add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = var.eks_cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.40.1-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  # resolve_conflicts = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.ebs_csi_role.arn

  depends_on = [aws_iam_role_policy_attachment.ebs_csi_attach]
}

resource "kubernetes_manifest" "ebs_snapshot_class" {
  manifest = {
    apiVersion = "snapshot.storage.k8s.io/v1"
    kind       = "VolumeSnapshotClass"
    metadata = {
      name = "ebs-snap-class"
    }
    driver         = "ebs.csi.aws.com"
    deletionPolicy = "Delete"
  }
  # depends_on = [ null_resource.install_snapshot_controller, null_resource.install_snapshot_crds ]
}

resource "kubernetes_manifest" "cassandra_data_snapshot" {
  manifest = {
    apiVersion = "snapshot.storage.k8s.io/v1"
    kind       = "VolumeSnapshot"
    metadata = {
      name      = "cassandra-data-snapshot"
      namespace = "apigee"
    }
    spec = {
      volumeSnapshotClassName = "ebs-snap-class"
      source = {
        persistentVolumeClaimName = "cassandra-data-apigee-cassandra-default-0"
      }
    }
  }

  depends_on = [kubernetes_manifest.ebs_snapshot_class]
}


# Install Snapshot CRDs
# resource "null_resource" "install_snapshot_crds" {
#   provisioner "local-exec" {
#     command = <<EOT
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-6.2/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-6.2/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-6.2/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
#     EOT
#   }
# }

# # Volume Snapshot Controller
# resource "null_resource" "install_snapshot_controller" {
#   provisioner "local-exec" {
#     command = <<EOT
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-6.2/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
#       kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-6.2/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
#     EOT
#   }
# }

