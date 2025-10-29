# Push this project to GitHub

```bash
# 1) Rename the folder if you like, then:
cd sas-health-portfolio

# 2) Initialize git (if not already a repo)
git init
git add .
git commit -m "Add SAS project: Depression prediction in cancer survivors (NHIS 2019–2023)"

# 3) Create a new GitHub repo first (empty, no README), then set the remote:
git remote add origin https://github.com/<your-username>/sas-health-portfolio.git

# 4) Push
git branch -M main
git push -u origin main
```

If you already have a `sas-health-portfolio` repo, move the `depression_cancer_survivors_sas/` folder into it and push as usual.
