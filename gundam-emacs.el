(eval-when-compile (require 'cl))
(require 'gamegrid)

;;; Customization
(defgroup gundam-emacs nil
  "Emacs-Lisp implementation of the classical game gundam-emacs."
  :tag "gundam-emacs"
  :group 'games)

(defcustom gundam-emacs-buffer-name "*gundam-emacs*"
  "Name of the buffer used to play."
  :group 'gundam-emacs
  :type '(string))

(defcustom gundam-emacs-map
  [
   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
   [1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1]
   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
   [0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0]
   [0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0]
   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
   [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0]
   [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]
   [0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0]
   [0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0]
   [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
   [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
   [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0]
   ]
  "gundam-emacs map."
  :group 'gundam-emacs
  :type '(array))

(defcustom gundam-emacs-width (length (elt gundam-emacs-map 0))
  "Width of the playfield."
  :group 'gundam-emacs
  :type '(integer))

(defcustom gundam-emacs-height (length gundam-emacs-map)
  "Height of the playfield."
  :group 'gundam-emacs
  :type '(integer))

(cons gundam-emacs-width gundam-emacs-height)

;; ;;;;;;;;;;;;; constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst gamegrid-glyph-height 16)
(defconst gamegrid-xpm "\
/* XPM */
static char *noname[] = {
/* width height ncolors chars_per_pixel */
\"16 16 3 1\",
/* colors */
\"+ s col1\",
\". s col2\",
\"- s col3\",
/* pixels */
\"......++++......\",
\"--............--\",
\"++............++\",
\"......----......\",
\"......++++......\",
\"--............--\",
\"++............++\",
\"......----......\",
\"......++++......\",
\"--............--\",
\"++............++\",
\"......----......\",
\"......++++......\",
\"--............--\",
\"++............++\",
\"......----......\"
};
"
  "XPM format image used for each square")

(defconst gamegrid-blank-16-0-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defconst gamegrid-blank-16-1-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defconst gamegrid-blank-16-2-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"       cc       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defconst gamegrid-blank-16-3-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"       oo       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defconst gamegrid-blank-16-4-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"       oo       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-5-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"       yy       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-6-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-7-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-8-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-9-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-10-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       yy       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-11-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-12-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-13-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-14-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       oo       \",
\"                \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-15-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \",
\"                \"
};
"
  "XPM format image used for each square")

(defvar gamegrid-blank-16-16-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"                \",
\"       ww       \"
};
"
  "XPM format image used for each square")

(defconst gamegrid-player-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"y c yellow\",
\"w c white\",
/* pixels */
\"    w  w  w     \",
\"     wrwrw      \",
\" ww   WWW    ww \",
\" wwwBBBBBBBBwww \",
\"ww oooBBBBooowww\",
\"ww   rrrrr    ww\",
\"ww   rrrrr    ww\",
\"ww  wwwwwww     \",
\"    ooowwooo    \",
\"    www  www    \",
\"    ww    www   \",
\"  wwww   wwwww  \",
\"   ww     www   \",
\"  www      ww   \",
\"  www      www  \",
\"rrrrr     rrrrrr\"
};
"
  "XPM format image used for each square")

(defconst gamegrid-enemy-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"g c green\",
\"w c white\",
/* pixels */
\"      ggg       \",
\"     grrrg  gggg\",
\"gggggggggggggggg\",
\" gggBBBBBBBBggg \",
\"gg  gggggggg gg \",
\"gg   gggggg   gg\",
\"gg   gggggg   gg\",
\"gg  ggggggggg   \",
\"   ggggwwgggg   \",
\"   gggg  gggg   \",
\"  gggg    gggg  \",
\"  g__g    g___g \",
\" ggggg    gggg  \",
\" ggggg    ggggg \",
\" g__gg   ggg__g \",
\"gggggg   ggggggg\"
};
"
  "XPM format image used for each square")

(defconst gamegrid-beam-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"c c ryan\",
\"g c green\",
\"w c white\",
/* pixels */
\"       ww       \",
\"       ww       \",
\"       cc       \",
\"       cc       \",
\"       cc       \",
\"       yy       \",
\"       yy       \",
\"       cc       \",
\"       cc       \",
\"       cc       \",
\"       yy       \",
\"       yy       \",
\"       cc       \",
\"       cc       \",
\"       ww       \",
\"       ww       \"
};
"
  "XPM format image used for each square")

(defconst gamegrid-explosion-xpm "\
/* XPM */
static char * player_xpm[] = {
/* width height ncolors cpp [x_hot y_hot] */
\"16 16 7 1\",
/* colors */
\"  c None\",
\"B c blue\",
\"_ c black\",
\"o c orange\",
\"r c red\",
\"g c green\",
\"w c white\",
/* pixels */
\"       rr       \",
\"                \",
\"      yrry      \",
\"                \",
\"  yy   rr   yy  \",
\"  yr   rr   ry  \",
\"                \",
\" r r rrrrrr r r \",
\" r r rrrrrr r r \",
\"                \",
\"  yr   rr  yry  \",
\"  yy   rr   y   \",
\"                \",
\"      yrry      \",
\"                \",
\"       rr       \"
};
"
  "XPM format image used for each square")

(setq gundam-emacs-beam-toggle nil)
(setq gundam-emacs-gameover nil)

(defcustom gundam-emacs-start-x 4
  "gundam-emacs start of x."
  :group 'gundam-emacs
  :type '(integer))

(defcustom gundam-emacs-start-y (1- gundam-emacs-height)
  "gundam-emacs start of y."
  :group 'gundam-emacs
  :type '(integer))

(cons gundam-emacs-start-x gundam-emacs-start-y)

(defcustom gundam-emacs-goal-x (- gundam-emacs-width 2)
  "gundam-emacs goal of x."
  :group 'gundam-emacs
  :type '(integer))

(defcustom gundam-emacs-goal-y 0
  "gundam-emacs goal of y."
  :group 'gundam-emacs
  :type '(integer))

(defcustom gundam-emacs-blank-color "black" ;; "oxblood"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)

(defcustom gundam-emacs-border-color "gray"
  "Color used for gundam-emacs borders."
  :group 'gundam-emacs
  :type 'color)

(defcustom gundam-emacs-player-color "cyan" ;; "ocher"
  "Color used for player."
  :group 'gundam-emacs
  :type 'color)

;;(defcustom gundam-emacs-enemy-color "green"
(defcustom gundam-emacs-enemy-color "red"
  "Color used for enemy."
  :group 'gundam-emacs
  :type 'color)

(defcustom gundam-emacs-blank-color-1 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-2 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-3 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-4 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-5 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-6 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-7 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-8 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-9 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-10 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-11 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-12 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-13 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-14 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-15 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)
(defcustom gundam-emacs-blank-color-16 "black"
  "Color used for background."
  :group 'gundam-emacs
  :type 'color)

(defcustom gundam-emacs-beam-color "orange"
  "Color used for beam."
  :group 'gundam-emacs
  :type 'color)

(defcustom gundam-emacs-explosion-color "red"
  "Color used for explosion."
  :group 'gundam-emacs
  :type 'color)

(defcustom gundam-emacs-left-key "4"
  "Alternate key to press for player to go left (primary one is [left])."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-right-key "6"
  "Alternate key to press for player to go right (primary one is [right])."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-up-key "8"
  "Alternate key to press for player to go up (primary one is [up])."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-down-key "2"
  "Alternate key to press for player to go down (primary one is [down])."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-beam-key " "
  "Key to press to beam gundam-emacs."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-quit-key "q"
  "Key to press to quit gundam-emacs."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-pause-key "p"
  "Key to press to pause gundam-emacs."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-resume-key "p"
  "*Key to press to resume gundam-emacs."
  :group 'gundam-emacs
  :type '(restricted-sexp :match-alternatives (stringp vectorp)))

(defcustom gundam-emacs-timer-delay 0.1
  "*Time to wait between every cycle."
  :group 'gundam-emacs
  :type 'number)

;;; This is black magic.  Define colors used
(defvar gundam-emacs-blank-16-options
  '(((glyph colorize)
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0.61 0.03 0.02])   ;; brown
     ;;((glyph color-x) [1 1 0])          ;; yellow
     ;;((glyph color-x) [0 1 1])          ;; blue
     ((glyph color-x) [0 1 0])          ;; green
     ;;((glyph color-x) [0 0 0])          ;; black
     ;;((glyph color-x) [0.5 0.5 0.5])    ;; black
     ;;((glyph color-x) [0.51 0.51 0.51]) ;; see thrugh ?
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-0-options
  `(((glyph [xpm :data ,gamegrid-blank-16-0-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ((glyph color-x) [0 0 0])          ;; black
     ;;((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-1-options
  `(((glyph [xpm :data ,gamegrid-blank-16-1-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ((glyph color-x) [0 0 0])          ;; black
     ;;((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-2-options
  `(((glyph [xpm :data ,gamegrid-blank-16-2-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-3-options
  `(((glyph [xpm :data ,gamegrid-blank-16-3-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-4-options
  `(((glyph [xpm :data ,gamegrid-blank-16-4-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-5-options
  `(((glyph [xpm :data ,gamegrid-blank-16-5-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-6-options
  `(((glyph [xpm :data ,gamegrid-blank-16-6-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-7-options
  `(((glyph [xpm :data ,gamegrid-blank-16-7-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-8-options
  `(((glyph [xpm :data ,gamegrid-blank-16-8-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-9-options
  `(((glyph [xpm :data ,gamegrid-blank-16-9-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-10-options
  `(((glyph [xpm :data ,gamegrid-blank-16-10-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-11-options
  `(((glyph [xpm :data ,gamegrid-blank-16-11-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-12-options
  `(((glyph [xpm :data ,gamegrid-blank-16-12-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-13-options
  `(((glyph [xpm :data ,gamegrid-blank-16-13-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-14-options
  `(((glyph [xpm :data ,gamegrid-blank-16-14-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-15-options
  `(((glyph [xpm :data ,gamegrid-blank-16-15-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-blank-16-16-options
  `(((glyph [xpm :data ,gamegrid-blank-16-16-xpm])
     (t ?\040))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (
     ;;((glyph color-x) [0 0 0])          ;; black
     ((glyph color-x) [0.5 0.5 0.5])    ;; black
     (color-tty gundam-emacs-blank-16-color)
     )))

(defvar gundam-emacs-border-options
  '(((glyph colorize)
     (t ?\+))
    ((color-x color-x)
     (mono-x grid-x)
     (color-tty color-tty))
    (((glyph color-x) [0.5 0.48 0.5])
     (color-tty gundam-emacs-border-color))))

(defvar gundam-emacs-player-options
  `(((glyph [xpm :data ,gamegrid-player-xpm])
     (emacs-tty ?O)
     (t ?\040))
    ((color-x color-x)
     (mono-x mono-x)
     (color-tty color-tty)
     (mono-tty mono-tty))
    (((glyph color-x) [0.92 0.62 0.28])
     (color-tty gundam-emacs-player-color))))

(defvar gundam-emacs-enemy-options
  ;;'(((glyph colorize)
  `(((glyph [xpm :data ,gamegrid-enemy-xpm])
     (emacs-tty ?O)
     (t ?\040))
    ((color-x color-x)
     (mono-x mono-x)
     (color-tty color-tty)
     (mono-tty mono-tty))
    (((glyph color-x) [0.53 0.82 0.1])
     (color-tty gundam-emacs-enemy-color))))

(defvar gundam-emacs-beam-options
  ;;'(((glyph colorize)
  `(((glyph [xpm :data ,gamegrid-beam-xpm])
     (emacs-tty ?O)
     (t ?\040))
    ((color-x color-x)
     (mono-x mono-x)
     (color-tty color-tty)
     (mono-tty mono-tty))
    (((glyph color-x) [0.53 0.82 0.1])
     (color-tty gundam-emacs-beam-color))))

(defvar gundam-emacs-explosion-options
  `(((glyph [xpm :data ,gamegrid-explosion-xpm])
     (emacs-tty ?O)
     (t ?\040))
    ((color-x color-x)
     (mono-x mono-x)
     (color-tty color-tty)
     (mono-tty mono-tty))
    (((glyph color-x) [0.53 0.82 0.1])
     (color-tty gundam-emacs-explosion-color))))

;;(defconst gundam-emacs-blank    0)
(defconst gundam-emacs-blank-16-0    0)
(defconst gundam-emacs-blank-16-1    1)
(defconst gundam-emacs-blank-16-2    2)
(defconst gundam-emacs-blank-16-3    3)
(defconst gundam-emacs-blank-16-4    4)
(defconst gundam-emacs-blank-16-5    5)
(defconst gundam-emacs-blank-16-6    6)
(defconst gundam-emacs-blank-16-7    7)
(defconst gundam-emacs-blank-16-8    8)
(defconst gundam-emacs-blank-16-9    9)
(defconst gundam-emacs-blank-16-10  10)
(defconst gundam-emacs-blank-16-11  11)
(defconst gundam-emacs-blank-16-12  12)
(defconst gundam-emacs-blank-16-13  13)
(defconst gundam-emacs-blank-16-14  14)
(defconst gundam-emacs-blank-16-15  15)
(defconst gundam-emacs-blank-16-16  16)
(defconst gundam-emacs-player    20)
(defconst gundam-emacs-beam      21)
(defconst gundam-emacs-explosion 22)
(defconst gundam-emacs-border    30)
(defconst gundam-emacs-enemy     40)

(defconst gundam-emacs-enemy-min-x 5)
(defconst gundam-emacs-enemy-max-x 6)

;;; Determine initial positions for player and enemy

(defvar gundam-emacs-player-x nil
  "Horizontal position of the player.")

(defvar gundam-emacs-player-y nil
  "Vertical position of the player.")

(defvar gundam-emacs-enemy-x nil
  "Horizontal position of the enemy.")

(defvar gundam-emacs-enemy-y nil
  "Vertical position of the enemy.")

(defvar gundam-emacs-beam-x nil
  "Horizontal position of the beam.")

(defvar gundam-emacs-enemy-y nil
  "Vertical position of the beam.")

;;; Initialize maps

(defvar gundam-emacs-mode-map
  (make-sparse-keymap 'gundam-emacs-mode-map) "Modemap for gundam-emacs-mode.")

(defvar gundam-emacs-null-map
  (make-sparse-keymap 'gundam-emacs-null-map) "Null map for gundam-emacs-mode.")

(define-key gundam-emacs-mode-map [left]   'gundam-emacs-move-left)
(define-key gundam-emacs-mode-map [right]  'gundam-emacs-move-right)
(define-key gundam-emacs-mode-map [up]     'gundam-emacs-move-up)
(define-key gundam-emacs-mode-map [down]   'gundam-emacs-move-down)
(define-key gundam-emacs-mode-map "h"      'gundam-emacs-move-left)
(define-key gundam-emacs-mode-map "l"      'gundam-emacs-move-right)
(define-key gundam-emacs-mode-map "k"      'gundam-emacs-move-up)
(define-key gundam-emacs-mode-map "j"      'gundam-emacs-move-down)
(define-key gundam-emacs-mode-map "\C-b"   'gundam-emacs-move-left)
(define-key gundam-emacs-mode-map "\C-f"   'gundam-emacs-move-right)
(define-key gundam-emacs-mode-map "\C-p"   'gundam-emacs-move-up)
(define-key gundam-emacs-mode-map "\C-n"   'gundam-emacs-move-down)
(define-key gundam-emacs-mode-map gundam-emacs-left-key  'gundam-emacs-move-left)
(define-key gundam-emacs-mode-map gundam-emacs-right-key 'gundam-emacs-move-right)
(define-key gundam-emacs-mode-map gundam-emacs-up-key    'gundam-emacs-move-up)
(define-key gundam-emacs-mode-map gundam-emacs-down-key  'gundam-emacs-move-down)
(define-key gundam-emacs-mode-map gundam-emacs-quit-key  'gundam-emacs-quit)
(define-key gundam-emacs-mode-map gundam-emacs-pause-key 'gundam-emacs-pause)
(define-key gundam-emacs-mode-map gundam-emacs-beam-key  'gundam-emacs-beam)

(defun gundam-emacs-display-options ()
  "Computes display options (required by gamegrid for colors)."
  (let ((options (make-vector 256 nil)))
    (cl-loop for c from 0 to 255 do
             (aset options c
                   (cond
                    ;;((= c gundam-emacs-blank)   gundam-emacs-blank-16-options)
                    ((= c gundam-emacs-blank-16-0) gundam-emacs-blank-16-0-options)
                    ((= c gundam-emacs-blank-16-1) gundam-emacs-blank-16-1-options)
                    ((= c gundam-emacs-blank-16-2) gundam-emacs-blank-16-2-options)
                    ((= c gundam-emacs-blank-16-3) gundam-emacs-blank-16-3-options)
                    ((= c gundam-emacs-blank-16-4) gundam-emacs-blank-16-4-options)

                    ((= c gundam-emacs-blank-16-5) gundam-emacs-blank-16-5-options)
                    ((= c gundam-emacs-blank-16-6) gundam-emacs-blank-16-6-options)
                    ((= c gundam-emacs-blank-16-7) gundam-emacs-blank-16-7-options)
                    ((= c gundam-emacs-blank-16-8) gundam-emacs-blank-16-8-options)

                    ((= c gundam-emacs-blank-16-9)  gundam-emacs-blank-16-9-options)
                    ((= c gundam-emacs-blank-16-10) gundam-emacs-blank-16-10-options)

                    ((= c gundam-emacs-blank-16-11) gundam-emacs-blank-16-11-options)
                    ((= c gundam-emacs-blank-16-12) gundam-emacs-blank-16-12-options)
                    ((= c gundam-emacs-blank-16-13) gundam-emacs-blank-16-13-options)
                    ((= c gundam-emacs-blank-16-14) gundam-emacs-blank-16-14-options)
                    ((= c gundam-emacs-blank-16-15) gundam-emacs-blank-16-15-options)
                    ((= c gundam-emacs-blank-16-16) gundam-emacs-blank-16-16-options)

                    ((= c gundam-emacs-border)  gundam-emacs-border-options)
                    ((= c gundam-emacs-player)  gundam-emacs-player-options)
                    ((= c gundam-emacs-enemy)   gundam-emacs-enemy-options)

                    ((= c gundam-emacs-beam)   gundam-emacs-beam-options)
                    ((= c gundam-emacs-explosion) gundam-emacs-explosion-options)

                    (t
                     '(nil nil nil)))))
    options))

(defun gundam-emacs-init-buffer ()
  "Initialize gundam-emacs buffer and draw stuff thanks to gamegrid library."
  (interactive)
  (get-buffer-create gundam-emacs-buffer-name)
  (switch-to-buffer gundam-emacs-buffer-name)
  (use-local-map gundam-emacs-mode-map)

  (setq gamegrid-use-glyphs t)
  (setq gamegrid-use-color t)
  (gamegrid-init (gundam-emacs-display-options))

  (gamegrid-init-buffer
   gundam-emacs-width
   (+ 2 gundam-emacs-height)
   ?\s)

  (let ((buffer-read-only nil))
    (cl-loop for y from 0 to (1- gundam-emacs-height) do
             (cl-loop for x from 0 to (1- gundam-emacs-width) do
                      (cond
                       ;; ((= gundam-emacs-blank (elt (elt gundam-emacs-map y) x))
                       ;;  (gamegrid-set-cell x y gundam-emacs-blank))
                       ((= gundam-emacs-blank-16-0 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-0))
                       ((= gundam-emacs-blank-16-1 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-1))
                       ((= gundam-emacs-blank-16-2 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-2))
                       ((= gundam-emacs-blank-16-3 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-3))
                       ((= gundam-emacs-blank-16-4 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-4))

                       ((= gundam-emacs-blank-16-5 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-5))
                       ((= gundam-emacs-blank-16-6 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-6))
                       ((= gundam-emacs-blank-16-7 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-7))
                       ((= gundam-emacs-blank-16-8 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-8))

                       ((= gundam-emacs-blank-16-9 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-9))
                       ((= gundam-emacs-blank-16-10 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-10))
                       ((= gundam-emacs-blank-16-11 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-11))
                       ((= gundam-emacs-blank-16-12 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-12))
                       ((= gundam-emacs-blank-16-13 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-13))
                       ((= gundam-emacs-blank-16-14 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-14))
                       ((= gundam-emacs-blank-16-15 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-15))
                       ((= gundam-emacs-blank-16-16 (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-blank-16-16))

                       ((= gundam-emacs-border (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-border))

                       ((= gundam-emacs-beam (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-beam))

                       ((= gundam-emacs-explosion (elt (elt gundam-emacs-map y) x))
                        (gamegrid-set-cell x y gundam-emacs-explosion))

                       ))))

  (gamegrid-set-cell gundam-emacs-player-x gundam-emacs-player-y gundam-emacs-player)
  (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-enemy))

(defun gundam-emacs-move-left ()
  "Move player left."
  (interactive)
  (if (> gundam-emacs-player-x 0)
      (gundam-emacs-update-player (1- gundam-emacs-player-x) gundam-emacs-player-y)))

(defun gundam-emacs-move-right ()
  "Move player right."
  (interactive)
  (if (< gundam-emacs-player-x (1- gundam-emacs-width))
      (gundam-emacs-update-player (1+ gundam-emacs-player-x) gundam-emacs-player-y)))

(defun gundam-emacs-move-up ()
  "Move bat 2 up."
  (interactive)
  (if (> gundam-emacs-player-y 0)
      (gundam-emacs-update-player gundam-emacs-player-x (1- gundam-emacs-player-y))))

(defun gundam-emacs-move-down ()
  "Move bat 2 down."
  (interactive)
  (if (< gundam-emacs-player-y (1- gundam-emacs-height))
      (gundam-emacs-update-player gundam-emacs-player-x (1+ gundam-emacs-player-y))))

(defun gundam-emacs-beam ()
  "beam."
  (interactive)
  (if (and
       (> gundam-emacs-player-y 0)
       (null gundam-emacs-beam-toggle))
      (progn
        (setq gundam-emacs-beam-toggle t)
        (setq gundam-emacs-beam-x gundam-emacs-player-x)
        (setq gundam-emacs-beam-y (- gundam-emacs-player-y 1))
        )))

(defun gundam-emacs-enemy-hit ()
  "Enemy hit check."

  (cond
   ((and (= gundam-emacs-enemy-x gundam-emacs-player-x) (= gundam-emacs-enemy-y gundam-emacs-player-y)) ;; プレーヤーと敵が重なった場合
    (gamegrid-set-cell gundam-emacs-start-x gundam-emacs-start-y gundam-emacs-player)  ;; スタート位置にプレーヤーを描画
    (gamegrid-set-cell gundam-emacs-player-x gundam-emacs-player-y gundam-emacs-blank-0) ;; プレーターの位置に空白描画
    (setq gundam-emacs-player-x gundam-emacs-start-x) ;; プレーヤーのxをスタート位置へ
    (setq gundam-emacs-player-y gundam-emacs-start-y) ;; プレーヤーのyをスタート位置へ
    )))

;;      (= gundam-emacs-blank-1 (elt (elt gundam-emacs-map y) x))
;;      (= gundam-emacs-blank-2 (elt (elt gundam-emacs-map y) x)))

(defun gundam-emacs-update-player (x y)
  "Move a player (suppress a cell and draw another one on the other side)."

  (cond
   ((string-equal (buffer-name (current-buffer))
                  gundam-emacs-buffer-name)

    ;; 被弾
    (cond
     ((gundam-emacs-enemy-hit))
     (
      ;; プレーヤーの移動予定位置がブランクならば
      (or
       (= gundam-emacs-blank-16-0 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-1 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-2 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-3 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-4 (elt (elt gundam-emacs-map y) x))

       (= gundam-emacs-blank-16-5 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-6 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-7 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-8 (elt (elt gundam-emacs-map y) x))

       (= gundam-emacs-blank-16-9  (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-10 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-11 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-12 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-13 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-14 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-15 (elt (elt gundam-emacs-map y) x))
       (= gundam-emacs-blank-16-16 (elt (elt gundam-emacs-map y) x))
       )

      ;; 移動予定位置x yへプレーヤーを描画
      (gamegrid-set-cell x y gundam-emacs-player)

      ;; プレーヤーの位置にブランク描画
      ;; (gamegrid-set-cell gundam-emacs-player-x gundam-emacs-player-y gundam-emacs-blank)
      (gamegrid-set-cell gundam-emacs-player-x gundam-emacs-player-y gundam-emacs-blank-16-0)

      (setq gundam-emacs-player-x x) ;; プレーヤーの位置として、移動予定位置xを確定
      (setq gundam-emacs-player-y y) ;; プレーヤーの位置として、移動予定位置yを確定
      ))

    ;; ゴール判定
    (cond
     ((and (= gundam-emacs-player-x gundam-emacs-goal-x) (= gundam-emacs-player-y gundam-emacs-goal-y))
      (message "You get goal!")
      ;; (sit-for 3)
      )))))

(defun gundam-emacs-update-enemy ()
  "Move a enemy."

  (gundam-emacs-enemy-hit)

  (if (= 1 (random 10))
      (progn
        (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-blank-16-0)
        (setq gundam-emacs-enemy-x
              (+ gundam-emacs-enemy-x (1- (random 3))))
        (if (= gundam-emacs-enemy-x -1)
            (setq gundam-emacs-enemy-x 0))
        (if (> gundam-emacs-enemy-x (- gundam-emacs-width 1))
            (setq gundam-emacs-enemy-x (- gundam-emacs-width 1)))
        )
    )

  (if (= 1 (random 10))
      (progn
        (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-blank-16-0)

        ;; 1. ランダム移動
        ;; (setq gundam-emacs-enemy-y
        ;;       (+ gundam-emacs-enemy-y (1- (random 3))))
        ;; (if (= gundam-emacs-enemy-y -1)
        ;;     (setq gundam-emacs-enemy-y 0))
        ;; (if (> gundam-emacs-enemy-y gundam-emacs-height)
        ;;     (setq gundam-emacs-enemy-y gundam-emacs-height))

        ;; 2. 少しずつ下へ移動
        (setq gundam-emacs-enemy-y
              (1+ gundam-emacs-enemy-y))
        (if (= gundam-emacs-enemy-y (1- gundam-emacs-height))
            (setq gundam-emacs-gameover t))
        )
    )
  (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-enemy)
  (gundam-emacs-enemy-hit))

(defun gundam-emacs-update-beam ()
  "Move beam."
  ;;(gundam-emacs-beam-hit)

  ;; ビームを発射しているかどうかの状態判定。
  ;; 発射しているならば、3回分、ビームを上へ動かしつつ表示させる。
  (if gundam-emacs-beam-toggle
      (progn
        ;; (gamegrid-set-cell gundam-emacs-beam-x gundam-emacs-beam-y gundam-emacs-blank-16-0)
        (setq gundam-emacs-beam-y (- gundam-emacs-beam-y 1))
        (if (= gundam-emacs-beam-y -1) (setq gundam-emacs-beam-toggle nil)
          (gamegrid-set-cell gundam-emacs-beam-x gundam-emacs-beam-y gundam-emacs-beam))
        (if (and
             (= gundam-emacs-beam-x gundam-emacs-enemy-x)
             (= gundam-emacs-beam-y gundam-emacs-enemy-y))
            (progn
              (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-explosion)
              (setq gundam-emacs-enemy-x 0)
              (setq gundam-emacs-enemy-y 0)
              ))))
  (if gundam-emacs-beam-toggle
      (progn
        ;; (gamegrid-set-cell gundam-emacs-beam-x gundam-emacs-beam-y gundam-emacs-blank-16-0)
        (setq gundam-emacs-beam-y (- gundam-emacs-beam-y 1))
        (if (= gundam-emacs-beam-y -1) (setq gundam-emacs-beam-toggle nil)
          (gamegrid-set-cell gundam-emacs-beam-x gundam-emacs-beam-y gundam-emacs-beam))
        (if (and
             (= gundam-emacs-beam-x gundam-emacs-enemy-x)
             (= gundam-emacs-beam-y gundam-emacs-enemy-y))
            (progn
              (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-explosion)
              (setq gundam-emacs-enemy-x 0)
              (setq gundam-emacs-enemy-y 0)
              ))))
  (if gundam-emacs-beam-toggle
      (progn
        ;; (gamegrid-set-cell gundam-emacs-beam-x gundam-emacs-beam-y gundam-emacs-blank-16-0)
        (setq gundam-emacs-beam-y (- gundam-emacs-beam-y 1))
        (if (= gundam-emacs-beam-y -1) (setq gundam-emacs-beam-toggle nil)
          (gamegrid-set-cell gundam-emacs-beam-x gundam-emacs-beam-y gundam-emacs-beam))
        (if (and
             (= gundam-emacs-beam-x gundam-emacs-enemy-x)
             (= gundam-emacs-beam-y gundam-emacs-enemy-y))
            (progn
              (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-explosion)
              (setq gundam-emacs-enemy-x 0)
              (setq gundam-emacs-enemy-y 0)
              ))))
  )

(defun gundam-emacs-init ()
  "Initialize a game."

  (add-hook 'kill-buffer-hook 'gundam-emacs-quit nil t)

  ;; Initialization of some variables
  (setq gundam-emacs-player-x gundam-emacs-start-x)
  (setq gundam-emacs-player-y gundam-emacs-start-y)
  (setq gundam-emacs-enemy-x gundam-emacs-enemy-min-x)
  (setq gundam-emacs-enemy-y 1)

  (gundam-emacs-init-buffer)  
  (gamegrid-kill-timer)
  (gamegrid-start-timer gundam-emacs-timer-delay 'gundam-emacs-update-game))

(defun gundam-emacs-update-game (gundam-emacs-buffer)
  "It is called every pong-cycle-delay seconds and
updates enemy positions."
  (if (not (eq (current-buffer) gundam-emacs-buffer))
      (gundam-emacs-pause)

    ;; ;; add by SUGANO
    ;; 新型スムーズ・スクロール
    ;; 新しい値の出現
    (cl-loop for x from 0 to (1- gundam-emacs-width) do
             (cond
              ((= gundam-emacs-blank-16-0 (elt (elt gundam-emacs-map 0) x))
               (setf (aref (aref gundam-emacs-map 0) x)
                     ;; ;; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                     ;; (* (random 2) (random 2) (random 2) (random 2))))
                     ;; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                     (* (random 2) (random 2) (random 2) (random 2) (random 2))))
              )
             )

    ;; cl-loop 縦 行を示す y の値は、大きな数字から小さな数字へ
    ;; 睡眠不足 スクロールが逆になってしまった
    ;; スロー・スクロール
    ;; aset の使い方がわからない

    ;; y は (1- gundam-emacs-height) から　0 へ
    ;; (- (1- gundam-emacs-height) y) をカウンタとして使えばよい。 memo 参照
    ;; 8段階
    (cl-loop for i from 0 to (1- gundam-emacs-height) do
             (setq y (- (1- gundam-emacs-height) i))
             (cl-loop for x from 0 to (1- gundam-emacs-width) do
                      (cond
                       
                       ;; ;; 8 -> 0
                       ;; ((= gundam-emacs-blank-16-8 (elt (elt gundam-emacs-map y) x))
                       ;;  (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-0)
                       ;;  ;; i が 0 で y は画面最下行。最下行以外で次の行へスクロール。
                       ;;  (if (/= i 0)
                       ;;      (setf (aref (aref gundam-emacs-map (1+ y)) x) gundam-emacs-blank-16-1)
                       ;;    )
                       ;;  )

                       ;; 16 -> 0
                       ((= gundam-emacs-blank-16-16 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-0)
                        ;; i が 0 で y は画面最下行。最下行以外で次の行へスクロール。
                        (if (/= i 0)
                            (setf (aref (aref gundam-emacs-map (1+ y)) x) gundam-emacs-blank-16-1)
                          )
                        )

                       ;; 15 -> 16
                       ((= gundam-emacs-blank-16-15 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-16))
                       ;; 14 -> 15
                       ((= gundam-emacs-blank-16-14 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-15))
                       ;; 13 -> 14
                       ((= gundam-emacs-blank-16-13 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-14))
                       ;; 12 -> 13
                       ((= gundam-emacs-blank-16-12 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-13))
                       ;; 11 -> 12
                       ((= gundam-emacs-blank-16-11 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-12))
                       ;; 10 -> 11
                       ((= gundam-emacs-blank-16-10 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-11))
                       ;; 9 -> 10
                       ((= gundam-emacs-blank-16-9 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-10))
                       ;; 8 -> 9
                       ((= gundam-emacs-blank-16-8 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-9))

                       ;; 7 -> 8
                       ((= gundam-emacs-blank-16-7 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-8))
                       ;; 6 -> 7
                       ((= gundam-emacs-blank-16-6 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-7))
                       ;; 5 -> 6
                       ((= gundam-emacs-blank-16-5 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-6))
                       ;; 4 -> 5
                       ((= gundam-emacs-blank-16-4 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-5))
                       ;; 3 -> 4
                       ((= gundam-emacs-blank-16-3 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-4))
                       ;; 2 -> 3
                       ((= gundam-emacs-blank-16-2 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-3))
                       ;; 1 -> 2
                       ((= gundam-emacs-blank-16-1 (elt (elt gundam-emacs-map y) x))
                        (setf (aref (aref gundam-emacs-map y) x) gundam-emacs-blank-16-2))
                       )))

    ;; キャラクタの描画
    (let ((buffer-read-only nil))
      (cl-loop for y from 0 to (1- gundam-emacs-height) do
               (cl-loop for x from 0 to (1- gundam-emacs-width) do
                        (cond
                         ((= gundam-emacs-blank-16-0 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-0))
                         ((= gundam-emacs-blank-16-1 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-1))
                         ((= gundam-emacs-blank-16-2 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-2))
                         ((= gundam-emacs-blank-16-3 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-3))
                         ((= gundam-emacs-blank-16-4 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-4))

                         ((= gundam-emacs-blank-16-5 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-5))
                         ((= gundam-emacs-blank-16-6 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-6))
                         ((= gundam-emacs-blank-16-7 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-7))
                         ((= gundam-emacs-blank-16-8 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-8))

                         ((= gundam-emacs-blank-16-9 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-9))
                         ((= gundam-emacs-blank-16-10 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-10))
                         ((= gundam-emacs-blank-16-11 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-11))
                         ((= gundam-emacs-blank-16-12 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-12))
                         ((= gundam-emacs-blank-16-13 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-13))
                         ((= gundam-emacs-blank-16-14 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-14))
                         ((= gundam-emacs-blank-16-15 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-15))
                         ((= gundam-emacs-blank-16-16 (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-blank-16-16))

                         ((= gundam-emacs-border (elt (elt gundam-emacs-map y) x))
                          (gamegrid-set-cell x y gundam-emacs-border))))))

    (gamegrid-set-cell gundam-emacs-player-x gundam-emacs-player-y gundam-emacs-player)
    (gamegrid-set-cell gundam-emacs-enemy-x gundam-emacs-enemy-y gundam-emacs-enemy)
    )
  ;; added by SUGANO

  (gundam-emacs-update-beam)
  (gundam-emacs-update-enemy)
  (if gundam-emacs-gameover
      (gundam-emacs-quit))
  )

(defun gundam-emacs-pause ()
  "Pause the game."
  (interactive)
  (gamegrid-kill-timer)
  ;; Oooohhh ugly.  I don't know why, gamegrid-kill-timer don't do the
  ;; jobs it is made for.  So I have to do it "by hand".  Anyway, next
  ;; line is harmless.
  (cancel-function-timers 'gundam-emacs-update-game)
  (define-key gundam-emacs-mode-map gundam-emacs-resume-key 'gundam-emacs-resume))

(defun gundam-emacs-resume ()
  "Resume a paused game."
  (interactive)
  (define-key gundam-emacs-mode-map gundam-emacs-pause-key 'gundam-emacs-pause)
  (gamegrid-start-timer gundam-emacs-timer-delay 'gundam-emacs-update-game))

(defun gundam-emacs-quit ()
  "Quit the game and kill the gundam-emacs buffer."
  (interactive)
  (gamegrid-kill-timer)
  ;; Be sure not to draw things in another buffer and wait for some
  ;; time.
  ;; (kill-buffer gundam-emacs-buffer-name)

  ;; バッファを自動削除
  ;; (run-with-timer gundam-emacs-timer-delay nil 'kill-buffer gundam-emacs-buffer-name)
  )

;;;###autoload
(defun gundam-emacs ()
  "Play gundam-emacs and waste time.
This is an implementation of the classical game gundam-emacs.
Move left and right bats and try to bounce the ball to your opponent.

gundam-emacs-mode keybindings:\\<gundam-emacs-mode-map>

\\{gundam-emacs-mode-map}"
  (interactive)

  (setq gundam-emacs-gameover nil)

  (gundam-emacs-init))

(provide 'gundam-emacs)

;;; gundam-emacs.el ends here
