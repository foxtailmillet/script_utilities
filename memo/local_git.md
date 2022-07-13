#create repository
mkdir /path/to/bare_repository
cd /path/to/bare_repository
git init --bare --shared

# git clone
git clone /path/to/bare_repository

# push
git remote add origin /path/to/bare_repository
git push --set-upstream origin master

