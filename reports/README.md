# Evidence Template Project

Welcome to Evidence. Use this project template to get started.

[Share your feedback with the Evidence team](https://du3tapwtcbi.typeform.com/to/GZNZe1GY)

## Getting Started

Check out the docs for [alternative install methods](https://docs.evidence.dev/getting-started/install-evidence) including Docker, Github Codespaces, and alongside dbt.

```shell
npx degit evidence-dev/template my-project
cd my-project
npm install
npm run dev
```

Once you've launched Evidence, this project includes a short tutorial to help you get started.

Don't clone this repo, just download the code using the steps above.

## Codespaces

If you are using this template in Codespaces, click the Start Evidence button in the bottom left toolbar, or use the following commands to get started:

```shell
npm install
npm run dev -- --host 0.0.0.0
```

See [the CLI docs](https://docs.evidence.dev/cli/) for more command information.

**Note:** Codespaces is much faster on the Desktop app. After the Codespace has booted, select the hamburger menu → Open in VS Code Desktop.

## Connection Issues

If you see `✗ orders_by_month Missing database credentials`, you need to add the connection to the demo database:

1. Open the settings menu at [localhost:3000/settings](http://localhost:3000/settings)
2. select `DuckDB`
3. enter `octocatalog`
4. select `.db` and save

## Learning More

- [Docs](https://docs.evidence.dev/)
- [Github](https://github.com/evidence-dev/evidence)
- [Slack Community](https://join.slack.com/t/evidencedev/shared_invite/zt-uda6wp6a-hP6Qyz0LUOddwpXW5qG03Q)
- [Evidence Home Page](https://www.evidence.dev)
