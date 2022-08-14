#[macro_use]
extern crate log;
extern crate pretty_env_logger;
#[macro_use]
extern crate structopt;
extern crate url;

use std::{
    error::Error,
    process,
    path::PathBuf,
};

use structopt::{clap::AppSettings, StructOpt};
use url::Url;

mod main_impl;

#[derive(StructOpt)]
#[structopt(raw(global_setting = "AppSettings::VersionlessSubcommands"))]
#[structopt(raw(global_setting = "AppSettings::DisableHelpSubcommand"))]
enum Opt {
    /// subcommand without args
    #[structopt(name = "simple")]
    Simple {},
    /// subcommand with args
    #[structopt(name = "not-so-simple")]
    NotSoSimple {
        /// some-help help
        some_arg: String,
        #[structopt(long = "some-other-arg", parse(from_os_str))]
        some_other_arg: PathBuf,
    },
    /// subcommand with args
    #[structopt(name = "complex")]
    Complex(ComplexType),
}

#[derive(StructOpt)]
enum ComplexType {
    #[structopt(name = "nested-subcommand")]
    NestedSubcommand {
        /// helped for nested subcommand arg
        #[structopt(long = "some-arg")]
        some_arg: String,
        #[structopt(long = "some-other-arg")]
        some_other_arg: Url,
    },
    #[structopt(name = "nested-subcommand-without-args")]
    NestedSubcommandWithoutArgs {
    },
}

fn run() -> Result<(), Box<Error>> {
    let cli = Opt::from_args();
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

fn main() {
    pretty_env_logger::init();
    if let Err(why) = run() {
        error!("{}", why);
        process::exit(1);
    }
}
