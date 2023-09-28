![octocatalog_logo](https://github.com/gwenwindflower/octocatalog/assets/91998347/536751f0-8785-4d7b-a7c1-5249995b23ed)

# 😸 Welcome to the `octocatalog` 💾

![CI Checks](https://github.com/gwenwindflower/octocatalog/actions/workflows/ci.yml/badge.svg)

This is an open-source, open-data data-platform-in-a-box[^1] based on [DuckDB](https://duckdb.org/) + [dbt](https://www.getdbt.com/) + [Evidence](https://evidence.dev/). It offers a simple script to extract and load (EL) data from the [GitHub Archive](https://www.gharchive.org/), a dbt project built on top of this data inside a DuckDB database, and BI tooling via Evidence to analyze and present the data.

It runs completely local or inside of a devcontainer, but can also run on [MotherDuck](https://motherduck.com/) as a production target. Some (me) call it the Quack Stack.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#github.com/gwenwindflower/octocatalog)<br />
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/gwenwindflower/octocatalog)

Most of the below setup will be done for you automatically if you choose one of the devcontainer options above, so feel free to skip to the [Extract and Load](#-extract-and-load-) section if you're using one of those.

> [!NOTE] > **What's with the name?** GitHub's mascot is the [octocat](https://octodex.github.com/), and this project is a catalog of GitHub data. The octocat absolutely rules, I love them, I love puns, I love data, and here we are.

![kim was right](https://github.com/gwenwindflower/octocatalog/assets/91998347/adb3fb70-c666-4d54-9e0c-86600692603b)

## 👷🏻‍♀️ Setup 🛠️

There are a few steps to get started with this project. We'll need to:

1. [Clone the project locally](#-clone-the-project-locally-).
2. [Set up Python, then install the dependencies and other tooling.](#-python-)
3. [Extract and load the data into DuckDB.](#-extract-and-load-)
4. [Transform the data with dbt.](#%EF%B8%8F-transform-the-data-with-dbt-)
5. [Build the BI platform with Evidence.](#-build-the-bi-platform-with-evidence-)

## 🐙 Clone the project locally 😸

Coming shortly.

### Setup script

We encourage to to run the setup steps for the sake of understanding them more deeply and learning, but if they feel overwhelming or, conversely, you're experienced with this stack and want to go faster, we've included a `setup.sh` bash script that will do everything to get you to baseline functioning automatically. Just `source setup.sh` and have at.

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

> [!NOTE] > **What's this `-m` business?**
> The `-m` stands for module and tells python to run the `venv` module as a script. It's a good practice to do this with `pip` as well, like `python -m pip install [package]` to ensure you're using the right version of pip for the python interpret you're calling. You can run any available python module as a script this way, though it's most commonly used with standard library modules like `venv` and `pip`.

Once we've got a Python virtual environment set up we'll need to activate it. You can do this with:

```shell
source .venv/bin/activate
```

> [!NOTE] > **`source` what now?**
> This may seem magical and complex, "virtual environments" sounds like some futuristic terminology from Blade Runner, but it's actually pretty simple. You have an important environment variable on your machine called `PATH`. It specifices a list of directories that should be looked through, in order of priority, when you call a command like `ls` or `python` or `dbt`. The first match your computer gets it will run that command. What the `activate` script does is make sure the virtual environment folder we just created gets put at the front of that list. This means that when you run `python` or `dbt` or `pip` it will look in the virtual environment folder first, and if it finds a match it will run that. This is how we can install specific versions of packages like `dbt` and `duckdb` into our project and not have to worry about them conflicting with other versions of those packages in other projects.

Now that we're in an isolated virtual environment we can install the dependencies for this project. You can do this with:

```shell
python -m pip install -r requirements.txt
```

> [!NOTE] > **`-r` u kidding me?** Last thing I promise! The `-r` flag tells `pip` to install all the packages listed in the file that follows it. In this case we're telling pip to install all the packages listed in the `requirements.txt` file. This is a common pattern in Python projects, and you'll see it a lot.

#### Putting it all together

Now you know getting a typical Python project set up is as easy as 1-2-3:

```shell
python -m venv .venv # Create a virtual environment
source .venv/bin/activate # Activate the virtual environment
python -m pip install -r requirements.txt # Install the dependencies into the virtual environment
```

### Pre-commit

This project used [pre-commit](https://pre-commit.com/) to run basic checks for structure, style, and consistentcy. It's installed with the Python dependencies, but you'll need to run `pre-commit install` in the virutal environment to install the speciefic hooks defined by the checks in the `.pre-commit-config.yaml`. After that it will run all the checks on each commit automatically.

## 🦆 Extract and Load 📥

You've go two options here: you can [run the `el` scripts directly](#-running-the-el-script-directly-%EF%B8%8F) or you can use the configured [task runner](#-task-runner-%EF%B8%8F) to make things a little easier. We recommend the latter, but it's up to you. If you're using one of the devcontainer options above Task is already installed for you.

> [!NOTE] > **Careful of data size**. DuckDB is an in-process database engine, which means it runs primarily in memory. This is great for speed and ease of use, but it also means that it's limited by the amount of memory on your machine. The GitHub Archive data is event data that stretches back years, so is very large, and you'll likely run into memory issues if you try to load more than a few days of data at a time. We recommend using a single hour when developing, and only reaching for a larger amount of data for analysis. We're working on some better options here!

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

</detail
