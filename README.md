# ECR Repository Lifecycles

Find all existing repositories and add a default repo to them
[push-ecr-lifecycle.sh](https://github.com/dubrowin/ECR-Lifecycles/blob/main/push-ecr-lifecycle.sh)

- Copy the script into Cloudshell
  
```curl -s https://raw.githubusercontent.com/dubrowin/ECR-Lifecycles/main/push-ecr-lifecycle.sh -o push-ecr-lifecycle.sh```

- Make the script executable
  
```chmod +x push-ecr-lifecycle.sh```

- It will go through all enabled regions in your account and push a Lifecycle Policy that any untagged images will be deleted after 14 days.
