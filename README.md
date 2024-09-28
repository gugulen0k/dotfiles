# Alacritty + NeoVim + ZSH + tmux config files

### # Requirements

* **rubytags**:
	* Install **GPG**
	* Install **RVM - Ruby Version Manager** ( more info [here](https://rvm.io/rvm/install) )
	* Select prefered Ruby version
	* Install **ripper-tags** ( more info [here](https://rubygems.org/gems/ripper-tags) ) `gem install ripper-tags`
	> ripper-tags are used for better search specifically in ruby files
* **ripgrep** ( more info  ): Find the way how to download ripgrep for each OS [here](https://github.com/BurntSushi/ripgrep#installation)
* **Fantasque Sans Mono** fonts: Install different types of font from `FantsqueSansMono` folder

### # Creating symlinks(symbolic links) for configuration files

> ⚠️ **Warning!**
> If you already have your configuration files and/or `.config` folder, make sure that you copied/moved your files somewhere else from home directory, this way you won't lose your current configuration.

Command to create symbolic links for Linux & MacOS: `ln -s <absolute/path/to/source/file> <absolute/path/to/symbolic/link>`

### # Keybindings for Tmux, Neovim

<table>
<thead>
  <tr>
    <th>Keybinding</th>
    <th>Description</th>
    <th>Preview</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td colspan="3" align="center"><b>NeoVim</b></td>
  </tr>
  <tr>
    <td align="center"><kbd>Space</kbd> + <kbd>p</kbd></td>
    <td>Allows just to <i>search</i>(by file name) and <i>open</i> files inside current and nested directories</td>
    <td><img width="839" alt="ctrl+p" src="https://user-images.githubusercontent.com/47348892/194586799-5b6abe22-485e-4c81-ae42-02e0e63aaf68.png">
</td>
  </tr>
  <tr>
    <td align="center"><kbd>Space</kbd> + <kbd>f</kbd></td>
    <td>Allows to search and open files based on their content. Searching area is currently opened folder.</td>
    <td><img width="839" alt="ctrl+f" src="https://user-images.githubusercontent.com/47348892/194585995-b22c9061-cc5b-42cd-90fe-cd6bc0817466.png">
</td>
  </tr>
  <tr>
    <td align="center"><kbd>Space</kbd> + <kbd>b</kbd></td>
    <td>Shows all buffered(<i>already opened</i>) files.</td>
    <td><img width="839" alt="ctrl+b" src="https://user-images.githubusercontent.com/47348892/194586273-a40cc123-ab08-4900-ad9f-169c96dc4ac9.png">
</td>
  </tr>
  <tr>
    <td align="center"><kbd>Space</kbd> + <kbd>d</kbd></td>
    <td>Shows all methods inside current file and allows to jump between them.</td>
    <td><img width="849" alt="space+d" src="https://user-images.githubusercontent.com/47348892/194586305-879549a0-b218-412b-a1f1-e264988b09e8.png">
</td>
  </tr>
  <tr>
    <td align="center"><kbd>Space</kbd> + <kbd>Space</kbd></td>
    <td>Jumps between two recently opened files.</td>
    <td></td>
  </tr>
   <tr>
    <td align="center"><kbd>Space</kbd> + <kbd>q</kbd></td>
    <td>Show/Hide current directory structure.</td>
    <td></td>
  </tr>
  <tr>
    <td colspan="3" align="center"><b>Tmux</b></td>
  </tr>
  <tr>
    <td align="center"><kbd>Ctrl</kbd> + <kbd>h</kbd>, <kbd>j</kbd>, <kbd>k</kbd>, <kbd>l</kbd></td>
    <td>Allows to move between panes (<i>left, top, down, right</i>).</td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>f</kbd></td>
    <td>It toggles active pane between <i>full terminal size</i> and <i>normal size</i></td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>x</kbd></td>
    <td>Kills active pane</td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>|</kbd></td>
    <td>Vertically splits active pane</td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>-</kbd></td>
    <td>Horizontally splits active pane</td>
    <td></td>
  </tr>
  <tr>
    <td align="center"><kbd>Ctrl</kbd> + <kbd>a</kbd> + <kbd>r</kbd></td>
    <td>Reload tmux configuration file <code>~/.tmux.conf</code></td>
    <td></td>
  </tr>
</tbody>
</table>


### To Do
Auto installing script:
[] Installing a configuration also installs all of the related tools.
[] Add interactive CLI.
