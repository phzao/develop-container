# JS Development Machine!

This container is ready for development using:

- Alpine 3.12
- Python3
- NodeJs (nvm, npm, npx)
- Neovim and plugins to Js like
  >  Telescope, plenary, popup, ctrlsf, auto-pairs, closetag, vimspector, jsx-pretty, ctags

- The silver search, RipGrep(rg)
- tmux
- oh-my-zsh and plugins:
  > autosuggestions, autojump, completions, highlighting,

Stop installing and configuring your development tools every time you change computers, so your local machine will no longer need NodeJs, Python, Vim and custom Terminals.

I use to NodeJs and ReactJs projects.

# Starting

Let's start. I will clone this project into my development folder:
  > /Users/phz

Add this repo
  > $ git clone git@github.com:phzao/develop-container.git

Now it will be like this:
  > /Users/phz/develo-container

I will rename the project folder to 'development':
  > /Users/phz/development

Build:
  > $ docker-compose up --build -d

Accessing:
  > $ docker exec -it -u dev development-machine zsh

The container starts within '/ development' and is the folder shared with your local host. Everything you put in that folder will be accessible in the container:
  > /Users/phz/development  = /development

Inside this folder I will add all my projects:
> /Users/phz/development

> ------project1

> ------project2

> ------project3

Installing plugins on Neovim:
  > $ nvim .

  >  after open press Ctrl + C

  >  type :PlugInstall

  >  Will be installed all plugins

To clone your projects, you can do this on the local host or directly in your container, you choose. If you want to do this in the container and use the ssh keys, you will need to configure it.

## Using NodeJs with debug

You will need add a .vimspector.json file in your root project. My project on netlify using nodejs has the follow configurations:

````JSON
{
	"configurations": {
		"run": {
			"adapter": "vscode-node",
			"configuration" : {
				"request": "launch",
				"protocol": "auto",
				"stopOnEntry": false,
				"console": "integratedTerminal",
				"program": "${workspaceRoot}/src/api.js",
				"cwd": "${workspaceRoot}"
			}
		}
	}
}
````

First, let me show you a few shortcuts:
>  Ctrl + C to go to command line and \do (start)

>  Ctrl + C to go to command line and \dbp (add a breakpoint)

>  Ctrl + C to go to command line and \dl (step into)

>  Ctrl + C to go to command line and \dj (step over)

>  Ctrl + C to go to command line and \djo (step out)

>  Ctrl + C to go to command line and \d_ (restart)

>  Ctrl + C to go to command line and \ds (stop)

When the debug is started for the first time they will install vscode-plugin and after that, you will ask two questions, just answer the pattern and that's it. If your project is an API try to start debugging and go to the route using 'Postman' to see how it works.

## Tips

Try to find something in your project using nvim with:
  >  Ctrl + C and \ps and type what you want to see what's happen

> convert word from lower case to upper case: Ctrl + c gU$

> convert all content from { a, b, c.. } to upper case: Ctrl + c gUi{

I will add some tips later..

