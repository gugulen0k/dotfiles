function gentags() {
  echo "Exporting tags..."
  ripper-tags -R -f .git/rubytags --tag-relative=yes
  noglob ctags -R -f .git/tags --tag-relative=yes --exclude=*.rb
}
