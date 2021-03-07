# JS Development Machine!

This container is ready to development using:

- Alpine 3.12
- Python3
- NodeJs (nvm, npm)
- Neovim and plugins to Js like
  >  Telescope, plenary, popup, ctrlsf, auto-pairs, closetag, vimspector, jsx-pretty, ctags
 
- tmux
- oh-my-zsh and plugins:
  > autosuggestions, autojump, completions, highlighting,

Stop installing and configuring your tools to development every time you change your computer, with this, your local machine don't need NodeJs and packages, Vim and plugins, Bash plugins and commands anymore.
# Starting

Let's start. I will clone this project inside my development folder:
  > /Users/phz

Add this repo
  > $ git clone git@github.com:phzao/develop-container.git

Now will be this way:
  > /Users/phz/develo-container

I will rename the folder project to 'development':
  > /Users/phz/development

Build:
  > $ docker-compose up --build -d

Go to container:
  > $ docker exec -it -u dev development-machine zsh

The container start inside the '/development' and is the shared folder with the your local host:
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

To clone your projects you can do that on the local host or directly on your container, your choice. If do you want do that on container and you use ssh keys then you will need to configure it.
 
## Using NodeJs with debug

First of all, let me show some shortcuts:
>  Ctrl + C to go to command line and \do (start)
>  Ctrl + C to go to command line and \dbp (add a breakpoint)
>  Ctrl + C to go to command line and \dl (step into)
>  Ctrl + C to go to command line and \dj (step over)
>  Ctrl + C to go to command line and \djo (step out)
>  Ctrl + C to go to command line and \d_ (restart)
>  Ctrl + C to go to command line and \ds (stop)

When the debug is started the first time they will install vscode-plugin and after that, you will asked two questions, only answer the default and done. If your project is an API try starting the debug and go to the route using 'Postman' to see how it works.

## Tips

Try find some in your Project using nvim with:
  >  Ctrl + C and \ps and type what you want to see what's happen

