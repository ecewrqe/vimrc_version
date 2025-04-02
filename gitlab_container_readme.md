# GITLAB初期化

コンテナ起動

```bash
export GITLAB_HOME="${HOME}/Desktop/Projects/myNewProj/gitlab_container"
docker compose up -d
docker compose start
```

DNS設定
`external_url 'https://gitlab.example.com:8929'`
/etc/hosts

```bash
127.0.0.1 gitlab.example.com
```

ブラウザでアクセスする `https://gitlab.example.com:8929`
username: root
password: <以下>, Rtxkz/JO3uOURljUeYQSa8pvrVTiwR0C/P+QaXz8F0E=

```bash
docker exec -it <gitlab_container_id> cat /etc/gitlab/initial_root_password
```

sshkey

```bash
ssh-keygen -t ed25519 -C "euewrqe@gmail.com"
cat ~/.ssh/id_ed25519.pub
ssh -T git@gitlab.example.com -p 2224
# Welcome to GitLab, @euewrqe!
ssh -T git@gitlab.example.com
# ここまで
```

追加`~/.ssh/config`

```text
Host gitlab.example.com
  User git
  Port 2224
```

