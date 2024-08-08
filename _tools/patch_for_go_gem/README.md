# patch_for_go_gem
Patch to make a gem into a Go gem right after `bundle gem`

## Usage
1. Download [patch_for_go_gem.rb](patch_for_go_gem.rb)
2. Run `bundle gem <YOUR_GEMNAME> --ext=c`
    * The other options for `bundle gem` are optional
3. Run `ruby patch_for_go_gem.rb --file /path/to/YOUR_GEMNAME.gemspec --dry-run`
4. Run `ruby patch_for_go_gem.rb --file /path/to/YOUR_GEMNAME.gemspec`
