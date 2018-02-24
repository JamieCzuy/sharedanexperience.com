import pytest


@pytest.fixture
def chrome_options(chrome_options, pytestconfig):
    """
    Allows the command line option "--capability headless true"
    to be used to run Chrome Browser headlessly
    """
    capabilities = dict(pytestconfig.option.capabilities)
    if 'true' == capabilities.get('headless', 'false').lower():
        chrome_options.add_argument('headless')
    return chrome_options
