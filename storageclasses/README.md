# Ionir Kubernetes-Native Storage


## Ionir Storage Classes Examples

Ionir supports the creation of new storage classes to optimize the volume performance for different applications.

To create a new storage class, refer to Kubernetes StorageClass documentation:<br>
https://kubernetes.io/docs/concepts/storage/storage-classes/

**Ionir storage class requires the following to be defined in the storage class:**

- provisioner: Determines what volume plugin is used for provisioning the PV. For Ionir this
needs to be set to “ionir”

- type: Specify the volume type. Supported types are: “ext4”, “xfs” and “block” (raw block
device). If not specified, the default value is “ext4”.

- blockSize: Specify the volume block size. Supported sizes are 4k and 16k. If not specified,
the default value is 16k.

#
visit us on www.ionir.com
