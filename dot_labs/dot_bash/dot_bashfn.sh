alias clear_history='cat /dev/null > ~/.bash_history && history -c'

################# FUNCTIONS ########################
setRepoConfigProfile() {
  git config user.email "mirfmaster@gmail.com"
  git config user.name "Muhamad Iqbal"
}

setRepoConfigProfileZOT() {
  git config user.email "iqbal@zero-one-group.com"
  git config user.name "Muhamad Iqbal"
}

dockerStopRestart() {
    docker update --restart=no $(docker ps -a -q)
}

