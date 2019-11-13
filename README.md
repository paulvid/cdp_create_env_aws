# CDP Environment creation for AWS
<div align="center">
<img src="https://github.com/paulvid/emr_to_cdp/raw/master/data/cloudera_logo_darkorange.png" width="820" height="100" align="middle">
</div>

# Overview

This set of scripts automates the creationg of all minimal pre-requisites to setup a CDP AWS environment, including:
* AWS environment bucket
* Set of minimal AWS policies
* Set of minimal AWS roles
* CDP environment creation

# Setup

## Pre-requisites


* AWS cli: Configure AWS cli with your credentials and region
* CDP cli: Configure CDP cli with your credentials and region

## Setup


### 1. Clone this repository
```
git clone https://github.com/paulvid/emr_to_cdp.git
```

### 2. Run the following scripts in order


Create AWS S3 bucket:
```
aws_create_bucket.sh <base_dir> <prefix> <region> 
```

Purge AWS policies and roles (optional):
```
aws_purge_roles_policies.sh <base_dir> <prefix> 
```

Create AWS policies:
```
aws_create_policies.sh <base_dir> <prefix>
```

Create AWS roles:
```
aws_create_roles.sh <base_dir> <prefix> <bucket> 
```

Create CDP environment:
```
cdp_create_env.sh <base_dir> <prefix> <credential> <region> <key> 
```

### 3. Verify periodically your environment unstil status says AVAILABLE

```
cdp_describe_env.sh <prefix> 
```

# Authors

**Paul Vidal** - *Initial work* - [LinkedIn](https://www.linkedin.com/in/paulvid/)
