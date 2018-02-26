def test_000_a_test_can_pass():
    print("This test should always pass!")
    assert True


def test_001_can_see_the_internet(selenium):
    selenium.get('http://www.example.com')
