# Testing Environments

This section covers test infrastructure and environments that can be spun up using Forklift.

 * [Bats Testing](#bats-testing)
 * [Running Robottelo Tests](#running-robottelo-tests)

## Bats Testing

Included with forklift is a small live test suite.  The current tests are:

  * fb-test-foreman.bats - Runs a few simple tests for Foreman
  * fb-test-katello.bats - Runs a few simple tests for Katello
  * fb-content-katello.bats - Runs tests against content features
  * fb-proxy.bats - Runs tests against content proxy features
  * fb-destroy-organization.bats - Cleans up after the content tests
  * fb-finish.bats - Collects logs pertinent to the bats run

To execute the bats framework:

 * Using vagrant (after configuring vagrant according to this document):

```bash
vagrant up centos7-foreman-bats-ci
```

To run the same setup run by CI system:

```bash
cp boxes.yaml.example boxes.yaml
vagrant up centos7-foreman-bats-ci
```

If you are making changes to bats tests and want to test your updates, edit `centos7-foreman-bats-ci` to include:

```yaml
centos7-foreman-bats-ci:
  box: centos7
  ansible:
    playbook: 'playbooks/bats_pipeline_foreman_nightly.yml'
    group: 'bats'
    # Add the following part
    variables:
      bats_forklift_dir: /vagrant
      bats_update_forklift: "no"
```

Or if you want to run bats from a different repository or branch, edit `centos7-foreman-bats-ci` to include:

```yaml
centos7-foreman-bats-ci:
  box: centos7
  ansible:
    playbook: 'playbooks/bats_pipeline_foreman_nightly.yml'
    group: 'bats'
    # Add the following part
    variables:
      bats_forklift_repo: https://github.com/<YOUR_NAME>/forklift.git
      bats_forklift_version: your-branch
```

## Pipeline Testing

Under `pipelines` are a series of playbooks designed around testing scenarios for various version of the Foreman and Katello stack. Use `./bin/forklift --help` to find out which ones and their aguments.

```console
$ ./bin/forklift --help
usage: forklift [-h] action ...

positional arguments:
  action      which action to execute
    install   Run an install pipeline
    upgrade   Run an upgrade pipeline

optional arguments:
  -h, --help  show this help message and exit
```

Individual pipelines also have help texts:
```console
$ ./bin/forklift install --help
usage: forklift install [-h] [-v] [-e EXTRA_VARS] [--state FORKLIFT_STATE]
                        [--os PIPELINE_OS] [--type PIPELINE_TYPE]
                        [--version PIPELINE_VERSION]

Run an install pipeline

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         verbose output
  --state FORKLIFT_STATE
                        Forklift state to ensure
  --os PIPELINE_OS      Operating system to install, like centos7, debian10 or
                        ubuntu1804
  --type PIPELINE_TYPE  Type of pipeline, like foreman, katello or luna
  --version PIPELINE_VERSION
                        Version to install, like nightly, 1.24 or 3.14

advanced arguments:
  -e EXTRA_VARS, --extra-vars EXTRA_VARS
                        set additional variables as key=value or YAML/JSON, if
                        filename prepend with @
```

Pipelines typically have a state which defaults to `up`. Other valid values are `rebuild` and `destroy`. The latter one is useful to clean up which pipelines don't do by themselves.

For example to run a Foreman Nightly installation pipeline on Debian Buster:

```console
$ ./bin/forklift install --os debian10 --type foreman --version nightly
... lots of output
$ ./bin/forklift install --os debian10 --type foreman --version nightly --state destroy
```

Similarly a Katello Nightly upgrade pipeline on CentOS 7:

```console
$ ./bin/forklift upgrade --os centos7 --type katello --version nightly
... lots of output
$ ./bin/forklift upgrade --os centos7 --type katello --version nightly --state destroy
```

## Running Robottelo Tests

Robottelo is a test suite for excercising Foreman and Katello. Forklift provides a role for Robottelo to set up and run tests against your machine. Configuration options of interest are `robottelo_test_endpoints` where you can pass a list of endpoints (api, cli or ui), and `robottelo_test_type`, which is one of:

- tier1 to tier4 - base test sets, tier1 tests can resemble unit testing, higher tiers require more extensive setup
- destructive - tests that restart or rename the server
- upgrade - a selection of tests from tiers used in post-upgrade testing, should exercise the core functionality in less time consuming way
- endtoend - testing the essential user scenario, less time-consuming than the upgrade set

 * [Robottelo repository](https://github.com/SatelliteQE/robottelo)
 * [Robottelo documentation](https://robottelo.readthedocs.io/en/latest/)
