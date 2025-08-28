# Demo Jenkins Docker Project

This project provides a Docker setup for running Jenkins with Python and additional dependencies.

## Contents
- `Dockerfile`: Builds a Jenkins-based image with Python, pip, and other tools installed.
- `requirements.txt`: Python dependencies to be installed in the container.

## Usage

1. **Build the Docker image:**
   ```bash
   docker build -t demojenkins .
   ```
2. **Run the container:**
   ```bash
   docker run -p 8080:8080 -p 50000:50000 demojenkins
   ```

Jenkins will be available at `http://localhost:8080`.

## Notes
- The Dockerfile switches to the root user to install system packages, then back to the Jenkins user for security.
- Python dependencies are installed in a virtual environment inside the container.

---

Feel free to modify the `requirements.txt` to add or remove Python packages as needed.
