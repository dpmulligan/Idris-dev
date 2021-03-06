module Idris.Unlit(unlit) where

import Core.TT
import Data.Char

unlit :: FilePath -> String -> TC String
unlit f s = do let s' = map ulLine (lines s)
               check f 1 s'
               return $ unlines (map snd s')

data LineType = Prog | Blank | Comm

ulLine ('>':' ':xs)        = (Prog, xs)
ulLine ('>':xs)            = (Prog, xs)
ulLine xs | all isSpace xs = (Blank, "")
          | otherwise      = (Comm, '-':'-':xs)

check f l (a:b:cs) = do chkAdj f l (fst a) (fst b)
                        check f (l+1) (b:cs)
check f l [x] = return ()
check f l [] = return ()

chkAdj f l Prog Comm = tfail $ At (FC f l) ProgramLineComment
chkAdj f l Comm Prog = tfail $ At (FC f l) ProgramLineComment
chkAdj f l _    _    = return ()


