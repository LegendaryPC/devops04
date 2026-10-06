```bash
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,FSTYPE,SERIAL,UUID

# lệnh format
sudo mkfs.ext4 /dev/nvme1n1

# mount ổ cứng
sudo mount /dev/nvme1n1 /data

# chỉnh file /etc/fstab
UUID=df3f6336-c034-4b31-8e64-67e11c935a4a /data ext4 defaults,nofail 0 2

# reload
sudo systemctl daemon-reload

# mount lại sau khi setting /etc/fstab
sudo mount /data

df -h /data

# cập nhật lại size mới cho ổ đĩa, khi tăng dung lượng
sudo resize2fs /dev/nvme1n1

# snapshot
cd

sync

# unmount
sudo umount /data

# chỉ phù hợp cho backup (restore)
sudo mount -o ro,noload /dev/nvme2n1 /data-backup
# ro: read only chỉ đọc
# noload: ngăn hệ thống thay đổi bất cứ thứ gì

sudo umount /dev/nvme2n1 /data-backup

sudo mkfs.ext4 /dev/nvme2n1

sudo mount /dev/nvme2n1 /data-scale-down

# rsync
rsync --version

# nếu chưa cài
sudo apt update && sudo apt install rsync

sudo rsync -aHAX /data/ /data-scale-down/
# -aHAX giúp giữ nguyên quyền và các thuộc tính, mọi thứ của tệp
sudo rsync -aHAXnci /data/ /data-scale-down/
# chạy thử nghiệm: để kiểm tra 2 thư mục đã giống nhau chưa

sudo umount /dev/nvme1n1 /data
sudo umount /dev/nvme2n1 /data-scale-down

sudo mount /dev/nvme2n1 /data
```