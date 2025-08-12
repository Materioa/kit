#!/usr/bin/env ruby

# Font Awesome Kit Server Deployment Script
# This script creates a clean deployment package with only the necessary files

require 'fileutils'
require 'pathname'

puts "Font Awesome Kit Server - Deployment Package Creator"
puts "=" * 60

# Configuration
source_dir = Pathname.new('.')
deploy_dir = Pathname.new('deploy')
site_dir = Pathname.new('_site')

# Clean and create deployment directory
if deploy_dir.exist?
  puts "Cleaning existing deployment directory..."
  FileUtils.rm_rf(deploy_dir)
end

puts "Creating deployment directory: #{deploy_dir}"
FileUtils.mkdir_p(deploy_dir)

# Build the Jekyll site first
puts "Building Jekyll site..."
system('bundle exec jekyll build')

unless site_dir.exist?
  puts "Error: Jekyll build failed. _site directory not found."
  exit 1
end

# Files to include in deployment
include_patterns = [
  '*.js',           # Kit JavaScript files
  '*.css',          # Font Awesome CSS files
  'webfonts/**/*',  # Font files
  'index.html'      # Landing page (if exists)
]

# Copy necessary files from _site
puts "\nCopying deployment files..."

include_patterns.each do |pattern|
  Dir.glob(site_dir.join(pattern)).each do |file|
    relative_path = Pathname.new(file).relative_path_from(site_dir)
    destination = deploy_dir.join(relative_path)
    
    # Create directory if needed
    FileUtils.mkdir_p(destination.dirname)
    
    # Copy file
    FileUtils.cp(file, destination)
    puts "  ✓ #{relative_path}"
  end
end

# Create a simple .htaccess for proper MIME types
htaccess_content = <<~HTACCESS
# Font Awesome Kit Server - Apache Configuration

# Proper MIME types
AddType application/javascript .js
AddType text/css .css
AddType font/woff2 .woff2
AddType font/woff .woff
AddType font/ttf .ttf
AddType font/eot .eot

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"

# Cache control for fonts
<FilesMatch "\\.(woff2|woff|ttf|eot)$">
    Header set Cache-Control "public, max-age=31536000"
</FilesMatch>

# Cache control for CSS
<FilesMatch "\\.css$">
    Header set Cache-Control "public, max-age=86400"
</FilesMatch>

# Cache control for JS (shorter cache for kit files)
<FilesMatch "\\.js$">
    Header set Cache-Control "public, max-age=3600"
</FilesMatch>

# CORS headers (if serving cross-domain)
# Header always set Access-Control-Allow-Origin "*"
# Header always set Access-Control-Allow-Methods "GET, OPTIONS"
# Header always set Access-Control-Allow-Headers "Content-Type"
HTACCESS

File.write(deploy_dir.join('.htaccess'), htaccess_content)
puts "  ✓ .htaccess"

# Create deployment info
deployment_info = {
  'deployment_date' => Time.now.iso8601,
  'kit_files' => Dir.glob(deploy_dir.join('*.js')).map { |f| File.basename(f) },
  'css_files' => Dir.glob(deploy_dir.join('*.css')).map { |f| File.basename(f) },
  'total_files' => Dir.glob(deploy_dir.join('**/*')).select { |f| File.file?(f) }.size
}

File.write(deploy_dir.join('deployment-info.json'), JSON.pretty_generate(deployment_info))
puts "  ✓ deployment-info.json"

# Summary
puts "\n" + "=" * 60
puts "Deployment package created successfully!"
puts "Location: #{deploy_dir.expand_path}"
puts "Kit files: #{deployment_info['kit_files'].join(', ')}"
puts "Total files: #{deployment_info['total_files']}"
puts "\nTo deploy:"
puts "1. Upload contents of '#{deploy_dir}' to your web server"
puts "2. Ensure proper file permissions (644 for files, 755 for directories)"
puts "3. Test kit URLs: https://yourdomain.com/{kit_id}.js"
puts "=" * 60
