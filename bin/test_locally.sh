echo "test_locally"
echo "Running pytest to locally Test All Test Cases (Functional Testing)"

pytest $@ testcases

if [[ "$?" == "0" ]]; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit -1
fi
