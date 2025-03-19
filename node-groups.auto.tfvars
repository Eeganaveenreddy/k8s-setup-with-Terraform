node_groups = {
    apigee-data = {
        desired_size = 1
        max_size = 1
        min_size = 1
        instance_types = ["t3.2xlarge"]
         labels = {
            role = "apigee-data"
        }
    }
    apigee-runtime = {
        desired_size = 2
        max_size = 2
        min_size = 2
        instance_types = ["t3.2xlarge"]
        labels = {
            role = "apigee-runtime"
        }
    }
}