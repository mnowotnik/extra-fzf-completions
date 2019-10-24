# extra-fzf-completions 
Simple, seamless fzf-based completions for a few applications

# !! In ALPHA !!
Project is actively evolving so expect breaking changes and bugs!

# Do you have a suggestion?

If you have a suggestion regarding expanding functionality i.e., adding more
completions, supported applications etc. then create an issue! Feedback is appreciated.

# List of supported applications:

- docker
- kubectl
- [jira](https://github.com/go-jira/jira)

# Installation

## zsh

Preferably use package manager like zgen and add to your .zshrc:

```sh
zgen load mnowotnik/extra-fzf-completions
```

Or simply clone and source:

```sh
source /path/to/extra-fzf-completions/extra-fzf-completions.plugin.zsh
```

## bash

Clone and:

```sh
source /path/to/extra-fzf-completions/extra-fzf-completions.plugin.bash
```

# Usage

Supported commands are of type:

```sh
<command> <action(s)> **<TAB>
```

The fzf-powered fuzzy completion should appear after pressing TAB.

## Configuration

First, enable completion in your zshrc or bashrc file:

```sh
export EXTRA_FZF_COMPLETIONS=(docker kubectl jira)
```

## docker

Docker completion supports a couple of actions:
- `run` <- docker image completion
- `exec` <- container completion
- `rm`  <- image completion
- `stop` <- container completion

## kubectl

Currently only completes pod names. Detects namespace if defined or uses the default one.

```sh
kubectl logs -n my_ns **<TAB>
```

## jira

Provides a list of issues using the default user configuration.

```sh
jira <action> **<TAB>
```

# Additional configuration

Some settings are controled through environment variables:

- `EXTRA_FZF_COMPLETIONS_FZF_PREFIX` - overrides default fzf prefix used in completions.
- `EXTRA_FZF_COMPLETIONS_TIMEOUT` - the completion timeout in seconds (default 7).

