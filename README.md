# Concourse Kaniko Resource
Concourse resource for build docker image with Kaniko.

## Usage
The **source** configuration for the resource is as follows:

**`docker_config_file`**: *Optional*. Specify the path to a docker config file with credentials for the registry you wish
to push the resulting image to.

## Behavior

### check
Not supported.

### in
Not supported.

### out
Build the specified Dockerfile and push the resulting Docker image to a registry.

#### Parameters
**`image_name`**: *Required*. The name of the resulting image.

**`tag_file`**: *Optional*. Path to a file containing the tag to use for the resulting image. If not specified the tag is set to `latest`.

**`build_context`**: *Required*. The path to the context to use for the Kaniko build.

**`dockerfile`**: *Optional*. The path to the Dockerfile to build. If not specified, set to `Dockerfile`.

**`registry`**: *Required*. The registry to push the resulting image to.