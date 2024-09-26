mod config;

use clap::{Arg, ArgGroup, Command};
use std::env;
use std::io::{self, Write};
use std::os::unix::fs::symlink; // For creating symbolic links
use std::path::{Component, PathBuf};

fn main() {
    // Set up command-line argument parsing with clap
    let cmd = Command::new("Setup")
        .about("Creates symbolic links for configuration files.")
        .arg(
            Arg::new("configs")
                .long("configs")
                .short('c')
                .num_args(1..) // Accept one or more arguments
                .help("Specify which configs to create symlinks for (e.g., --configs zsh tmux)"),
        )
        .arg(
            Arg::new("list")
                .long("list")
                .short('l')
                .num_args(0)
                .help("List all available configurations from the TOML file"),
        )
        .group(
            ArgGroup::new("Options")
                .args(["list", "configs"])
                .required(true),
        );

    let matches = cmd.get_matches();
    let configs_list_file = "../configs.toml";

    // Get the current working directory
    let current_dir = env::current_dir().expect("Failed to get current working directory");

    // Get the XDG_CONFIG_HOME path, typically "~/.config/"
    let xdg_config_home = xdg::BaseDirectories::new().unwrap().get_config_home();

    // Load the configs from the TOML file
    let configs = match config::get_configs_list(configs_list_file) {
        Ok(configs) => configs,
        Err(e) => {
            eprintln!("An error occurred: {}", e);
            std::process::exit(1);
        }
    };

    println!("Here: {:?}", matches.contains_id("configs"));
    // Handle --list flag: Display all available configs
    if matches.contains_id("list") {
        println!("Available configurations in the TOML file:");

        let mut keys: Vec<&String> = configs.keys().collect();
        keys.sort();

        for key in keys {
            println!(" - {}", key);
        }
        println!("\nTo use specific configs, run the command like this:");
        println!(" ./setup --configs <config_name> <config_name>");
        return;
    }

    // Get the selected configs or an empty vector if none are provided
    let selected_configs: Vec<String> = matches
        .get_many::<String>("configs")
        .map(|v| v.map(String::from).collect())
        .unwrap_or_default();

    let all_configs = selected_configs.is_empty();

    if all_configs {
        print!("Are you sure you want to install all configs? (y/n): ");
        io::stdout().flush().unwrap(); // Ensure the prompt is displayed

        let mut response = String::new();
        io::stdin().read_line(&mut response).unwrap();

        if response.trim().to_lowercase() != "y" {
            println!("Aborting.");
            return;
        }
    }

    // Process each config
    for (key, config) in configs {
        // Check if the current config should be processed
        if !all_configs && !selected_configs.contains(&key) {
            continue; // Skip this config if it’s not specified
        }

        // Parse `config.src` as a PathBuf and join with current directory
        let new_path = current_dir.join(&config.src);

        // Normalize the path manually, handling both `.` and `..`
        let mut normalized_path = PathBuf::new();
        for component in new_path.components() {
            match component {
                Component::CurDir => {}
                Component::ParentDir => {
                    normalized_path.pop();
                }
                _ => normalized_path.push(component),
            }
        }

        // Determine the target symlink path in XDG_CONFIG_HOME
        let target_symlink = if normalized_path.is_file() {
            // If it's a file, the symlink name should match the file name
            xdg_config_home.join(normalized_path.file_name().unwrap())
        } else {
            // If it's a directory, the symlink name should match the directory name
            xdg_config_home.join(key)
        };

        // Print the resolved paths for debugging
        println!("Normalized Path: {}", normalized_path.display());
        println!("Target Symlink: {}", target_symlink.display());

        // Create the symlink
        match symlink(&normalized_path, &target_symlink) {
            Ok(_) => {
                println!(
                    "Created symlink: {} -> {}",
                    target_symlink.display(),
                    normalized_path.display()
                );
            }
            Err(e) => {
                eprintln!(
                    "Failed to create symlink: {} -> {}: {}",
                    target_symlink.display(),
                    normalized_path.display(),
                    e
                );
            }
        }
    }
}
