#[macro_use]
extern crate handlebars;
extern crate heck;
#[macro_use]
extern crate log;
extern crate pretty_env_logger;
#[macro_use]
extern crate serde_derive;
extern crate serde_yaml;
#[macro_use]
extern crate structopt;

use std::{
    error::Error,
    fs,
    path::PathBuf,
    process,
};

use handlebars::Handlebars;
use heck::{CamelCase, KebabCase, SnakeCase};
use structopt::StructOpt;

#[derive(StructOpt)]
struct Opt {
    #[structopt(parse(from_os_str))]
    /// specification file
    input: PathBuf,
    #[structopt(parse(from_os_str))]
    /// directory to place main.rs
    output_dir: PathBuf,
    #[structopt(long = "override-impl")]
    /// override main_impl.rs
    override_impl: bool,
}

#[derive(Deserialize, Serialize, Debug)]
struct Settings {
    imports: Vec<String>,
    cli: Vec<Specification>,
}

#[derive(Deserialize, Serialize, Debug)]
struct Specification {
    name: String,
    help: Option<String>,
    nested: Option<Vec<Nested>>,
    args: Option<Vec<Argument>>,
}

#[derive(Deserialize, Serialize, Debug)]
struct Nested {
    name: String,
    help: Option<String>,
    role: Option<String>,
    args: Option<Vec<Argument>>,
}

#[derive(Deserialize, Serialize, Debug)]
struct Argument {
    name: String,
    help: Option<String>,
    #[serde(rename = "type")]
    value_type: String,
    #[serde(default)]
    positional: bool,
}

fn run() -> Result<(), Box<Error>> {
    let cli = Opt::from_args();
    debug!("Parsing input file: {:?}", cli.input);
    let settings: Settings = serde_yaml::from_str(&fs::read_to_string(cli.input)?)?;
    if !cli.output_dir.exists() {
        fs::create_dir_all(&cli.output_dir)?;
    }
    let mut handlebars = Handlebars::new();
    handlebars.set_strict_mode(false);
    handlebars.register_escape_fn(handlebars::no_escape);
    handlebars_helper!(snake_case: |x: str| x.to_snake_case());
    handlebars.register_helper("snake-case", Box::new(snake_case));
    handlebars_helper!(kebab_case: |x: str| x.to_kebab_case());
    handlebars.register_helper("kebab-case", Box::new(kebab_case));
    handlebars_helper!(pascal_case: |x: str| x.to_camel_case());
    handlebars.register_helper("pascal-case", Box::new(pascal_case));
    handlebars_helper!(string_contains: |x: str, y: str| x.contains(y));
    handlebars.register_helper("string-contains", Box::new(string_contains));
    handlebars_helper!(crate_name: |x: str| x.split("::").next().unwrap());
    handlebars.register_helper("crate-name", Box::new(crate_name));
    handlebars_helper!(skip_crate_name: |x: str| x.splitn(2, "::").skip(1).collect::<String>());
    handlebars.register_helper("skip-crate-name", Box::new(skip_crate_name));
    handlebars_helper!(is_stdlib: |x: str| x.starts_with("std::"));
    handlebars.register_helper("is-stdlib", Box::new(is_stdlib));
    let tpl = include_str!("main.rs.tpl");
    let content = handlebars.render_template(tpl, &settings)?;
    fs::write(cli.output_dir.join("main.rs"), content)?;
    if cli.override_impl {
        let tpl = include_str!("main_impl.rs.tpl");
        let content = handlebars.render_template(tpl, &settings)?;
        fs::write(cli.output_dir.join("main_impl.rs"), content)?;
    }

    Ok(())
}

fn main() {
    pretty_env_logger::init();
    if let Err(why) = run() {
        error!("{}", why);
        process::exit(1);
    }
}
