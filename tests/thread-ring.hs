-- The Computer Language Benchmarks Game
-- http://shootout.alioth.debian.org/
-- Contributed by Jed Brown with improvements by Spencer Janssen and Don Stewart

import Control.Monad
import Control.Concurrent (forkIO)
#if defined(STRICT)
import Control.Concurrent.MVar.Strict
#else
import Control.Concurrent.MVar
#endif
import System.Environment

ring = 503

new l i = do
  r <- newEmptyMVar
  forkIO (thread i l r)
  return r

thread :: Int -> MVar Int -> MVar Int -> IO ()
thread i l r = go
  where go = do
          m <- takeMVar l
          when (m == 1) (print i)
          putMVar r (m - 1) -- strict enough
          when (m > 0) go

main = do
  a <- newMVar . read . head =<< getArgs
  z <- foldM new a [2..ring]
  thread 1 z a
