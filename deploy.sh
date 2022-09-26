# Generate change into public
hugo

# Commmit in production 
cd ./public
git add .
git commit -m "update"
git push

# Commit in store
cd ../
git add .
git commit -m "update"
git push