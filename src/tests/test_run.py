"""This module contains an example test.

Tests should be placed in ``src/tests``, in modules that mirror your
project's structure, and in files named test_*.py. They are simply functions
named ``test_*`` which test a unit of logic.

To run the tests, run ``kedro test`` from the project root directory.
"""

from pathlib import Path

import pytest
from kedro.config import ConfigLoader
from kedro.framework.context import KedroContext
from kedro.framework.hooks import _create_hook_manager
from kedro.framework.project import settings


@pytest.fixture
def config_loader() -> ConfigLoader:
    """Create a ConfigLoader instance.

    Returns:
        ConfigLoader: ConfigLoader instance.
    """
    return ConfigLoader(conf_source=str(Path.cwd() / settings.CONF_SOURCE))


@pytest.fixture
def project_context(config_loader: ConfigLoader) -> KedroContext:
    """Instantiate a KedroContext instance for the project.

    Args:
        config_loader: A ConfigLoader instance.

    Returns:
        KedroContext: KedroContext instance.
    """
    return KedroContext(
        package_name="anomaly_detection",
        project_path=Path.cwd(),
        config_loader=config_loader,
        hook_manager=_create_hook_manager(),
    )


# The tests below are here for the demonstration purpose
# and should be replaced with the ones testing the project
# functionality
class TestProjectContext:
    """A collection of tests for the functionality of the project."""

    def test_project_path(self, project_context: KedroContext) -> None:
        """Test that the project path is set correctly.

        Args:
            project_context: A KedroContext instance for the project.
        """
        assert project_context.project_path == Path.cwd()
