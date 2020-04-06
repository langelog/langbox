# LangBox

This is a docker image that helps to provide a quick test environment for C++, Golang and Python 3.8.1 using the great jupyter.

To use it, just do:

> Remember to first `cd` to your working directory, or change the `$PWD` by the directory that you want to use. 
> And of course, set the port you want to use... Happy coding :)

```bash
$ docker run --rm -v $PWD:/app -p 1314:1314 langelog/langbox:0.1.5_base root --notebook --ip 0.0.0.0 --port 1314 --allow-root
```
