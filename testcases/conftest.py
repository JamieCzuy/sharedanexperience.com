import pytest


@pytest.fixture
def chrome_options(chrome_options, pytestconfig):
    capabilities = dict(pytestconfig.option.capabilities)
    if 'true' == capabilities.get('headless', 'false').lower():
        chrome_options.add_argument('headless')
    return chrome_options


@pytest.fixture
def firefox_options(firefox_options, pytestconfig):
    capabilities = dict(pytestconfig.option.capabilities)
    if 'true' == capabilities.get('headless', 'false').lower():
        firefox_options.set_headless(True)
    return firefox_options
