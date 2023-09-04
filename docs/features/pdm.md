# Dependency management with PDM


The generated repository will uses [PDM](https://pdm.fming.dev/latest/)
for its dependency management. When you have created your repository
using this cookiecutter template, a PDM environment is pre-configured
in `pyproject.toml`. All you need to do is add your
project-specific dependencies with

``` bash
pdm add <package>
```

and then install the environment with

``` bash
pdm install
```

By default, the environment is created in a `.venv` folder.
