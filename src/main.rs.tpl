use std::{
    error::Error,
    process,
    {{ #each imports as |import| }}
    {{~ #if (is-stdlib import) }}
    {{~ skip-crate-name import }},
    {{~ /if }}
    {{~ /each }}
};

use clap::Parser;
{{~ #each imports as |import| }}
{{~ #unless (is-stdlib import) }}
use {{ import }};
{{~ /unless }}
{{~ /each }}

mod main_impl;

#[derive(Parser)]
#[clap(disable_help_subcommand = true)]
enum Opt {
    {{~ #each cli }}
    {{~ #if help }}
    /// {{ help }}
    {{~ /if }}
    #[clap(name = "{{ kebab-case name }}")]
    {{~ #if nested }}
    #[clap(subcommand)]
    {{~ /if }}
    {{~ #if args }}
    {{ pascal-case name }} {
        {{~ #each args }}
        {{~ #if help }}
        /// {{ help }}
        {{~ /if }}
        {{~ #if positional }}
        {{~ #if (string-contains type "PathBuf") }}
        #[clap(parse(from_os_str))]
        {{~ /if }}
        {{~ else }}
        #[clap(long = "{{ kebab-case name }}"{{~ #if (string-contains type "PathBuf") }}, parse(from_os_str){{ /if }})]
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
{{~ #each cli }}
{{~ #if nested }}

#[derive(Parser)]
enum {{ pascal-case name }}Type {
    {{~ #each nested }}
    {{~ #if help }}
    /// {{ help }}
    {{~ /if }}
    #[clap(name = "{{ kebab-case name }}")]
    {{ pascal-case name }} {
        {{~ #each args }}
        {{~ #if help }}
        /// {{ help }}
        {{~ /if }}
        {{~ #if positional }}
        {{~ #if (string-contains type "PathBuf") }}
        #[clap(parse(from_os_str))]
        {{~ /if }}
        {{~ else }}
        #[clap(long = "{{ kebab-case name }}"{{~ #if (string-contains type "PathBuf") }}, parse(from_os_str){{ /if }})]
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

fn run() -> Result<(), Box<dyn Error>> {
    let cli = Opt::from_args();
    use Opt::*;
    match cli {
        {{~ #each cli }}
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
                    main_impl::{{ snake-case ../name }}_{{ snake-case name }}(
                        {{~ #each args }}
                        {{ snake-case name }},
                        {{~ /each }}
                    )?
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
            main_impl::{{ snake-case name }}(
                {{~ #each args }}
                {{ snake-case name }},
                {{~ /each }}
            )?
        }
        {{~ /if }}
        {{~ /each }}
    }
    Ok(())
}

fn main() {
    pretty_env_logger::init();
    if let Err(why) = run() {
        log::error!("{}", why);
        process::exit(1);
    }
}
