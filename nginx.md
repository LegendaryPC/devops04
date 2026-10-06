```bash
# Tạo
sudo vim /etc/nginx/sites-available html.vulebaolong.com.conf

# Link
sudo ln -s /etc/nginx/sites-available/tenfile.conf /etc/nginx/sites-enabled

# Unlink
sudo rm -rf tenfile
sudo rm -rf /etc/nginx/sites-enabled

# check cú pháp & reload
sudo nginx -t
sudo systemctl reload nginx


sudo vim vulebaolong-private.key
sudo vim vulebaolong-public.crt
```