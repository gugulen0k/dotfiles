use clap::{Arg, Command};
use inquire::MultiSelect;
use std::collections::HashMap;
use std::env;
use std::error::Error;
use std::fs;
use std::path::Path;
use toml::Value;

fn main() -> Result<(), Box<dyn Error>> {
    // Set up command-line argument parsing
    let matches = Command::new("dotfile-symlink")
        .version("1.0")
        .author("Your Name <your.email@example.com>")
        .about("Creates symbolic links for dotfiles")
        .arg(
            Arg::new("config")
                .short('c')
                .long("config")
                .value_name("FILE")
                .about("Path to the dotfiles.toml file")
                .takes_value(true)
                .default_value("dotfiles.toml"),
        )
        .get_matches();

    let toml_path = matches.value_of("config").unwrap();
    let toml_path = Path::new(toml_path);

    // Check if file exists
    if !toml_path.exists() {
        eprintln!("Error: File does not exist: {}", toml_path.display());
        std::process::exit(1);
    }

    // Read the `dotfiles.toml` file
    let toml_content = fs::read_to_string(toml_path)
        .map_err(|e| format!("Failed to read file '{}': {}", toml_path.display(), e))?;
    let value: Value = toml_content.parse()?;

    // Extract paths from the TOML file
    let mut paths = HashMap::new();
    if let Value::Table(table) = value {
        for (key, section) in table {
            if let Value::Table(section_table) = section {
                if let Some(Value::String(src)) = section_table.get("src") {
                    paths.insert(key, src.clone());
                }
            }
        }
    }

    // Use inquire to select multiple dotfiles
    let options: Vec<String> = paths.keys().cloned().collect();
    let selected_keys = MultiSelect::new("Select dotfiles to symlink:", options).prompt()?;

    // Create symbolic links in the user's `.config` directory
    let home_dir = env::var("HOME")?;
    let config_dir = Path::new(&home_dir).join(".config");

    for key in selected_keys {
        if let Some(src_path) = paths.get(&key) {
            let src = Path::new(src_path);
            let dest = config_dir.join(src.file_name().unwrap_or_default());

            // Create symbolic link
            if let Err(e) = std::os::unix::fs::symlink(src, &dest) {
                eprintln!("Failed to create symlink for {}: {}", src.display(), e);
            } else {
                println!(
                    "Symlink created for {} -> {}",
                    src.display(),
                    dest.display()
                );
            }
        }
    }

    Ok(())
}
