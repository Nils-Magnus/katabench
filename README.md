# katabench
Automated Installation and simple Benchmark of the Kata Container Runtime

This micro project installs the [Kata Container runtime](https://katacontainers.io) on top of a Ubuntu (16.04 LTS or 18.04 LTS) server with enabled VT-x, and then benchmarks it.

## Installation of Docker and Kata with `start-kata.sh`

The script installs a few helper packages, adds a new repository for Docker Community Edition, installs the software and enables the `ubuntu` user to use the container framework.
Then it adds another repository for Kata Containers, installs them, and creates a systemd unit that enables Kata as a new OCI compliant runtime and also defines this runtime as future default.
Henceforth containers that are started with, say, `docker run -it ubuntu` use the Kata runtime, not the former runc default.

## Performing a poor man's benchmark with `bench.sh`

The script starts a configurable number of Nginx webserver containers and creates some unique "content" for each of them. After the containers are all created, each of them is queried once to prevent caching effects. If you intend to benchmark your setup, run the script at least twice so you don't count in loading of the container image as well.

These script have been created as accompanying material for a talk at DevOpsCon 2018, in Munich, delivered by Nils Magnus <nils.magnus@t-systems.com>
