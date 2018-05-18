#/bin/bash

CUR_PWD="$( cd "$(dirname "$0")"; pwd -P )"
CONFIG_FILE="${CUR_PWD}/config"

[ -d ${CUR_PWD}/networks ] || mkdir -p ${CUR_PWD}/networks
[ -d ${CUR_PWD}/config-drives/vm1-config ] || mkdir -p ${CUR_PWD}/config-drives/vm1-config
[ -d ${CUR_PWD}/config-drives/vm2-config ] || mkdir -p ${CUR_PWD}/config-drives/vm2-config
[ -d /var/lib/libvirt/images/vm1 ] || mkdir -p  /var/lib/libvirt/images/vm1
[ -d /var/lib/libvirt/images/vm2 ] || mkdir -p  /var/lib/libvirt/images/vm2
[ -d /home/jenkins/.ssh ] || mkdir -p /home/jenkins/.ssh

EXTERNAL_NET_NAME=$(grep EXTERNAL_NET_NAME ${CONFIG_FILE} | awk -F= '{print $2}')
EXTERNAL_NET_MASK=$(grep EXTERNAL_NET_MASK ${CONFIG_FILE} | awk -F= '{print $2}')
EXTERNAL_NET_TYPE=$(grep EXTERNAL_NET_TYPE ${CONFIG_FILE} | awk -F= '{print $2}')
EXTERNAL_NET=$(grep -w EXTERNAL_NET ${CONFIG_FILE} | awk -F= '{print $2}' | grep -E ^[0-9])
EXTERNAL_NET_HOST_IP=$(grep EXTERNAL_NET_HOST_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
EXTERNAL_NET_HOST_IP=${EXTERNAL_NET}.${EXTERNAL_NET_HOST_IP}
VM1_EXTERNAL_IP=$(grep VM1_EXTERNAL_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM1_EXTERNAL_IP=${EXTERNAL_NET}.${VM1_EXTERNAL_IP}

echo EXTERNAL_NET_NAME=${EXTERNAL_NET_NAME}
echo EXTERNAL_NET_MASK=${EXTERNAL_NET_MASK}
echo EXTERNAL_NET_TYPE=${EXTERNAL_NET_TYPE}
echo EXTERNAL_NET=${EXTERNAL_NET}
echo EXTERNAL_NET_HOST_IP=${EXTERNAL_NET_HOST_IP}
echo VM1_EXTERNAL_IP=${VM1_EXTERNAL_IP}

INTERNAL_NET_NAME=$(grep INTERNAL_NET_NAME ${CONFIG_FILE} | awk -F= '{print $2}')
INTERNAL_NET=$(grep -w INTERNAL_NET ${CONFIG_FILE} | awk -F= '{print $2}' | grep -E ^[0-9])
INTERNAL_NET_MASK=$(grep INTERNAL_NET_MASK ${CONFIG_FILE} | awk -F= '{print $2}')
INTERNAL_NET_IP=$(grep INTERNAL_NET_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
INTERNAL_NET_IP=${INTERNAL_NET}.${INTERNAL_NET_IP}
echo INTERNAL_NET_NAME=${INTERNAL_NET_NAME}
echo INTERNAL_NET_MASK=${INTERNAL_NET_MASK}
echo INTERNAL_NET=${INTERNAL_NET}
echo INTERNAL_NET_IP=${INTERNAL_NET_IP}

MANAGEMENT_NET_NAME=$(grep MANAGEMENT_NET_NAME ${CONFIG_FILE} | awk -F= '{print $2}')
MANAGEMENT_NET_MASK=$(grep MANAGEMENT_NET_MASK ${CONFIG_FILE} | awk -F= '{print $2}')
MANAGEMENT_NET=$(grep -w MANAGEMENT_NET ${CONFIG_FILE} | awk -F= '{print $2}' | grep -E ^[0-9])
MANAGEMENT_HOST_IP=$(grep MANAGEMENT_HOST_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
MANAGEMENT_HOST_IP=${MANAGEMENT_NET}.${MANAGEMENT_HOST_IP}
MANAGEMENT_NET_IP=$(grep MANAGEMENT_NET_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
MANAGEMENT_NET_IP=${MANAGEMENT_NET}.${MANAGEMENT_NET_IP}
echo MANAGEMENT_NET_NAME=${MANAGEMENT_NET_NAME}
echo MANAGEMENT_NET_MASK=${MANAGEMENT_NET_MASK}
echo MANAGEMENT_NET=${MANAGEMENT_NET}
echo MANAGEMENT_HOST_IP=$(echo ${MANAGEMENT_HOST_IP})
echo MANAGEMENT_NET_IP=${MANAGEMENT_NET_IP}

VM1_NAME=$(grep VM1_NAME ${CONFIG_FILE} | awk -F= '{print $2}')
VM2_NAME=$(grep VM2_NAME ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM1_NAME=${VM1_NAME}
echo VM2_NAME=${VM2_NAME}

VM1_EXTERNAL_IF=$(grep VM1_EXTERNAL_IF ${CONFIG_FILE} | awk -F= '{print $2}')
VM1_INTERNAL_IF=$(grep VM1_INTERNAL_IF ${CONFIG_FILE} | awk -F= '{print $2}')
VM1_MANAGEMENT_IF=$(grep VM1_MANAGEMENT_IF ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM1_EXTERNAL_IF=${VM1_EXTERNAL_IF}
echo VM1_INTERNAL_IF=${VM1_INTERNAL_IF}
echo VM1_MANAGEMENT_IF=${VM1_MANAGEMENT_IF}

VM1_INTERNAL_IP=$(grep VM1_INTERNAL_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM1_INTERNAL_IP=${INTERNAL_NET}.${VM1_INTERNAL_IP}
echo VM1_INTERNAL_IP=${VM1_INTERNAL_IP}

VM1_MANAGEMENT_IP=$(grep VM1_MANAGEMENT_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM1_MANAGEMENT_IP=${MANAGEMENT_NET}.${VM1_MANAGEMENT_IP}
echo VM1_MANAGEMENT_IP=${VM1_MANAGEMENT_IP}

VM2_INTERNAL_IF=$(grep VM2_INTERNAL_IF ${CONFIG_FILE} | awk -F= '{print $2}')
VM2_MANAGEMENT_IF=$(grep VM2_MANAGEMENT_IF ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM2_INTERNAL_IF=${VM2_INTERNAL_IF}
echo VM2_MANAGEMENT_IF=${VM2_MANAGEMENT_IF}

VM2_INTERNAL_IP=$(grep VM2_INTERNAL_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM2_INTERNAL_IP=${INTERNAL_NET}.${VM2_INTERNAL_IP}
echo VM2_INTERNAL_IP=${VM2_INTERNAL_IP}

VM2_MANAGEMENT_IP=$(grep VM2_MANAGEMENT_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM2_MANAGEMENT_IP=${MANAGEMENT_NET}.${VM2_MANAGEMENT_IP}
echo VM2_MANAGEMENT_IP=${VM2_MANAGEMENT_IP}

MAC_HOST_EXTERNAL="52:54:00:`(date; cat /proc/interrupts) | md5sum | sed -r 's/^(.{6}).*$/\1/; s/([0-9a-f]{2})/\1:/g; s/:$//;'`"
MAC_HOST_INTERNAL="52:54:00:`(date; cat /proc/interrupts) | md5sum | sed -r 's/^(.{6}).*$/\1/; s/([0-9a-f]{2})/\1:/g; s/:$//;'`"
MAC_HOST_MANAGEMENT="52:54:00:`(date; cat /proc/interrupts) | md5sum | sed -r 's/^(.{6}).*$/\1/; s/([0-9a-f]{2})/\1:/g; s/:$//;'`"
MAC_VM1_EXTERNAL="52:54:00:`(date; cat /proc/interrupts) | md5sum | sed -r 's/^(.{6}).*$/\1/; s/([0-9a-f]{2})/\1:/g; s/:$//;'`"

echo MAC_HOST_EXTERNAL=${MAC_HOST_EXTERNAL}
echo MAC_HOST_INTERNAL=${MAC_HOST_INTERNAL}
echo MAC_HOST_MANAGEMENT=${MAC_HOST_MANAGEMENT}
echo MAC_VM1_EXTERNAL=${MAC_VM1_EXTERNAL}

VM1_CONFIG_ISO=$(grep VM1_CONFIG_ISO ${CONFIG_FILE} | awk -F= '{print $2}')
VM2_CONFIG_ISO=$(grep VM2_CONFIG_ISO ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM1_CONFIG_ISO=${VM1_CONFIG_ISO}
echo VM2_CONFIG_ISO=${VM2_CONFIG_ISO}

VM1_NUM_CPU=$(grep VM1_NUM_CPU ${CONFIG_FILE} | awk -F= '{print $2}')
VM2_NUM_CPU=$(grep VM2_NUM_CPU ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM1_NUM_CPU=${VM1_NUM_CPU}
echo VM2_NUM_CPU=${VM2_NUM_CPU}

VM1_MB_RAM=$(grep VM1_MB_RAM ${CONFIG_FILE} | awk -F= '{print $2}')
VM2_MB_RAM=$(grep VM2_MB_RAM ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM1_MB_RAM=${VM1_MB_RAM}
echo VM2_MB_RAM=${VM2_MB_RAM}

VM1_HDD=$(grep VM1_HDD ${CONFIG_FILE} | awk -F= '{print $2}')
VM2_HDD=$(grep VM2_HDD ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM1_HDD=${VM1_HDD}
echo VM2_HDD=${VM2_HDD}

VM_TYPE=$(grep VM_TYPE ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM_TYPE=${VM_TYPE}

VM_VIRT_TYPE=$(grep VM_VIRT_TYPE ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM_VIRT_TYPE=${VM_VIRT_TYPE}

VM_DNS=$(grep VM_DNS ${CONFIG_FILE} | awk -F= '{print $2}')
echo VM_DNS=${VM_DNS}


SSH_PUB_KEY=$(grep SSH_PUB_KEY ${CONFIG_FILE} | awk -F= '{print $2}')
SSH_PUB_KEY=$(cat ${SSH_PUB_KEY})
echo SSH_PUB_KEY=${SSH_PUB_KEY}

VM_BASE_IMAGE=$(grep VM_BASE_IMAGE ${CONFIG_FILE} | awk -F= '{print $2}')

VID=$(grep VID ${CONFIG_FILE} | awk -F= '{print $2}')
echo VID=${VID}

VXLAN_IF=$(grep VXLAN_IF ${CONFIG_FILE} | awk -F= '{print $2}')
echo VXLAN_IF=${VXLAN_IF}

VXLAN_NET=$(grep VXLAN_NET ${CONFIG_FILE} | awk -F= '{print $2}' | grep -E ^[0-9])
echo VXLAN_NET=${VXLAN_NET}

VM1_VXLAN_IP=$(grep VM1_VXLAN_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM1_VXLAN_IP=${VXLAN_NET}.${VM1_VXLAN_IP}
echo VM1_VXLAN_IP=${VM1_VXLAN_IP}

VM2_VXLAN_IP=$(grep VM2_VXLAN_IP ${CONFIG_FILE} | awk -F= '{print $2}' | awk -F. '{print $2}')
VM2_VXLAN_IP=${VXLAN_NET}.${VM2_VXLAN_IP}
echo VM2_VXLAN_IP=${VM2_VXLAN_IP}


libvirtnetworks () {

cat << EOF > ${CUR_PWD}/networks/external.xml
<network>
  <name>${EXTERNAL_NET_NAME}</name>
  <uuid>41999d54-fdb4-474a-b520-078dca8b3cab</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr1' stp='on' delay='0'/>
  <mac address='${MAC_HOST_EXTERNAL}'/>
    <ip address='${EXTERNAL_NET_HOST_IP}' netmask='${EXTERNAL_NET_MASK}'>
    <dhcp>
      <host mac='${MAC_VM1_EXTERNAL}' name='${VM1_NAME}' ip='${VM1_EXTERNAL_IP}'/>
    </dhcp>
  </ip>
</network>
EOF

cat << EOF > ${CUR_PWD}/networks/internal.xml
<network>
  <name>${INTERNAL_NET_NAME}</name>
  <uuid>81596472-e74a-4d20-94a1-60ba74153d76</uuid>
  <bridge name='virbr2' stp='on' delay='0'/>
  <mac address='${MAC_HOST_INTERNAL}'/>
</network>
EOF

cat << EOF > ${CUR_PWD}/networks/management.xml
<network>
  <name>${MANAGEMENT_NET_NAME}</name>
  <uuid>2649f314-43d3-11e8-b528-0b017ad293b8</uuid>
  <bridge name='virbr3' stp='on' delay='0'/>
  <mac address='${MAC_HOST_MANAGEMENT}'/>
  <ip address='${MANAGEMENT_HOST_IP}' netmask='${MANAGEMENT_NET_MASK}'>
  </ip>
</network>
EOF

### Create and start networks
virsh net-define ${CUR_PWD}/networks/external.xml
virsh net-define ${CUR_PWD}/networks/internal.xml
virsh net-define ${CUR_PWD}/networks/management.xml

virsh net-start external
virsh net-start internal
virsh net-start management

}

libvirtnetworks

echo "Creating {meta,user}-data files for both vms..."
cat << EOF > ${CUR_PWD}/config-drives/vm1-config/meta-data
instance-id: ed5b1336-4bd3-11e8-ba61-2f25513b06d6
hostname: ${VM1_NAME}
local-hostname: ${VM1_NAME}
network-interfaces: |
  auto ${VM1_EXTERNAL_IF}
  iface ${VM1_EXTERNAL_IF} inet ${EXTERNAL_NET_TYPE}

  auto ${VM1_INTERNAL_IF}
  iface ${VM1_INTERNAL_IF} inet static
  address ${VM1_INTERNAL_IP}
  network ${INTERNAL_NET_IP}
  netmask ${INTERNAL_NET_MASK}
  broadcast ${INTERNAL_NET}.255

  auto ${VM1_MANAGEMENT_IF}
  iface ${VM1_MANAGEMENT_IF} inet static
  address ${VM1_MANAGEMENT_IP}
  network ${MANAGEMENT_NET_IP}
  netmask ${MANAGEMENT_NET_MASK}
  broadcast ${MANAGEMENT_NET}.255
EOF

cat << EOF > ${CUR_PWD}/config-drives/vm1-config/user-data
#cloud-config
password: qwerty
chpasswd: { expire: False }
ssh_pwauth: True
ssh_authorized_keys:
  - ${SSH_PUB_KEY}
package_update: true
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - software-properties-common
write_files:
  - content: |
        #!/bin/bash
        sysctl -w net.ipv4.ip_forward=1
        iptables -t nat -F
        iptables -A POSTROUTING -t nat -s ${INTERNAL_NET_IP}/${INTERNAL_NET_MASK} ! -d ${INTERNAL_NET_IP}/${INTERNAL_NET_MASK} -j MASQUERADE
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
        apt-get update
        apt-get install docker-ce -y
        ip link add ${VXLAN_IF} type vxlan id ${VID} remote ${VM2_INTERNAL_IP} local ${VM1_INTERNAL_IP} dstport 4789
        ip link set ${VXLAN_IF} up
        ip addr add ${VM1_VXLAN_IP}/24 dev ${VXLAN_IF}
    path: /root/base.sh
    permissions: '0755'
runcmd:
 - sh /root/base.sh
EOF

cat << EOF > ${CUR_PWD}/config-drives/vm2-config/meta-data
instance-id: 1e8dd370-4bd5-11e8-8a8a-3bd44a3b422e
hostname: ${VM2_NAME}
local-hostname: ${VM2_NAME}
network-interfaces: |
  auto ${VM2_INTERNAL_IF}
  iface ${VM2_INTERNAL_IF} inet static
  address ${VM2_INTERNAL_IP}
  network ${INTERNAL_NET_IP}
  netmask ${INTERNAL_NET_MASK}
  broadcast ${INTERNAL_NET}.255
  gateway ${VM1_INTERNAL_IP}
  dns-nameservers ${VM_DNS}

  auto ${VM2_MANAGEMENT_IF}
  iface ${VM2_MANAGEMENT_IF} inet static
  address ${VM2_MANAGEMENT_IP}
  network ${MANAGEMENT_NET_IP}
  netmask ${MANAGEMENT_NET_MASK}
  broadcast ${MANAGEMENT_NET}.255
EOF

cat << EOF > ${CUR_PWD}/config-drives/vm2-config/user-data
#cloud-config
password: qwerty
chpasswd: { expire: False }
ssh_pwauth: True
ssh_authorized_keys:
  - ${SSH_PUB_KEY}
write_files:
  - content: |
        #!/bin/bash
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
        apt-get update
        apt-get install docker-ce -y
        ip link add ${VXLAN_IF} type vxlan id ${VID} remote ${VM1_INTERNAL_IP} local ${VM2_INTERNAL_IP} dstport 4789
        ip link set ${VXLAN_IF} up
        ip addr add ${VM2_VXLAN_IP}/24 dev ${VXLAN_IF}
    path: /root/base.sh
    permissions: '0755'
runcmd:
 - sh /root/base.sh
EOF
echo ""

echo "Creating config-vm{1..2}.iso for both vms..."
mkisofs -o "${VM1_CONFIG_ISO}" -V cidata -r -J --quiet ${CUR_PWD}/config-drives/vm1-config
mkisofs -o "${VM2_CONFIG_ISO}" -V cidata -r -J --quiet ${CUR_PWD}/config-drives/vm2-config
echo ""

echo "Creating vm{1.2}.qcow2 files for both vms..."
echo "Downloading Ubuntu cloud image"
[ -f /var/lib/libvirt/images/cloudubuntu.img ] || wget -O /var/lib/libvirt/images/cloudubuntu.img ${VM_BASE_IMAGE}
cp /var/lib/libvirt/images/cloudubuntu.img ${VM1_HDD}
cp /var/lib/libvirt/images/cloudubuntu.img ${VM2_HDD}
echo ""

echo "Creating vm1 virtual machine.."
virt-install --connect qemu:///system --name ${VM1_NAME} --ram ${VM1_MB_RAM} --vcpus=${VM1_NUM_CPU} --${VM_TYPE} --os-type=linux --os-variant=ubuntu16.04 --disk path=${VM1_HDD},format=qcow2,bus=virtio,cache=none --disk path=${VM1_CONFIG_ISO},device=cdrom --network network=${EXTERNAL_NET_NAME},mac="${MAC_VM1_EXTERNAL}" --network network=${INTERNAL_NET_NAME} --network network=${MANAGEMENT_NET_NAME} --graphics vnc,port=-1 --noautoconsole --quiet --virt-type ${VM_VIRT_TYPE} --import
echo ""

sleep 30

echo "Creating vm2 virtual machine.."
virt-install --connect qemu:///system --name ${VM2_NAME} --ram ${VM2_MB_RAM} --vcpus=${VM2_NUM_CPU} --${VM_TYPE} --os-type=linux --os-variant=ubuntu16.04 --disk path=${VM2_HDD},format=qcow2,bus=virtio,cache=none --disk path=${VM2_CONFIG_ISO},device=cdrom --network network=${INTERNAL_NET_NAME} --network network=${MANAGEMENT_NET_NAME} --graphics vnc,port=-1 --noautoconsole --quiet --virt-type ${VM_VIRT_TYPE} --import
echo ""
