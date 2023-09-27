![octocatalog_logo](https://github.com/gwenwindflower/octocatalog/assets/91998347/536751f0-8785-4d7b-a7c1-5249995b23ed)

# 😸 Welcome to the `octocatalog` 💾

![CI Checks](https://github.com/gwenwindflower/octocatalog/actions/workflows/ci.yml/badge.svg)

This is an open-source, open-data data-platform-in-a-box[^1] based on [DuckDB](https://duckdb.org/) + [dbt](https://www.getdbt.com/) + [Evidence](https://evidence.dev/). It offers a simple script to extract and load (EL) data from the [GitHub Archive](https://www.gharchive.org/), a dbt project built on top of this data inside a DuckDB database, and BI tooling via Evidence to analyze and present the data.

It runs completely local or inside of a devcontainer, but can also run on [MotherDuck](https://motherduck.com/) as a production target. Some (me) call it the Quack Stack.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#github.com/gwenwindflower/octocatalog)<br />
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/gwenwindflower/octocatalog)

Most of the below setup will be done for you automatically if you choose one of the devcontainer options above, so feel free to skip to the [Extract and Load](#extract-and-load) section if you're using one of those.

> [!NOTE]
> **What's with the name?** GitHub's mascot is the [octocat](https://octodex.github.com/), and this project is a catalog of GitHub data. The octocat absolutely rules, I love them, I love puns, I love data, and here we are.

## 👷🏻‍♀️ Setup 🛠️

There are a few steps to get started with this project. We'll need to:

1. [Clone the project locally](#-clone-the-project-locally-).
2. [Set up Python, then install the dependencies and other tooling.](#-python-)
3. [Extract and load the data into DuckDB.](#-extract-and-load-)
4. Transform the data with dbt.
5. Build the BI platform with Evidence.

## 🐙 Clone the project locally 😸

Coming shortly.

### 🐍 Python 💻

You likely already have relatively recent version of Python 3 installed on your system. If you use the devcontainer options above it will be installed for you. If not, we recommend using `pyenv` to manage your python versions. You should be fine with anything between 3.7 and 3.11.

I highly recommnend aliasing `python3` to just `python` in your shell. This will ensure you're using the right version of python and save you some thinking and typing. There's generally no practical reason the majority of data folks would ever need to use Python 2 at this point, and if you do, you probably know what you're doing an don't need this guide 😅. To alias python you can add this to your `.bashrc` or `.zshrc`:

```shell
alias python=python3
```

The rest of this guide will assume you've got `python3` aliased to `python`, but if you don't you'll need to replace `python` with `python3` in the commands below.

Once you have python installed you'll want to set up a virtual environment in the project directory. This will ensure the dependencies that we install are scoped to this project, and not globally on your system. I like to call my virtual environments `.venv` but you can call them whatever you want. You can do this with:

```shell
python -m venv .venv
```

> [!NOTE]
> **What's this `-m` business?**
> The `-m` stands for module and tells python to run the `venv` module as a script. It's a good practice to do this with `pip` as well, like `python -m pip install [package]` to ensure you're using the right version of pip for the python interpret you're calling. You can run any available python module as a script this way, though it's most commonly used with standard library modules like `venv` and `pip`.

Once we've got a Python virtual environment set up we'll need to activate it. You can do this with:

```shell
source .venv/bin/activate
```

> [!NOTE]
> **`source` what now?**
> This may seem magical and complex, "virtual environments" sounds like some futuristic terminology from Blade Runner, but it's actually pretty simple. You have an important environment variable on your machine called `PATH`. It specifices a list of directories that should be looked through, in order of priority, when you call a command like `ls` or `python` or `dbt`. The first match your computer gets it will run that command. What the `activate` script does is make sure the virtual environment folder we just created gets put at the front of that list. This means that when you run `python` or `dbt` or `pip` it will look in the virtual environment folder first, and if it finds a match it will run that. This is how we can install specific versions of packages like `dbt` and `duckdb` into our project and not have to worry about them conflicting with other versions of those packages in other projects.

Now that we're in an isolated virtual environment we can install the dependencies for this project. You can do this with:

```shell
python -m pip install -r requirements.txt
```

> [!NOTE]
> **`-r` u kidding me?** Last thing I promise! The `-r` flag tells `pip` to install all the packages listed in the file that follows it. In this case we're telling pip to install all the packages listed in the `requirements.txt` file. This is a common pattern in Python projects, and you'll see it a lot.

#### Putting it all together

Now you know getting a typical Python project set up is as easy as 1-2-3:
```shell
python -m venv .venv # Create a virtual environment
source .venv/bin/activate # Activate the virtual environment
python -m pip install -r requirements.txt # Install the dependencies into the virtual environment
```

## 🦆 Extract and Load 📥

You've go two options here: you can [run the `el` scripts directly](#-running-the-el-script-directly-%EF%B8%8F) or you can use [Task](#-task-runner-%EF%B8%8F) to make things a little easier. We recommend the latter, but it's up to you. If you're using one of the devcontainer options above Task is already installed for you.

> [!NOTE]
> **Careful of data size**. DuckDB is an in-process database engine, which means it runs primarily in memory. This is great for speed and ease of use, but it also means that it's limited by the amount of memory on your machine. The GitHub Archive data is event data that stretches back years, so is very large, and you'll likely run into memory issues if you try to load more than a few days of data at a time. We recommend using a single hour when developing, and only reaching for a larger amount of data for analysis. We're working on some better options here!

### 👟 Task runner 🏃🏻‍♀️

There are some basic tasks included using my preferred task runner [Task](https://taskfile.dev/#/). This is optional for your convenience, you can also [run the `el.py` script directly with Python](#-running-the-el-script-directly-). You can install it with most package managers:

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
task bi # serve the Evidence project locally for development
```

### 🐍 Running the EL script directly 🏗️

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
