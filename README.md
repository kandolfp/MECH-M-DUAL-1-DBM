# MECH-M-DUAL-1-DBM - Grundlagen datenbasierter Methoden

Course material for a ~3 * 15 hours (5 ECTS) course on basic concepts for data science. All the topics are presented with the Python implementation included. We cover matrix decompositions, regression, signal processing, sparsity and compressed sensing and a bit of statistics. 

# Citing this project

[Citation information](CITATION.cff)

[![DOI](https://zenodo.org/badge/{861305042}.svg)](https://zenodo.org/badge/latestdoi/{861305042})


# Development

We use [Quarto](https://quarto.org/) to generate the lecture material.
Where we are creating a book, see [docs](https://quarto.org/docs/books/) for the structure. 
In short, each part has its own folder where you find the `qmd` files and everything is managed via `_quarto.yml`.
In order to make the use easy the entire project is managed with [pdm](https://pdm-project.org/) so to start the preview run

```bash
pdm sync
pdm quarto preview
```

The project is also compatible with the VSCode extension of Quarto, just make sure the the Python environment in `./.venv` is used. 

> [!IMPORTANT] 
> In one example `locale.setlocale(locale.LC_ALL, 'de_AT.utf8')` is used so make sure the language is installed on your system to make this example run.

# Publishing
After pushing the published website will automatically be built and deployed at [kandolfp.github.io/MECH-M-DUAL-1-DBM/](https://kandolfp.github.io/MECH-M-DUAL-1-DBM/).
Due to the dynamic nature of the material this might take a couple of minutes.

You can also create a pdf by calling 
```
 pdm run quarto render --to pdf
```

or the html version
```
 pdm run quarto render --to html
```

You can also find a pdf in the [releases](https://github.com/kandolfp/MECH-M-DUAL-1-DBM/releases)