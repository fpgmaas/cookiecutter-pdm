# syntax=docker/dockerfile:1

FROM python:3.10-slim-buster

# Set work directory
WORKDIR /code

# Install PDM
RUN pip install pdm

# Copy only requirements to cache them in docker layer
COPY pdm.lock pyproject.toml /code/

# Project initialization:
RUN pdm install --no-self

# Copy Python code to the Docker image
COPY {{cookiecutter.project_slug}}/ /code/{{cookiecutter.project_slug}}//

CMD [ "python", "{{cookiecutter.project_slug}}//foo.py"]
