# Overview

Instructions on how to setup k8s cluster in strigo environment. 

- CRI = containerd
- CNI = Calico
- CSI = ?
- Ingress = ingress-nginx

## Things to do on all nodes

- `sudo apt -y update && sudo apt -y upgrade`
- `lsmod | grep br_netfilter`
- `sudo sysctl --system`
- Ensure swap is turned off
    - `sudo swapoff -a`
- Install [kubectl, kubeadm, and containerd](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)
    - containerd install
        - ```
            cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
            overlay
            br_netfilter
            EOF

            sudo modprobe overlay
            sudo modprobe br_netfilter

            # Setup required sysctl params, these persist across reboots.
            cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
            net.bridge.bridge-nf-call-iptables  = 1
            net.ipv4.ip_forward                 = 1
            net.bridge.bridge-nf-call-ip6tables = 1
            EOF

            # Apply sysctl params without reboot
            sudo sysctl --system
          ```
        - ` curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`
        - ```
            echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          ```
        - `sudo apt -y update`
        - `sudo apt -y install containerd.io`
        - ```
            sudo mkdir -p /etc/containerd
            containerd config default | sudo tee /etc/containerd/config.toml
          ```
        - `sudo systemctl restart containerd`
    - kubenetes install
        - `sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg`
        - `echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list`
        - `sudo apt -y update`
        - `sudo apt-get install -y kubelet kubeadm kubectl`
        - `sudo apt-mark hold kubelet kubeadm kubectl`

## Init the master node

- Figure out your Strigo environment's master node dynamic DNS name.
- Run `sudo kubeadm init --upload-certs --pod-network-cidr=192.168.0.0/16 --control-plane-endpoint <dynamic-dns-name>`
    - My dynamic dns name was `nsxcczzcrqcdfqzt2-85xm4h5sqjd3urhvg.labs.strigo.io`
- Setup kubectl to use new config file
    -   ```
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        ```
- **COPY THE JOIN COMMAND IN THE ABOVE OUTPUT FROM KUBEADM INIT**
    - Be sure to grab the worker node kubeadm join option, not control plane one.

## Add Worker Nodes

- Run that join command on your worker nodes.
- After joining them all, be sure `kubectl get nodes` shows all your extra nodes.

## Install Calico

- Back to the master node!
- `kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml`
- `kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml`
- Ensure everything is working via `kubectl get nodes -o wide`.
- Last check, make sure all pods are running `kubectl get pods -A`

## References

- [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Configure cluster](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [Installing Calico](https://docs.projectcalico.org/getting-started/kubernetes/quickstart)


