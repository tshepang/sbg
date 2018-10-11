{{~ #each cli }}
{{~ #if nested }}
{{~ #each nested }}
{{ ../name }} {{ kebab-case name }}
{{~ #each args }}
{{~ #if positional }} <{{ kebab-case name }}>{{ #if (string-contains type "Vec") }}..{{ /if}}
{{~ else }} [--{{~ kebab-case name }}{{ #unless (string-eq type "bool") }} <value>{{ /unless }}{{ #if (string-contains type "Vec") }}..{{ /if}}]
{{~ /if }}
{{~ /each }}
{{~ /each }}
---
{{~ else }}
{{~ name }}
{{~ #if args }}
{{~ #each args }}
{{~ #if positional }} <{{ kebab-case name }}>{{ #if (string-contains type "Vec") }}..{{ /if}}
{{~ else }} [--{{~ kebab-case name }}{{ #unless (string-eq type "bool") }} <value>{{ /unless }}{{ #if (string-contains type "Vec") }}..{{ /if}}]
{{~ /if }}
{{~ /each }}
{{~ /if }}
---
{{~ /if }}
{{~ /each }}
