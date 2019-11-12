use std::{error::Error, path::PathBuf};

use url::Url;
pub(crate) fn simple() -> Result<(), Box<Error>> {
    unimplemented!();
}
pub(crate) fn not_so_simple(some_arg: String, some_other_arg: PathBuf) -> Result<(), Box<Error>> {
    unimplemented!();
}
pub(crate) fn complex_nested_subcommand(
    some_arg: String,
    some_other_arg: Url,
) -> Result<(), Box<Error>> {
    unimplemented!();
}

pub(crate) fn complex_nested_subcommand_without_args() -> Result<(), Box<Error>> {
    unimplemented!();
}
