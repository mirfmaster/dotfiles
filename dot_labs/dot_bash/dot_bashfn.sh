alias clear_history='cat /dev/null > ~/.bash_history && history -c'

################# FUNCTIONS ########################
setRepoConfigProfile() {
  bl_info "Setting up repo config using personal email"
  git config user.email "mirfmaster@gmail.com"
  git config user.name "Muhamad Iqbal"
}

setRepoConfigProfileZOT() {
  bl_info "Setting up repo config using ZOT email"
  git config user.email "iqbal@zero-one-group.com"
  git config user.name "Muhamad Iqbal"
}

dockerStopRestart() {
    bl_info "Update all docker to no auto restart"
    docker update --restart=no $(docker ps -a -q)
}

gtfd() {
  local template="$1"
  local path="$2"

  /usr/sbin/terraform-docs --sort-by "required" -c "$template" "$path" > "$path/readme.md"
}

cmall() {
    cm add ~/.labs/
}

cmpush() {
  bl_info "Syncing working directory with remote repository"
  sleep 1
  ga .
  gcmsg "."
  ggp
}

cmsync() {
  bl_info "Syncing local changes with working directory"
  cm add ~/.labs/
  cm re-add

  cd ~/.local/share/chezmoi
  cmpush
  exit
}
