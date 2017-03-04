{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module MapReduce where

import Control.Distributed.Process
import Control.Distributed.BriskStatic
import Control.Distributed.Process.Closure
import Control.Distributed.Process.SymmetricProcess

import Utils
import Master

remotable [ 'master ]

main :: Process ()
main =  do let node = undefined
           spawn node $ $(mkBriskClosure 'master) ()
           return ()
