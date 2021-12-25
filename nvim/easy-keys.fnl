;;; To contribute:
;;; - [ ] why do they differ: labels and safe_labels?
;;; - [ ] explain auto-jump. (is it:? https://github.com/ggandor/lightspeed.nvim#jump-on-partial-input)
;;; - [ ] explain `smart mode` https://github.com/ggandor/lightspeed.nvim#other-quality-of-life-features
;;; - [ ] readme:`grouping matches by distance`: reference to mapping name
;;; --]]

;;; Choose the best labels:
;;; 1. Sort all the letters from easy to hard (to reach)
;;; 1.1. staggered or ortholinear
;;; 1.2. layout (qwerty dvorak colemak workman)
;;; 2. Safe labels are those represent motions: one unlikely need a motion right after a jump
;;; 3. Unsafe labels are those represent editing: obviously you make a jump to edit there

;;; ?: should we use capitals?
;;;    + pros: get more labels
;;;    - cons: they are effectively a chords, not a single keys
;;;
;;; ?: what if not mix caps with lowercase, but exclusively use caps?
;;;    + pros: significantly less likely to clash with a command right after jump
;;;
;;; ?: should we use punctuation?
;;;    + pros: get more labels (only a little bit)
;;;    - cons: ? letters are better to pronounce ?
 
;;; - [ ] list the keys, which are considered frequently used right after jump: -another jump; -insertion. They should be either excluded or moved to the end of the list

;; Smartly copy-pasted from https://workmanlayout.org
(var keyboard
  {:staggered [
     4 2 2 3 4 5 3 2 2 4
      1 1 1 1 3 3 1 1 1 1
       4 4 3 2 5 3 2 3 4 4]
   :ortholinear [
     4 2 2 3 4 4 3 2 2 4
     1 1 1 1 3 3 1 1 1 1
     4 4 3 2 4 4 2 3 4 4]
   :dactyl [
     4 2 2 3 3   3 3 2 2 4
     1 1 1 1 3   3 1 1 1 1
     4 4 3 2 3   3 2 3 4 4]})

(var layout {
  :qwerty "
    q w e r t y u i o p
    a s d f g h j k l ;
    z x c v b n m , . / "
  :dvorak "
    ' , . p y f g c r l
    a o e u i d h t n s
    ; q j k x b m w v z "
  :colemak "
    q w f p g j l u y ;
    a r s t d h n e i o
    z x c v b k m , . / "
  :workman "
    q d r w b j f u p ;
    a s h t g y n e o i
    z x m c v k l , . / "})

local function labels ()


  local nonletters = {"'", ',', ';', '.'}

  --[[ TODO build a table with labels
            1. combine keyboard and layout
            2. sort by effort
            3. ? cut by effort ?
            4. remove nonletters
  --]]


  -- NOTE safe_jump is to be followed by esc or lookup
  --      it is almost like `esc` is the first jump label

  -- ??? : unsafe_labels are those which clash with commands likely to be used right after auto-jump ???

  --[[ UX
  -- 1. look at the target. Identify the two letters xy
  -- 2. press sxy
  -- 3. already arrived? then probably edit something. Otherwise:
  -- 4. read the label and press it.
  --]]

  local edits = {
    'p', 'y', -- paste and copy
    '.', -- repeat
    'd', 'x', 'r', -- delete and replace
    'a', 'i', 'o', 'c', -- enter insert mode
  }

  local motions = {
    'h', 'j', 'k', 'l', -- charwise
    'f', 't', ',', ';', -- bread and butter of lightspeed
    's', -- the bread and butter too?
    'n', -- search
    'b', 'e', 'w', -- wordwise
  }

  local edits_grouped = {
    {'d', 'c', 'a', 'i', 'o'}, -- very common right after a jump (proof?)
    {'r', 'x', 'p', 'y', '.'}, -- maybe a bit less common (proof?)
  }

  local motions_grouped = {
    {'h', 'l', -- correcting a by-one error
     'k', 'j', -- maybe when hunting for an empty line?
    },
    {'b', 'e', 'w', 'n', -- looks meaningless after a jump. When correcting a selection?
     ',', ';', -- non-sense: repeat one-letter search in the middle of two-letter-one
     'f', 't', -- non-sense: start a search right in the middle of a search? Nah!:)
    },
  }

  local others = {
    {'g', -- likely to be used. At least `gd`
     'z', -- also a start of many commands. Suggest for spelling fixes z=
     'v', 'q', 'm', -- why not?
    },
    {'u'}, -- unlikely to undo right after a jump, as well as after any motion
  }

  return nil
end
