;;; config.el --- react layer config file for Spacemacs. -*- lexical-binding: t -*-
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Andrea Moretti <axyzxp@gmail.com>
;; URL: https://github.com/axyz
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(spacemacs|define-jump-handlers rjsx-mode)

(defvar reactjs-backend 'dumb
  "The backend to use for IDE features. Possible values are `dumb' and `lsp'.")
