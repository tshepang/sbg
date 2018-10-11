use std::{
    error::Error,
    {{~ #each imports as |import| }}
    {{~ #if (is-stdlib import) }}
    {{~ skip-crate-name import }},
    {{~ /if }}
    {{~ /each }}
};
{{ #each imports as |import| }}
{{~ #unless (is-stdlib import) }}
use {{ import }};
{{~ /unless }}
{{~ /each }}
{{~ #each cli }}
{{~ #if nested }}
{{~ #each nested }}
pub(crate) fn {{ snake-case ../name }}_{{ snake-case name }}(
    {{~ #each args }}
    {{ snake-case name }}: {{ type }},
    {{~ /each }}
) -> Result<(), Box<Error>> {
    unimplemented!();
}
{{ /each }}
{{ else }}
pub(crate) fn {{ snake-case name }}(
    {{~ #each args }}
    {{ snake-case name }}: {{ type }},
    {{~ /each }}
) -> Result<(), Box<Error>> {
    unimplemented!();
}
{{~ /if }}
{{~ /each ~}}
