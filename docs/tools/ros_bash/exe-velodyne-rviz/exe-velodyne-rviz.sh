#!/bin/bash
bash_dir=$(cd $(dirname $0); pwd)
rviz_file="velodyne_points_show.rviz"

if [[ ! -e $bash_dir/$rviz_file ]]; then
  type wget > /dev/null 2>&1 || {
    echo "wgetがインストールされていません"
    echo -n "インストールしてもよろしいですか？ [Y/n]: "
    read ANS
    case $ANS in
      "" | [Yy]* )
        # ここに「Yes」の時の処理を書く
        sudo apt-get install -y wget
        ;;
        * )
        # ここに「No」の時の処理を書く
        echo $rviz_file"がないため実行できませんでした"
        exit 1
        ;;
    esac
  }
  echo "$rviz_fileをダウンロードします"
  sudo wget "https://masausagi.github.io/hako/tools/ros_bash/exe-velodyne-rviz/$rviz_file" -O $rviz_file > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo $rviz_file"を正常にダウンロードできませんでした"
    exit 1
  fi
  sudo chmod a+rw $rviz_file
fi

echo "起動"

gnome-terminal -e "roslaunch velodyne_pointcloud VLP16_points.launch" --disable-factory > /dev/null 2>&1 &

sleep 1s

rosrun rviz rviz -f velodyne -d $bash_dir/velodyne_points_show.rviz > /dev/null 2>&1 &

pid=$!
bpid=`ps ax | grep "roslaunch velodyne" | awk '{print $1}'`

#echo "roslaunch ".$bpid
#echo "rviz ".$pid

while : ; do
  kill -0 $pid > /dev/null 2>&1 || {
   break
  }

  kill -0 $bpid > /dev/null 2>&1 || {
   break
  }
  sleep 1
done

kill $pid > /dev/null 2>&1
kill $bpid > /dev/null 2>&1

