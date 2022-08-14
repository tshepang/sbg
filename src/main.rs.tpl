use std::{
    {{ #each imports as |import| }}
    {{ #if (is-stdlib import) }}
    {{ skip-crate-name import }},
    {{ /if }}
    {{ /each }}
};

use anyhow::Result;
use clap::Parser;
{{ #each imports as |import| }}
{{ #unless (is-stdlib import) }}
use {{ import }};
{{ /unless }}
{{ /each }}

mod main_impl;

#[derive(Parser)]
#[clap(version, disable_help_subcommand = true)]
enum Opt {
    {{ #each cli }}
    {{ #if help }}
    /// {{ help }}
    {{ /if }}
    {{ #if nested }}
    #[clap(subcommand)]
    {{ /if }}
    {{ #if args }}
    {{ pascal-case name }} {
        {{ #each args }}
        {{ #if help }}
        /// {{ help }}
        {{ /if }}
        {{ #if type }}
        {{ snake-case name }}: {{ type }},
        {{ else }}
        {{ snake-case name }}: bool,
        {{ /if }}
        {{ /each }}
    },
    {{ else }}
    {{ #if nested }}
    {{ pascal-case name }}({{ pascal-case name }}Type),
    {{ else }}
    {{ pascal-case name }} {},
    {{ /if }}
    {{ /if }}
    {{ /each }}
}
{{ #each cli }}
{{ #if nested }}

#[derive(Parser)]
enum {{ pascal-case name }}Type {
    {{ #each nested }}
    {{ #if help }}
    /// {{ help }}
    {{ /if }}
    {{ pascal-case name }} {
        {{ #each args }}
        {{ #if help }}
        /// {{ help }}
        {{ /if }}
        {{ #if type }}
        {{ snake-case name }}: {{ type }},
        {{ else }}
        {{ snake-case name }}: bool,
        {{ /if }}
        {{ /each }}
    },
    {{ /each }}
}
{{ /if }}
{{ /each }}

fn main() -> Result<()> {
    let cli = Opt::parse();
    use Opt::*;
    match cli {
        {{ #each cli }}
        {{ #if nested }}
        {{ pascal-case name }}({{ snake-case name }}) => {
            use {{ pascal-case name }}Type::*;
            match {{ snake-case name }} {
                {{ #each nested }}
                {{ pascal-case name }} {
                {{ #each args }}
                    {{ snake-case name }},
                {{ /each }}
                } => {
                    main_impl::{{ snake-case ../name }}_{{ snake-case name }}(
                        {{ #each args }}
                        {{ snake-case name }},
                        {{ /each }}
                    )?
                }
                {{ /each }}
            }
        }
        {{ else }}
        {{ pascal-case name }} {
        {{ #each args }}
            {{ snake-case name }},
        {{ /each }}
        } => {
            main_impl::{{ snake-case name }}(
                {{ #each args }}
                {{ snake-case name }},
                {{ /each }}
            )?
        }
        {{ /if }}
        {{ /each }}
    }
    Ok(())
}
