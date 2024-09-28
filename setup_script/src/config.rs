use serde::Deserialize;
use std::collections::HashMap;
use std::error::Error;
use std::fs;

#[derive(Deserialize, Debug)]
pub struct Config {
    pub src: String,
    pub dst: String,
}

// Function to get the configurations list from a TOML file
pub fn get_configs_list(file_name: &str) -> Result<HashMap<String, Config>, Box<dyn Error>> {
    let contents = fs::read_to_string(file_name).map_err(|e| {
        eprintln!("Failed to read file '{}'\nError: {}\n", file_name, e);
        e
    })?;

    let configs_list: HashMap<String, Config> = toml::from_str(&contents).map_err(|e| {
        eprintln!("Failed to parse TOML '{}'\nError: {}\n", file_name, e);
        e
    })?;

    Ok(configs_list)
}
