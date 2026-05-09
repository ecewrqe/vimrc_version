git rm -r --cached .

git rm --cached filename.txt

git ls-files --ignored --exclude-standard | xargs git rm --cached

npm cache clean --force
yarn cache clean

find . -size +100M -exec git rm --cached {} \;

git ls-files --deleted -z | xargs -0 git rm

git status --procelain | grep '^ M' | awk '{print $2}' | xargs git rm
