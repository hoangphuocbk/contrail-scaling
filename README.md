


1. Create stack:

openstack stack create -t service-instance-autoscale-with-policy.yaml -e service-instance-autoscale-with-policy.env my-contrail

2. Trigger policy action:

openstack stack resource signal my-contrail scaleup_policy
openstack stack resource signal my-contrail scaledown_policy

3. Other commands:

openstack image create --public --container-format bare --disk-format raw --file centos7.qcow2 centos7
openstack flavor create --ram 1024 --disk 20 --vcpus 1 --public medium

