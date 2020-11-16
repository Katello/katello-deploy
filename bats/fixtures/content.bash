# vim: ft=sh:sw=2:et

ORGANIZATION="Default Organization"
PRODUCT="Test Product"
CONTAINER_REPOSITORY="fedorassh"
FILE_REPOSITORY="file repo"
PUPPET_REPOSITORY="Puppet Modules"
YUM_REPOSITORY="Zoo"
YUM_REPOSITORY_2="modules-rpms"
YUM_REPOSITORY_3="rpm-deps"
LIFECYCLE_ENVIRONMENT="Library"
CONTENT_VIEW="Default Organization View"
CONTENT_VIEW_2="Component 1"
CONTENT_VIEW_3="Composite"
ACTIVATION_KEY="My_Activation_Key"
FILTER1="errata excluder"
FILTER2="rpm excluder"
FILTER3="modulemd includer"
HOSTGROUP="My_Hostgroup"

ORGANIZATION_LABEL="${ORGANIZATION/ /_}"
PRODUCT_LABEL="${PRODUCT/ /_}"
CONTAINER_REPOSITORY_LABEL="${CONTAINER_REPOSITORY/ /_}"
FILE_REPOSITORY_LABEL="${FILE_REPOSITORY/ /_}"
PUPPET_REPOSITORY_LABEL="${PUPPET_REPOSITORY/ /_}"
YUM_REPOSITORY_LABEL="${YUM_REPOSITORY/ /_}"
LIFECYCLE_ENVIRONMENT_LABEL="${LIFECYCLE_ENVIRONMENT/ /_}"
CONTENT_VIEW_LABEL="${CONTENT_VIEW/ /_}"
ACTIVATION_KEY_LABEL="${ACTIVATION_KEY/ /_}"
HOSTGROUP_LABEL="${HOSTGROUP/ /_}"
