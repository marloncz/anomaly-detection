# Anomaly-Detection

## Methods



## ⚙️ Installation

A convinient `make` command is provided to install the project.
It will create a virtual environment with the correct python version and install all packages with `poetry`.
In addition all developement tools are installed with `brew` on macOS if they are not already installed.

```bash
make install
```

## 🚧 Usage

### Run Pipeline

You can run the entire end-to-end pipeline that processes the data, trains the model, and makes predictions using one of the two following commands.
The `run_local` target runs the local pipeline with local data in the `data` folder using the `local` kedro environment.
The `run_prod` runs all steps of the pipeline using the `prod` kedro environment.
It is intended to be run on a production server with the data stored in a database from which kedro can read the inputs.
The `local` environment is intended to be used for development and testing while the `prod` environment is intended to be used for production.

```bash
make run_local  # <- run local kedro pipeline
make run_prod  # <- run production kedro pipeline
```

### Track Models with Mlflow

During the training of the model, the model parameters and metrics are tracked with [mlflow](https://mlflow.org/).
A local mlflow server is started automatically when the pipeline is run.
The dashboard can be started with the following command and is available at [http://localhost:5000](http://localhost:5000).
In the browser you can see the different runs of the pipeline and the corresponding parameters and metrics.
This functionalty is provided by the [kedro-mlflow](https://github.com/Galileo-Galilei/kedro-mlflow) package.

```bash
make mlfow
```


### Vizulize Pipeline Graph

Kedro provides a user interface called `kedro-viz` that visualizes the implemented pipelines and nodes.
This can be used to get an overview of the implemented pipeline and to debug the pipeline.
To start the vizualization run the following command.
After that the vizualization is available at [http://localhost:4141](http://localhost:4141).

```bash
make viz
```

## 🧪 Testing

The source code is tested with [pytest](https://docs.pytest.org/en/stable/).
Every node and function should be tested with a unit test.
The tests are located in the `src/tests` folder where every pipeline step has its own folder.
For more information on how to write tests with pytest the [documentation](https://docs.pytest.org/en/stable/) or the example tests in the `src/tests` folder can be used as a reference.
You can run your tests as follows:

```bash
make test
```
