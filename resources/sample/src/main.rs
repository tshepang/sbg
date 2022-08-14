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
    #[clap(name = "simple")]
    Simple {},
    /// subcommand with args
    #[clap(name = "not-so-simple")]
    NotSoSimple {
        /// some-help help
        some_arg: String,
        #[clap(long = "some-other-arg")]
        some_other_arg: PathBuf,
    },
    /// subcommand with args
    #[clap(name = "complex")]
    #[clap(subcommand)]
    Complex(ComplexType),
}

#[derive(Parser)]
enum ComplexType {
    #[clap(name = "nested-subcommand")]
    NestedSubcommand {
        /// helped for nested subcommand arg
        #[clap(long = "some-arg")]
        some_arg: String,
        #[clap(long = "some-other-arg")]
        some_other_arg: Url,
    },
    #[clap(name = "nested-subcommand-without-args")]
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
