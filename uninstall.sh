nimble uninstall Dela
echo "Exec file removed"

# remove desktop file
rm ~/.local/share/applications/dela.desktop
echo "Desktop file removed"
# rm 

read -p "Do you want to remove your tasks saved inside .config/Dela? [y/n]: " answer

if [[ $answer == "y" ]]; then
    rm -rf ~/.config/Dela
    echo "Directory and its contents removed."
else
    echo "No action taken."
fi