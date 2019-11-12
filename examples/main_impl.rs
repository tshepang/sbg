use std::{error::Error, path::PathBuf};

use url::Url;
pub(crate) fn simple() -> Result<(), Box<dyn Error>> {
    unimplemented!();
}
pub(crate) fn not_so_simple(_some_arg: String, _some_other_arg: PathBuf) -> Result<(), Box<dyn Error>> {
    unimplemented!();
}
pub(crate) fn complex_nested_subcommand(
    _some_arg: String,
    _some_other_arg: Url,
) -> Result<(), Box<dyn Error>> {
    unimplemented!();
}

pub(crate) fn complex_nested_subcommand_without_args() -> Result<(), Box<dyn Error>> {
    unimplemented!();
}
