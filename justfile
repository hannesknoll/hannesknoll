
default: generate push

# Generate a new README
generate:
    nu main.nu

# Push changes to github
push:
    git add .
    git cm 'update'
    git push
