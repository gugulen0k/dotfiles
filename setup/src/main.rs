mod config;

fn main() {
    let configs_list_file = "../configs.toml";
    let xdg_config_home = xdg::BaseDirectories::new().unwrap().get_config_home();
    println!("{:?}", xdg_config_home);

    match config::get_configs_list(configs_list_file) {
        Ok(configs) => {
            for (key, config) in configs {
                println!("Config Name: {}\nSource Path: {}\n", key, config.src);
            }
        }
        Err(e) => {
            eprintln!("An error occurred: {}", e);
            std::process::exit(1);
        }
    }
}
