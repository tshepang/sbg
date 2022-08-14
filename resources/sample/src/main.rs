use std::{
    path::PathBuf,
};

use anyhow::Result;
use clap::Parser;
use url::Url;

mod main_impl;

#[derive(Parser)]
#[clap(disable_help_subcommand = true)]
enum Opt {
    /// subcommand without args
    Simple {},
    /// subcommand with args
    NotSoSimple {
        /// some-help help
        some_arg: String,
        some_other_arg: PathBuf,
    },
    /// subcommand with args
    #[clap(subcommand)]
    Complex(ComplexType),
}

#[derive(Parser)]
enum ComplexType {
    NestedSubcommand {
        /// helped for nested subcommand arg
        some_arg: String,
        some_other_arg: Url,
    },
    NestedSubcommandWithoutArgs {
    },
}

fn main() -> Result<()> {
    let cli = Opt::parse();
    use Opt::*;
    match cli {
        Simple {
        } => {
            main_impl::simple(
            )?
        }
        NotSoSimple {
            some_arg,
            some_other_arg,
        } => {
            main_impl::not_so_simple(
                some_arg,
                some_other_arg,
            )?
        }
        Complex(complex) => {
            use ComplexType::*;
            match complex {
                NestedSubcommand {
                    some_arg,
                    some_other_arg,
                } => {
                    main_impl::complex_nested_subcommand(
                        some_arg,
                        some_other_arg,
                    )?
                }
                NestedSubcommandWithoutArgs {
                } => {
                    main_impl::complex_nested_subcommand_without_args(
                    )?
                }
            }
        }
    }
    Ok(())
}
