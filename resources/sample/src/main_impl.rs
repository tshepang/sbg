use std::{
    path::PathBuf,
};

use url::Url;
use anyhow::Result;

pub(crate) fn simple(
) -> Result<()> {
    unimplemented!();
}

pub(crate) fn not_so_simple(
    some_arg: String,
    some_other_arg: PathBuf,
) -> Result<()> {
    unimplemented!();
}

pub(crate) fn complex_nested_subcommand(
    some_arg: String,
    some_other_arg: Url,
) -> Result<()> {
    unimplemented!();
}

pub(crate) fn complex_nested_subcommand_without_args(
) -> Result<()> {
    unimplemented!();
}
