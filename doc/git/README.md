
# git hooks

The project includes a number of git hook scripts that help to ensure that certain aspects of the code base are maintained appropriately. These scripts hook in and run at certain places in git workflow (e.g. pre-commit checks will prevent a git commit from completing if the validation fails). However, these git hook scripts must be sym-linked so that git will execute them.

## Initialization of development environment

**Importantant**

Execute the following command after cloning to apply the included git hooks:

```
./git/init-hooks
```

## See also

See the scripts in `git/hooks/` as well as the scripts `git/init-hooks` and `git/hooks-wrapper` for more information.
