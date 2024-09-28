mod config;

use clap::{Arg, ArgGroup, Command};
use shellexpand::tilde;
use std::env;
use std::io::{self, Write};
use std::os::unix::fs::symlink;
use std::path::{Component, PathBuf};

fn main() {
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
        .group(ArgGroup::new("Options").args(["list", "configs"]));

    let matches = cmd.get_matches();
    let configs_list_file = "./configs.toml";

    // Get the current working directory
    let current_dir = env::current_dir().expect("Failed to get current working directory");

    // Load the configs from the TOML file
    let configs = match config::get_configs_list(configs_list_file) {
        Ok(configs) => configs,
        Err(e) => {
            eprintln!("An error occurred: {}", e);
            std::process::exit(1);
        }
    };

    if matches.get_flag("list") {
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
    let selected_configs = matches
        .get_many::<String>("configs")
        .unwrap_or_default()
        .map(|v| v.as_str())
        .collect::<Vec<_>>();

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

    for (key, config) in configs {
        if !all_configs && !selected_configs.iter().any(|v| v == &key) {
            continue;
        }

        let config_src = PathBuf::from(tilde(&config.src).to_string());
        let config_dst = PathBuf::from(tilde(&config.dst).to_string());

        let mut config_src = current_dir.join(config_src);
        config_src = normalized_path(&config_src);

        let config_dst = normalized_path(&config_dst);

        match symlink(&config_src, &config_dst) {
            Ok(_) => {
                println!(
                    "Created symlink: {} -> {}\n",
                    &config_src.display(),
                    &config_dst.display()
                );
            }
            Err(e) => {
                eprintln!(
                    "Failed to create symlink: {} -> {}: {}\n",
                    &config_src.display(),
                    &config_dst.display(),
                    e
                );
            }
        }
    }
}

// Normalize the path manually, handling both `.` and `..`
fn normalized_path(path: &PathBuf) -> PathBuf {
    let mut normalized_path = PathBuf::new();

    for component in path.components() {
        match component {
            Component::CurDir => normalized_path.push(component),
            Component::ParentDir => {
                normalized_path.pop();
            }
            _ => normalized_path.push(component),
        }
    }

    normalized_path
}
