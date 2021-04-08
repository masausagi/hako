#!/bin/bash -eu

#--- nouveauを無効化
sudo bash -c "echo -e 'blacklist nouveau\\noptions nouveau modset=0' > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo update-initramfs -u

#--- nvidiaドライバーの最新版を入手
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update

#--- nvidia-driverのインストール
sudo ubuntu-drivers autoinstall

#--- dockerをインストール
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

#--- nvidia container toolkitsのインストール
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

#--- 終了
echo "正常に完了しました！"

echo -n "再起動してもよろしいですか？ [Y/n]: "
read ANS
case $ANS in
  "" | [Yy]* )
    # ここに「Yes」の時の処理を書く
    sudo reboot
    ;;
  * )
    # ここに「No」の時の処理を書く
    echo ""
    ;;
esac
