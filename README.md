# helm-package.el

`helm-package.el` lists ELPA packages with helm-interface.

## Screenshot

![helm-package](https://github.com/syohex/emacs-helm-package/raw/master/image/helm-package1.png)


## Requirements

* Emacs 24.1 or higher.
* helm 1.0 or higher


## Basic Usage

List package with helm interface

    M-x helm-package

Do `M-x package-refresh-contents` if you use prefix argument(`C-u`).


## Sample Configuration

````
(require 'helm-config)
(require 'helm-package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
````
