echo "[gh-cli]
name=packages for the GitHub CLI
baseurl=https://cli.github.com/packages/rpm
enabled=1
gpgkey=https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xc99b11deb97541f0" | sudo tee -a /etc/yum.repos.d/gh.repo >/dev/null


