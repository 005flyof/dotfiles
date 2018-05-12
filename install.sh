#!/bin/bash
#
# This script creates symlinks from the home directory to any
# desired dotfiles in the repository


# Variables
###########

# Old dotfiles will be stored in...
olddir=dotfiles_old

# Repository
dir=~/Développement/dotfiles

# This script's name
scriptname=install.sh



# Main program
##############

# Change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# Create backup dir
echo "Creating $olddir for backup of any existing dotfiles in repository (not versionned)"
mkdir -p $olddir
echo "...done"

# Compute files to be symlinked
if [ $# -gt 0 ]; then
	files="$@"
else
	# If no arguments, ask the user to copy all files
	echo ""
	msg="Do you really want to install all dotfiles from the repository? (y/n) "
	read -p "$msg" answer
	while [[ "$answer" != "y" && "$answer" != "n" ]]; do
		read -p "$msg" answer
	done

	if [[ "$answer" = "n" ]]; then
		echo "Ok. Please indicate which file to copy."
		exit 0
	else
		files=$(ls | grep -v $scriptname | grep -v $olddir)
	fi
fi

# Move any existing dotfiles in homedir to dotfiles_old directory,
# then create symlinks
for file in $files; do
	echo ""
	# Only if there is a new configuration
	if [ ! -f "$dir/$file" ]; then
		echo "The dotfile $file doesn't exist in the repository!"
	else
		if [ -f "~/.$file" ]; then
			echo "Moving '.$file' from ~ to '$dir/$olddir'"
			mv ~/.$file $dir/$olddir/
		fi

		echo "Creating symlink to $file in home directory."
		ln -s $dir/$file ~/.$file
	fi
done

echo ""
