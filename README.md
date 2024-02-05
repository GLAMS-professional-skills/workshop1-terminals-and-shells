# Windows software showcase

## Bash emulator

Have a look to see if you have a bash emulator installed somewhere already (quite common with mathematical software).

If not, why not try installing [Cygwin]()?

## Install WSL2

Windows has been pushing [WSL2]() for a couple of years and has made it a compelling product.
It allows you to run Linux inside windows,
which can sometimes solve headaches when trying to use software mainly built for Linux.

- try copying files from windows to WSL
- (if you have VSCode) try opening VSCode on WSL remotely

## Install windows terminal

Terminals and shells have traditionally been coupled together on Windows.
[Windows Terminal]() is a couple of years old, and has many quality of life improvements.
Maybe try it out (especially if you installed WSL2).

# CLI arguments

## Intro

### `pdflatex` example

`pdflatex` looks at its arguments to choose which file to compile. Try in the terminal:

```bash
pdflatex file.tex
```

Notice that the default behaviour is to prompt the user when something goes wrong, try:

```bash
pdflatex broken_file.tex
```

If like most people, you're not realistically going to fix TeX on the fly, you can get rid of this behaviour with the `-nonstopmode` "flag" (which is a CLI argument).

```bash
pdflatex -nonstopmode broken_file.tex
```

This doesn't fix the compilation, but at least it doesn't make a fuss about it.

**Note:** If you use `latexmk` you can ensure that `-nonstopmode` is always passed to `pdflatex` by adding/modifying a `latexmkrc` file.

- use output as args

# Error codes

In the above examples, the `pdflatex` runs will actually return an integer value. This may not be obvious, but if you have a fancy theme in your shell, this may be indicated by the colour of the prompt.
Try these commands again and then check the return value immediately after by typing:

bash:
```bash
echo $?
```

cmd:
```bash
echo %errorlevel%
```
An error code of 0 is good, anything else will correspond to some kind of failure, there are conventions for the meanings of these integer values.
But a program can also document themselves what an error value means, and also will likely print the error in STDERR (see below).

# Piping inputs and outputs

**jargon alert, feel free to ask for visual aid**

A typical process (something that is created when you run an executable) will have three standard *file descriptors*:
- STDIN (0)
- STDOUT (1)
- STDERR (2)
When running an executable inside of the terminal, these things will correspond to:
- Stuff you type into the terminal after process starts
- Stuff printed out onto the terminal that you didn't write
- Stuff printed out onto the terminal that you didn't write... but different (typical context referring to events or errors)


However, these file descriptors can be redirected into other things such as files or as inputs to another process.
As far as the process is concerned, it can't tell if it is taking in, or out, text from the keyboard, or a file, etc (*this is a lie, but you can believe it for now*)

## Redirecting through other processes
```bash
# This is just for illustrative purposes

# prints out contents of current directory to STDOUT
ls
# redirect that stdout to a process that adds something to beginning of each line
ls | sed -e 's;^;This is something in the current directory: ;;'
```

## Redirecting to files
Bash:
```bash
ls > directory-contents.txt
```

cmd.exe:
```bash
dir > directory-contents.txt
```
... Now check contents of the newly created txt file.

Read in from file
```bash
# touch files (changes time last modified to now)
touch < directory-contents.txt
```


## Going deeper with the file descriptors

Remember how STDOUT and STDERR are both printed to the terminal... but different?

Let's get familiar with separating the out and manipulating them. The `>` operator will take the STDOUT of the LHS and pipe it to the file on the right.
However that file can be STDERR (&2) or STDOUT (&1).
You can also add a number just to the left to select a different file descriptor to redirect.

Here are some examples, try them and discuss:

Not cmd.exe:
```bash
(echo hello >&2; echo bye)
(echo hello >&2; echo bye) 1> /dev/null
(echo hello >&2; echo bye) 2> /dev/null
```

**Note on Bashism:** the following is valid `bash`, but is among the things which is not valid `sh`
```bash
(echo hello >&2; echo bye) &> /dev/null # pipes both STDOUT and STDERR to the void
# This is how you would have to do it in plain sh:
(echo hello >&2; echo bye) 2>&1 &> /dev/null
```

# Environment Variables

Environment variables are an OS construct: they are variables associated to processes and inherited by subprocesses.

Check out what environment variables are set for you in your shell process:

bash
```bash
env
```
cmd.exe
```bash
set
```
Find which one corresponds to your current directory, and your home directory (slightly different between windows and other).

Have a go at changing or adding one (look up how).

A process can look at the value of an environment variable, to affect it's behaviour. A common use case in to decide where to try look for a file.


### PATH

A very standard environment variable is `PATH`, if you type a name of an executable (such as `say-hello` in this directory) without specifying the location
(with an absolute or relative path), the shell will try to find it in each location in `PATH`.

Try the following:
```bash
say-hello # will not be found, maybe in cmd? if so move to other dir and try again
```
Now add current directory to the `PATH`, and try again: note that the effects are only on the current shell and will have no effect after closing the window.

In cmd.exe
```batch
set path=%cd%;%path%
say-hello
```

In bash
```bash
export PATH=`pwd`:$PATH # export not necessary since PATH alread env var
say-hello
```

In bash, if you want to only set an environment variable for a single line, you can also do the following:
```bash
PATH=`pwd`:$PATH say-hello
```

## Some other env vars you might find useful

Here are environment variables that you can try out.

| Environment variable | Use |
|-|-|
| PYTHONPATH | Used by `python` to find python files to import with `import <file-base-name>` |
| LATEXINPUTS | Used by `pdflatex` for supplementary locations to find `.sty` packages |

Try laying out some files where running `python` on a script, or `pdflatex` on a file fails at first, but succeeds when changing the env var.

**Note:** `LATEXINPUTS` can be set in your `latexmkrc` file if you use `latexmk`.


## Setting environment variables from a file

Let's say we want to set the environment variable `WORKSHOPTHEME` to "terminals and shells".

Instead of typing it out, I have prepared a file which sets this env var for you called `set_workshop_theme.batch` (for cmd) and `set_workshop_theme.sh` (for bash).

Try the following and see what happens:

### Bash
```bash
bash set_workshop_theme.sh
echo $WORKSHOPTHEME
```
```bash
. set_workshop_theme.sh # you can also do source instead of the .
echo $WORKSHOPTHEME
```
### cmd
```cmd
set_workshop_theme
echo %workshoptheme%
```
```batch
cmd /k set_workshop_theme
echo %workshoptheme%
```

# File globbing (bash-like)

Bash will expand `*` to any file/directory and `**` to any directory/nested-subdirectory (i.e. find folders).

Write a `bash` one-liner to list out all the `.tex` files in the current directory, and all subdirectories.

Now write other one to find each of those `.tex` files and make a copy of them in each of the corresponding directories with the added extension `.tex.backup`.

# Bashisms

## Translate to POSIX compliant
In `bashism.sh`, there is a shell script that is valid bash, but will not run in sh. Translate it so that it will run in `sh` too correctly.
## bash neq sh

# Shebangs
