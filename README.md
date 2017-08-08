# openshift-infratests

This repo covers a set of resources that can be used to test the infrastructure used by an OpenShift platform.

## Storage
The following resources are used to verify storage technology

### Storage IO
Verify the storage IO. 

The `storage-test-template` can be used to verify the IO performance of an available PersistentVolumeClaim. The test uses `dd` to write a 1G temporary file to a directory used to mount the PVC. In addition, a test to a local file (`/var/tmp/test`) is performed to be used as a baseline. The log of the job provides the IO stats for the test. 

Usage:
```
oc process -f storage-test-template.yaml PVC_TARGET=test | oc create -f -
```

The template takes two parameters:
 * `PVC_TARGET` - the name of the PersistentVolumeClaim to test.
 * `TOOLS_IMAGE` - the image spec for the tools image to use, defaults to docker.io/centos/tools.
 * `NUMBER_OF_RUNS` - the number of tests to run, true tests should be run multiple times, but the default for a quick test is just one. 

Note: the `PVC_TARGET` must be available for mounting. If this is a RWO PersistentVolumeClaim then other applications should be stopped before running the test. 
Example output (the first write is to the local directory, the second to the persistent volume):
```
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 3.96049 s, 271 MB/s
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 94.9034 s, 11.3 MB/s
```

The above example demonstrates a local write speed of 271MB/s and a remote write (to PersistentVolume) speed of 11.3 MB/s
