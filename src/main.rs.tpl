#[macro_use]
extern crate log;
extern crate pretty_env_logger;
#[macro_use]
extern crate structopt;
extern crate url;

use std::{
    error::Error,
    path::PathBuf,
    process,
};

use structopt::{clap::AppSettings, StructOpt};
use url::Url;

#[derive(StructOpt)]
#[structopt(raw(global_setting = "AppSettings::VersionlessSubcommands"))]
#[structopt(raw(global_setting = "AppSettings::DisableHelpSubcommand"))]
enum Opt {
    {{~ #each specs }}
    {{~ #if help }}
    /// {{ help }}
    {{~ /if }}
    #[structopt(name = "{{ kebab-case name }}")]
    {{~ #if args }}
    {{ pascal-case name }} {
        {{~ #each args }}
        {{~ #if help }}
        /// {{ help }}
        {{~ /if }}
        {{~ #if positional }}
        {{~ #if (string-contains type "PathBuf") }}
        #[structopt(parse(from_os_str))]
        {{~ /if }}
        {{~ else }}
        #[structopt(long = "{{ kebab-case name }}"{{~ #if (string-contains type "PathBuf") }}, parse(from_os_str){{ /if }})]
        {{~ /if }}
        {{~ #if type }}
        {{ snake-case name }}: {{ type }},
        {{~ else }}
        {{ snake-case name }}: bool,
        {{~ /if }}
        {{~ /each }}
    },
    {{~ else }}
    {{~ #if nested }}
    {{ pascal-case name }}({{ pascal-case name }}Type),
    {{~ else }}
    {{ pascal-case name }} {},
    {{~ /if }}
    {{~ /if }}
    {{~ /each }}
}
{{~ #each specs }}
{{~ #if nested }}

#[derive(StructOpt)]
enum {{ pascal-case name }}Type {
    {{~ #each nested }}
    {{~ #if help }}
    /// {{ help }}
    {{~ /if }}
    #[structopt(name = "{{ kebab-case name }}")]
    {{ pascal-case name }} {
        {{~ #each args }}
        {{~ #if help }}
        /// {{ help }}
        {{~ /if }}
        {{~ #if positional }}
        {{~ #if (string-contains type "PathBuf") }}
        #[structopt(parse(from_os_str))]
        {{~ /if }}
        {{~ else }}
        #[structopt(long = "{{ kebab-case name }}"{{~ #if (string-contains type "PathBuf") }}, parse(from_os_str){{ /if }})]
        {{~ /if }}
        {{~ #if type }}
        {{ snake-case name }}: {{ type }},
        {{~ else }}
        {{ snake-case name }}: bool,
        {{~ /if }}
        {{~ /each }}
    },
    {{~ /each }}
}
{{~ /if }}
{{~ /each }}

fn run() -> Result<(), Box<Error>> {
    let cli = Opt::from_args();
    use Opt::*;
    match cli {
        {{~ #each specs }}
        {{~ #if nested }}
        {{ pascal-case name }}({{ snake-case name }}) => {
            use {{ pascal-case name }}Type::*;
            match {{ snake-case name }} {
                {{~ #each nested }}
                {{ pascal-case name }} {
                {{~ #each args }}
                    {{ snake-case name }},
                {{~ /each }}
                } => {
                    unimplemented!();
                }
                {{~ /each }}
            }
        }
        {{~ else }}
        {{ pascal-case name }} {
        {{~ #each args }}
            {{ snake-case name }},
        {{~ /each }}
        } => {
            unimplemented!();
        }
        {{~ /if }}
        {{~ /each }}
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
