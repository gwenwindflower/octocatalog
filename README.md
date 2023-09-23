# 😸 Welcome to the `octocatalog` 💾

This is a data-platform-in-a-box[^1] based on DuckDB + dbt + Evidence. It offers a simple script to extract and load (EL) data from the [GitHub Archive](https://www.gharchive.org/), a dbt project built on top of this data inside a DuckDB database, and BI tooling via Evidence to analyze and present the data.

It runs completely local or inside of a devcontainer. Some (me) call it the Quack Stack.

There are some basic tasks included using my preferred task runner [task](https://taskfile.dev/#/). You can install it on macOS with:

```shell
brew install go-task
```

Tasks included are:

```shell
task extract # pull data from github archive for the past day into the data/ directory
task load # load data from the data/ directory into duckdb
task el # run both extract and load
```

You can also manually run the `el.py` script with `python3 el.py [args]` to pull a custom date range. Please note that the GitHub Archive is only available from 2011-02-12 to the present day and that being event data it is very large. Running more than a few days or weeks will push the limits of DuckDB (that's part of the interest and goal of this project though so have at).

The args are:

```shell
python3 el.py [start_date in YYYY-MM-DD format] [end_date in YYYY-MM-DD format] [-e --extract Run the extract part only] [-l --load Run the load part only]
```

The `-e` and `-l` flags default to true and will run both parts of the script if not specified, so `-el` is the same as not specifying any flags.

In order for Evidence to work the DuckDB file needs to be built into the `./reports/` directory. If you're looking to access it via the DuckDB CLI you can find it at `./reports/gharchive.db`.

![kim was right](https://github.com/gwenwindflower/octocatalog/assets/91998347/adb3fb70-c666-4d54-9e0c-86600692603b)

[^1]: Based on the patterns developed by Jacob Matson for the original [MDS-in-a-box](https://duckdb.org/2022/10/12/modern-data-stack-in-a-box.html)https://duckdb.org/2022/10/12/modern-data-stack-in-a-box.html.
