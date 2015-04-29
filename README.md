.dotfiles
=========

Installation
=
First, clone this repo:
```
$ cd $HOME
$ git clone git@github.com:catesandrew/dotfiles.git .dotfiles
```

Second, set up the `.bash/` sub-modules.

```
$ cd .dotfiles
$ git submodule init
$ git submodule update
```

Third, run the dfm installer

```
$ bin/dfm install
```

## My background

On my machines I usually keep a set of personalized dotfiles which I don't want to miss on any other server I have to administrate:

    .screenrc
    .bashrc
    .inputrc
    .vimrc
    .emacs.d/
    .vim.d/

I need these files on all machines which I regularly work on.

## Some interesting solutions for dotfile management

Many people have looked at this problem before – and solved it in their own ways. Most often the basic principle is that the files are stored and tracked via git in a hidden directory, and the tool of your choise manages symlinks between the files in the store and in `$HOME`.

For example, a very interesting idea is to [use GNU Stow to manage dotfiles](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). It tracks the necessary files in subdirectories and of course links the files from there to the 'real' places in $HOME. I like reusing existing tools, so the idea of using GNU Stow appealed immediately. Unfortunately, on most systems GNU Stow is not installed by default, and I cannot install new software on other machines all the time.

The problem of necessary software installation is also relevant for another often mentioned solution: [Homesick](https://github.com/technicalpickles/homesick). Homesick is Ruby based, and works similar to the GNU Stow solution mentioned above: files are stored in a hidden subdirectory, tracked with git, and linked in `$HOME`. The main feature here is that it can keep the configuration files in various git repositories, called 'castles', so you can integrate the work of projects like [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). While Homesick does offer quite some features, it is Ruby based – and I cannot expect a working Ruby environment on each system, so it is out of question. I can go with Perl or Python, but that's about it.

Other people had the same Ruby problem and created [Homeshick](https://github.com/andsens/homeshick) – a Homesick clone spelled with an additional 'h' and besides written in Bash. It is quite straight forward and offers all necessary features like listing and tracking various git repositories as source for dotfiles, linking the actual dotfiles to your home, and so on. This one is almost my favorite! I wouldn't be surprised if it is the favorite for most of the users out there.

But Homeshick is only almost my favorite – meet [dfm – a Utility to Manage Dotfiles](https://github.com/justone/dfm)! It is written in Perl and mainly does the same as mentioned above, minus the support for more than one repository. But on the plus side it has the capability of ensuring file rights via chmod. I haven't seen that in any other solution. Additionally it supports arbitrary scripts executed during the update process for example for host specific commands.

## Starting with dfm

The `.bashrc` is hardly modified:

    $ tail -n 1 .bashrc
    . $HOME/.bashrc.load

As a side node, I am not sure if I really want to drop all my customizations on the bashrc loader, but the [reasoning behind that move](https://github.com/justone/dotfiles/wiki/Questions-and-Answers) from the dfm author is rationale:

> Why .bashrc.load instead of .bashrc?
>
> Each OS or distribution generally has its own way of populating a default .bashrc in each new user's home directory. This file works with the rest of the OS to load in special things like bash completion scripts or aliases. The idea behind using .bashrc.load is that dotfiles should add new things to a system rather than overwriting built-in funcitonality.
>
> For instance, if a system sources bash completion files for you, and your dotfiles overwrites the system-provided .bashrc, then you would have to replicate that functionality on your own.

### Adding files with dfm

The next step is to add further files to your dfm repository, which is quite easy because dfm comes along with an import function:

    $ dfm import .vimrc

The usage is pretty straightforward, and supports directories as well:

    $ dfm import .emacs.d

### Using dfm on a new system

Using dfm on a new system is straightforward as well: clone the repo, invocate dfm, and you are done:

    $ git clone git@github.com:catesandrew/dotfiles.git .dotfiles
    $ ./.dotfiles/home/.bin/dfm
    INFO: Installing dotfiles...
    INFO:   Backing up .vimrc.
    INFO:   Symlinking .vimrc (.dotfiles/home/.vimrc).
    INFO:   Backing up .bin.
    INFO:   Symlinking .bin (.dotfiles/home/.bin).
    INFO:   Symlinking .bashrc.load (.dotfiles/home/.bashrc.load).
    INFO:   Backing up .inputrc.
    INFO:   Symlinking .inputrc (.dotfiles/home/.inputrc).
    INFO:   Backing up .emacs.d.
    INFO:   Symlinking .emacs.d (.dotfiles/home/.emacs.d).
    INFO: Appending loader to .bashrc

As you see quite some files are backed up, that just means they are moved to `.backup`, so in worst case you know where to look.

### Adding soft links with dfm

Now lets see what happens when you change something.

    $ cd ~/.bin
    $ ln -s /usr/bin/gnome-terminal gt
    $ dfm add bin/gt
    $ dfm commit -m "Added gt symlink for gnome-terminal."
    [master 441c067] Added gt symlink for gnome-terminal.
     1 file changed, 1 insertion(+)
     create mode 120000 bin/gt
    $ dfm push
    Counting objects: 6, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (4/4), 363 bytes, done.
    Total 4 (delta 1), reused 0 (delta 0)
    To git@sinoda:dotfiles
       b28dc11..441c067  master -> master

As you see, dfm supports git pass through: git commands are directly handed over to git. The changes where added to the git repository, and the repository was pushed to the remote URL.

### Updates with dfm

So, to get the changes onto the other system you just have to ask dfm to update the files via `dfm umi`. In this case I called it after I made changes to .screenrc:

    $ dfm umi
    [...]
    INFO: re-installing dotfiles
    INFO: Installing dotfiles...
    INFO:   Symlinking .screenrc (.dotfiles/.screenrc).

### Special features of dfm

As mentioned above, the strongest feature of dfm is to be able to ensure file system rights and to start scripts after an update. The first option comes in handy when you are sharing files in your ssh config directory. The second is useful whenever you have to alter files or do anything based for example on host names. Imagine that you have various build machines to build rpm files, but you have to use different packages names on each build environment.

### Summary

So, summarizing I can say dfm offers a quite neat and easily understandable solution for managing dotfiles while not relying on languages or tools you probably cannot install on the systems you are working on. However, Homeshick comes in as a close second, and I might give that one a try at some other point in the future. In the end, both solutions are much better than self written solutions – or no solution at all.