# smart-lead-test

### Here is the Architecture diagram for this test

![Screenshot](./screenshot/diagram.png)

**Step-1:**

Firstly i cloned your nodejs repo and created my custom Dockerfile which is a multi-stage dockerfile.


**Step-2:**

Then i created s3 bucket for storing our tf-state files over there.


**Step-2:**

After that i created terraform scripts for RDS, ECS-ECR, WAF, S3, and Cloudfront. you can got to each folder and apply these commands:-


```
terraform init
```

```
terraform plan  -out plan.out
```

```
terraform apply plan.out 

```


**Step-3:**  OUTPUTS:-

Here you can see all resources outputs as below:-

**ECR**

![Screenshot](./screenshot/ecr.png)

**ECS**
![Screenshot](./screenshot/ecs-cluster.png)

![Screenshot](./screenshot/svc.png)

**nodejs**

![Screenshot](./screenshot/nodejs-logs.png)


**s3 and cloudfront**

![Screenshot](./screenshot/s3-bucket.png)

![Screenshot](./screenshot/cloudfront.png)

**cloudwatch dashboard & Alrams**

![Screenshot](./screenshot/dashboard.png)

![Screenshot](./screenshot/sns.png)

![Screenshot](./screenshot/subs.png)

![Screenshot](./screenshot/subs2.png)

![Screenshot](./screenshot/alaram.png)

**budget-saving-plan**

![Screenshot](./screenshot/budget.png)

![Screenshot](./screenshot/saving-plan.png)


**Step-4:** To destroy use this comman:-

```
terraform destroy
```

