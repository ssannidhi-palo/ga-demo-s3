
### `Create S3 static hosting website`

You need an IAM user with programmatic access and S3FullAccess permission. Run below script to provision a S3 static hosting website.

```
$ hosting/website.sh create

Enter a name (to create S3 hosting website): <input a name>
Enter the Access Key ID: <Input aws access key id>
Enter the Secret Access Key: <Input aws secret access key>

 Creating a S3 hosting website
make_bucket: training-demo-<name>

 Your website Url: http://training-demo-<name>.s3-website.ap-southeast-1.amazonaws.com
```

 ### `Cleanup S3 static hosting website`

You need an IAM user with programmatic access and S3FullAccess permission. Run below script to provision a S3 static hosting website.

```
 $ hosting/website.sh cleanup

 Enter a name (to cleanup S3 hosting website): <input a name>
 Enter the Access Key ID: <Input aws access key id>
 Enter the Secret Access Key: <Input aws secret access key>
  
  Cleaning up 
  ...
  Cleanup complete!
```

  ### `Github Actions Cheat Sheet`

  https://resources.github.com/downloads/GitHub_Actions-Cheat-Sheet-One-Pager.pdf

  ### `Github Actions Workflow Templates`

  Refer to the workflow-templates folder in this repo for various github actions workflow files
