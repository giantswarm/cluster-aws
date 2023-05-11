# Test values

We have a `Compare Helm Rendering` Github action that will write a comment containing the diff between the output of `helm template` using the code in the branch being build and the code in the `main` branch.
This action will write a comment for every file in this folder named `test-*.yaml`. Each file will be used invoking `helm template -f cluster-aws/ci/ci-values.yaml -f cluster-aws/ci/test-example.yaml cluster-aws`.
That way different configurations can be tested. The `ci-values.yaml` file is always passed.
