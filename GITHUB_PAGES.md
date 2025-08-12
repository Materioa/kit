# GitHub Pages Compatible Font Awesome Kit Server

## GitHub Pages Limitations
GitHub Pages has restrictions that affect our current setup:
- Limited Jekyll plugins
- Different file processing
- Security restrictions

## Solution: GitHub Actions + Static Generation

We'll use GitHub Actions to build and deploy the kits as static files.

## Setup Instructions

1. Push your Font Awesome kit project to GitHub
2. Enable GitHub Pages in repository settings
3. Set source to "GitHub Actions"
4. The workflow will automatically build and deploy

## What Gets Deployed
Only the compiled kit files will be publicly accessible:
- /{kit_id}.js files
- CSS files  
- webfonts/
- index.html (optional landing page)

## Kit URLs
Your kits will be available at:
- https://yourusername.github.io/your-repo/673492kit01.js
- https://yourusername.github.io/your-repo/abc123kit02.js

## Security
All source files, configurations, and build scripts remain private in your repo.
Only the final compiled kits are deployed to the gh-pages branch.
