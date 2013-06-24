(add-to-list 'load-path (expand-file-name "~/.emacs.d/local-plugins/auto-complete-clang"))
(require 'auto-complete-clang)

(if (eq system-type 'windows-nt)
    (progn
      (message "Loading windows-nt clang config file.")
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
  (if (eq system-type 'gnu/linux)
      (progn
        (message "Loading gun/linux clang config file.")
        (setq ac-clang-flags
              (split-string
               "
 -I/usr/include/c++/4.6
 -I/usr/include/c++/4.6/i686-linux-gnu/.
 -I/usr/include/c++/4.6/backward
 -I/usr/lib/gcc/i686-linux-gnu/4.6/include
 -I/usr/local/include
 -I/usr/lib/gcc/i686-linux-gnu/4.6/include-fixed
 -I/usr/include/i386-linux-gnu
 -I/usr/include
 -I/usr/local/lib/wx/include/gtk2-ansi-release-2.8
 -I/usr/local/include/wx-2.8
 -D_FILE_OFFSET_BITS=64
 -D_LARGE_FILES
 -D__WXGTK__
"
               ))
        )
    )
  )


(provide 'init-auto-complete-clang)
