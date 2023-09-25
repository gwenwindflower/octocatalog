![octocatalog_logo](https://github.com/gwenwindflower/octocatalog/assets/91998347/536751f0-8785-4d7b-a7c1-5249995b23ed)

# 😸 Welcome to the `octocatalog` 💾

![CI Checks](https://github.com/gwenwindflower/octocatalog/actions/workflows/ci.yml/badge.svg)

This is an open-source, open-data data-platform-in-a-box[^1] based on [DuckDB](https://duckdb.org/) + [dbt](https://www.getdbt.com/) + [Evidence](https://evidence.dev/). It offers a simple script to extract and load (EL) data from the [GitHub Archive](https://www.gharchive.org/), a dbt project built on top of this data inside a DuckDB database, and BI tooling via Evidence to analyze and present the data.

It runs completely local or inside of a devcontainer, but can also run on [MotherDuck](https://motherduck.com/) as a production target. Some (me) call it the Quack Stack.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#github.com/gwenwindflower/octocatalog)<br />
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/gwenwindflower/octocatalog)

## 👟 Task runner 🏃🏻‍♀️
There are some basic tasks included using my preferred task runner [Task](https://taskfile.dev/#/). This is optional for your convenience, you can also [run the `el.py` script directly with Python](#running-the-el-script-directly). You can install it with most package managers:

<details>

  <summary>macOS</summary>
  <br>
  Using Homebrew:

  ```shell
  brew install go-task
  ```

</details>
<details>

  <summary>Windows</summary>
  <br>
  Using Chocolatey:

  ```shell
  choco install go-task
  ```

  Using Scoop:

  ```shell
  scoop install task
  ```

</details>
<details>

  <summary>Linux</summary>
  <br>
  Using Yay:

  ```shell
  yay -S go-task-bin
  ```

</details>

More install methods are [detailed in the Task docs](https://taskfile.dev/installation/).

Tasks included are:

```shell
task extract # pull data from github archive for the past day into the data/ directory
task load # load data from the data/ directory into duckdb
task transform # run the dbt transformations
task [*]-prod # all tasks can be run in a 'prod-mode' against a MotherDuck cloud warehouse
```

## 🐍 Running the EL script directly 🏗️
You can also manually run the `el.py` script with `python3 el.py [args]` to pull a custom date range, run on small test data file, and isolate the extract or load steps. Please note that the GitHub Archive is available from 2011-02-12 to the present day and that being event data it is very large. Running more than a few days or weeks will push the limits of DuckDB (that's part of the interest and goal of this project though so have at).

The args are:

```shell
python3 el.py [start_date in YYYY-MM-DD format, defaults to yesterday] [end_date in YYYY-MM-DD format, defaults to today] [-e --extract Run the extract part only] [-l --load Run the load part only] [-p --prod Run in production mode against MotherDuck]
```

Running the the `el.py` script without an `-e` or `-l` flag is a no-op as all flags default to `false`. Combine the flags to create the commands you want to run. For example:

```shell
python3 el.py -e # extract the data for the past day
python3 el.py -lp # load any data into the production database
python3 el.py 2023-09-20 2023-09-23 -elp # extract and load 3 days of data into the production database
```

In order for Evidence to work the DuckDB file needs to be built into the `./reports/` directory. If you're looking to access it via the DuckDB CLI you can find it at `./reports/github_archive.db`.

![kim was right](https://github.com/gwenwindflower/octocatalog/assets/91998347/adb3fb70-c666-4d54-9e0c-86600692603b)

---

## 💅🏾 Modeling the event data ✨

Schemas for the event data [are documented here](https://docs.github.com/en/rest/overview/github-event-types?apiVersion=2022-11-28).

So far we've modeled:

- [x] Issues
- [x] Pull Requests
- [x] Users
- [x] Repos
- [ ] Stars
- [ ] Forks
- [ ] Comments
- [ ] Pushes

![5d3aea93a0c5762db6cbee9cf55e25b5](https://github.com/gwenwindflower/octocatalog/assets/91998347/67494c8e-cf08-4d46-8814-b97911797ebf)

[^1]: Based on the patterns developed by Jacob Matson for the original [MDS-in-a-box](https://duckdb.org/2022/10/12/modern-data-stack-in-a-box.html).
