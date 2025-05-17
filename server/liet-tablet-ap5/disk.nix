{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 0;
              size = "1M";
              type = "EF02";
            };
            ESP = {
              priority = 1;
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            plainSwap = {
              priority = 2;
              size = "24G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            root = {
              priority = 3;
              name = "root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "f2fs";
                mountpoint = "/";
                extraArgs = [
                  "-i" # 2025-05 的部署中没有设置该项 应当 定期检查 inodes 状态
                  # 哈气了 用 df -ih 检查
                  # for more info check
                  # https://lore.kernel.org/all/CAF_dkJB%3d2PAqes+41xAi74Z3X0dSjQzCd9eMwDjpKmLD9PBq6A@mail.gmail.com/T/
                  "-O"
                  "extra_attr,inode_checksum,sb_checksum,compression"
                ];
                mountOptions = [
                  # 计算机性能不够 没必要为了空间去开 ztsd什么的高速低压缩率的lz4已经很符合我目标了
                  # 可以逝世 inline_data inline_dentry 什么的 因为nix大量依赖软连接
                  # 看起来这样会让nix的软连接直接住进 inodes 里 可以跑过港媒 查过了不能跑过港媒但是可以减少占用
                  # inline_xattr 是让文件尾部的东西进 inode 先不开了感觉没啥用
                  "inline_data,inline_dentry,compress_algorithm=lz4,compress_chksum,atgc,gc_merge,lazytime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
