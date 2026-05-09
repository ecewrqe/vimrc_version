git push origin --delete feature/old-feature
git push origin --delete feature/branch1 feature/branch2

# List remote branches
git branch -r

git branch -r | grep -E "(feature|hotfix)/"

git branch -r --merged main | grep -v main

git branch -r | grep "origin/feature/" | sed 's/origin\///' | xargs -I {} git push origin --delete {}

# Delete remote branches that have not been updated for more than 30 days
for branch in $(git for-each-ref --format='%(refname:short) %(committerdate:unix)' refs/remotes/origin | awk '$2 < (systime() - 30*24*60*60) {print $1}' | sed 's/origin\///'); do
    echo "Deleting old branch: $branch"
    git push origin --delete "$branch"
done

git branch -r | grep "feature/" | while read branch; do
    branch_name=$(echo $branch | sed 's/origin\///')
    read -p "Delete $branch_name? (y/N): " confirm [[ $confirm == [yY] ]] && git push origin --delete "$branch_name"
done

git branch -r | grep "origin/feature/" | sed 's/origin\///' | grep -v -E "(main|develop|staging|production)" | xargs -I {} git push origin --delete {}

git remote prune origin

git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -D

# github cli
owner="euewrqe-project-manage"
repo="bekazone_rails"
gh api repos/euewrqe-project-manage/bekazone_rails/git/refs/heads/<branch-name> -X DELETE