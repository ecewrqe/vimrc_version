git rm -r --cached .

git rm --cached filename.txt

git ls-files --ignored --exclude-standard | xargs git rm --cached

npm cache clean --force
yarn cache clean

find . -size +100M -exec git rm --cached {} \;
