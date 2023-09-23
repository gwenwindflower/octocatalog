# Welcome to the `octocatalog`

This is a data-platform-in-a-box[^1] based on DuckDB + dbt + Evidence. It offers a simple script to extract and load (EL) data from the [GitHub Archive](https://www.gharchive.org/), a dbt project built on top of this data inside a DuckDB database, and BI tooling via Evidence to analyze and present the data.

It runs completely local or inside of a devcontainer. Some (me) call it the Quack Stack.

There are some basic tasks included using my preferred task runner [task](https://taskfile.dev/#/). You can install it with `brew install go-task`.

Tasks included are:

```shell
task extract # pull data from github archive
task load # load data into duckdb
task el # extract and load
```

You can also manually run the `el.py` script with `python3 el.py [args]`.

![kim was right](https://github.com/gwenwindflower/octocatalog/assets/91998347/adb3fb70-c666-4d54-9e0c-86600692603b)

[^1]: Based on the patterns developed by Jacob Matson for the original [MDS-in-a-box](https://duckdb.org/2022/10/12/modern-data-stack-in-a-box.html)https://duckdb.org/2022/10/12/modern-data-stack-in-a-box.html.
