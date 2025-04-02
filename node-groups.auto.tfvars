node_groups = {
    hub-cluster = {
        cluster_name  = "eks-cluster-1"
        desired_size = 1
        max_size = 2
        min_size = 1
        instance_types = ["t3.medium"]
         labels = {
            # "role" = "apigee-data"
            # "cloud.google.com/gke-nodepool" = "apigee-data"
        }
    }
    spoke-1 = {
        cluster_name  = "eks-cluster-2"
        desired_size = 1
        max_size = 2
        min_size = 1
        instance_types = ["t3.medium"]
        labels = {
            # "role" = "apigee-runtime"
            # "cloud.google.com/gke-nodepool" = "apigee-runtime"
        }
    }

    spoke-2 = {
        cluster_name  = "eks-cluster-3"
        desired_size = 1
        max_size = 2
        min_size = 1
        instance_types = ["t3.medium"]
        labels = {
            # "role" = "apigee-runtime"
            # "cloud.google.com/gke-nodepool" = "apigee-runtime"
        }
    }
}

# node_groups = {
#     argo-mutli-clsuter = {
#         desired_size = 2
#         max_size = 2
#         min_size = 1
#         instance_types = ["t3.medium"]
#     }
# }
