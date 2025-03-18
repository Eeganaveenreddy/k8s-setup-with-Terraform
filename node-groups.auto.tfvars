node_groups = {
    apigee-data = {
        desired_size = 3
        max_size = 4
        min_size = 3
        instance_types = ["t3.xlarge"]
    }
    apigee-runtime = {
        desired_size = 3
        max_size = 5
        min_size = 3
        instance_types = ["t3.xlarge"]
    }
}