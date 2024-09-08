use dialoguer::{theme::ColorfulTheme, MultiSelect};
use dirs::home_dir;
use std::fs;
use std::os::unix::fs::symlink;
use std::path::{Path, PathBuf};

fn create_symlink(src: &str, dst: &Path) -> std::io::Result<()> {
    // Check if the destination already exists
    if dst.exists() {
        println!("Destination {:?} already exists. Skipping...", dst);
        return Ok(());
    }

    // Create a symbolic link
    symlink(src, dst)?;
    println!("Symbolic link created: {:?} -> {}", dst, src);
    Ok(())
}

fn main() {
    // List of dotfiles to potentially create symlinks for
    let dotfiles_to_link = [
        ("/path/to/source/.bashrc", ".bashrc"),
        ("/path/to/source/.vimrc", ".vimrc"),
        ("/path/to/source/.zshrc", ".zshrc"),
    ];

    // Get the user's home directory
    let home_dir = home_dir().expect("Could not find home directory");

    // Convert the dotfiles list into a vector of labels for the multiselect menu
    let options: Vec<String> = dotfiles_to_link
        .iter()
        .map(|(src, file)| format!("{} -> ~{}", src, file))
        .collect();

    // Present a multiselect menu to the user
    let selections = MultiSelect::with_theme(&ColorfulTheme::default())
        .with_prompt("Select the dotfiles for which you want to create symbolic links in your home directory")
        .items(&options)
        .interact()
        .unwrap();

    // Process the selections
    for i in selections {
        let (src, filename) = &dotfiles_to_link[i];
        let dest_path = home_dir.join(filename); // Append the filename to the home directory path

        match create_symlink(src, &dest_path) {
            Ok(_) => (),
            Err(e) => eprintln!("Failed to create symlink: {}", e),
        }
    }
}
