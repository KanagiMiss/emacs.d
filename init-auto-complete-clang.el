(add-to-list 'load-path (expand-file-name "~/.emacs.d/local-plugins/auto-complete-clang"))
(require 'auto-complete-clang)

(if (eq system-type 'windows-nt)
    (progn
      (setq ac-clang-flags
            (split-string
             "
 -ID:/software/codeblocks/mingw/lib/gcc/mingw32/4.7.1/include/c++/
 -ID:/software/codeblocks/mingw/lib/gcc/mingw32/4.7.1/include/c++/mingw32
 -ID:/software/codeblocks/mingw/lib/gcc/mingw32/4.7.1/include/c++/backward
 -ID:/software/codeblocks/mingw/include
 -ID:/software/codeblocks/mingw/lib/gcc/mingw32/4.7.1/include-fixed
 -IC:/xWidgets-2.9.4/lib/gcc_dll/mswu
 -IC:/xWidgets-2.9.4/include
 -DHAVE_W32API_H
 -D__WXMSW__
 -D_UNICOD
 -DWXUSINGDLL
 -Wno-ctor-dtor-privacy
"
             ))

      )
  (progn

    )
  )


(provide 'init-auto-complete-clang)
