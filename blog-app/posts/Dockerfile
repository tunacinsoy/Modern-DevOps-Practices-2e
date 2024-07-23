# With this updated Dockerfile, the image size is reduced from 221MB to 83.8MB while performing the same functionality

# Setting the base image
FROM python:3.13.0b4-alpine3.20

# Setting environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Downloading necessary packages
# Why --no-cache?
# When you install packages using apk add, it fetches the package index to determine what packages are available and their dependencies.
# By default, this index is cached to speed up subsequent installations. However, this cache is typically not needed after the packages have been installed.
# Using --no-cache tells apk to not save this index on disk, which helps keep the Docker image smaller.
# Thus, using --no-cache ensures that you always download the most current package index and packages, resulting in a cleaner and more consistent build environmen
# Why gcc?
# Purpose: gcc is a compiler that compiles C and C++ code.
# Why Needed: Some Python packages include C extensions (parts of the package are written in C for performance reasons). These extensions need to be compiled when the package is installed.
# Example: Packages like numpy, pandas, and scipy often require compilation of C extensions.
# Why musl-dev?
# Purpose: musl is an implementation of the standard library for the C programming language. musl-dev includes the headers and libraries needed for development.
# Why Needed: Many Python packages that include C extensions rely on standard C library headers and functions. Without these headers, the compilation would fail.
# Example: Any package that uses standard C library functions during compilation will need musl-dev.
# Why linux-headers?
# Purpose: Linux headers provide the necessary files for compiling code that interacts with the Linux kernel.
# Why Needed: While not always required, some packages might need to interact with kernel-specific features or rely on kernel headers for certain operations.
# Example: This is less common but can be necessary for packages that deal with low-level system operations or network functionalities.
# However, we do not need any of these packages, so we can ignore this directive.
# RUN apk add --no-cache gcc musl-dev linux-headers

# Changing working directory to segregate the application
WORKDIR /app

# Copying requirements.txt file to install dependencies
# Why copy requirements.txt first and copy rest of them later?
# Layer Caching: Docker builds images in layers. When you change a file, only the layers after that file has been copied will need to be rebuilt.
# If requirements.txt hasn't changed, Docker can reuse the cached layer, speeding up the build process.
# Efficient Dependency Management: Installing dependencies from requirements.txt is often time-consuming.
# By copying requirements.txt and running pip install before copying the rest of the code, you ensure that this step is cached and only re-run if requirements.txt changes.
# Frequent Code Changes: Application code changes more frequently than dependencies.
# By copying the rest of the code later, you reduce the need to re-install dependencies when you change your application code.
COPY requirements.txt requirements.txt

# Install necessary dependencies
RUN pip install -r requirements.txt

# Copy rest of the application without .github folder (.dockerignore file has been created)
COPY . .

# Run unit tests
RUN python app.test.py

# Expose the application
EXPOSE 5000

# Here, ENTRYPOINT ensures that flask is always executed,
# while CMD provides the default subcommand run, which can be overridden by specifying another subcommand like shell.
# Running `docker run myflaskapp` results in `flask run`.
# Running `docker run myflaskapp shell` results in `flask shell`.
ENTRYPOINT ["flask"]
CMD ["run"]
