module Main where

import List (sort)
import Data.Map hiding (map,filter)
import System

--w6+3 = (Schaden 1 3)
data Schaden = Schaden {w6  :: Int
                       ,mod :: Int}
               deriving (Show)

--Verbreitete Schadenstypen werden doppelt gewichtet. (2,Schaden ...)
gewSchaden :: [(Int,Schaden)]
gewSchaden = [(1,Schaden 1 (-1)) -- Wurfmesser
             ,(2,Schaden 1 0)  -- Messer/Faust
             ,(2,Schaden 1 1)  -- Dolch
             ,(2,Schaden 1 2)  -- Kurzschwert
             ,(2,Schaden 1 3)  -- Säbel
             ,(3,Schaden 1 4)  -- Schwert
             ,(2,Schaden 1 5)  -- Bastardschwert
             ,(2,Schaden 1 6)  -- Tuzakmesser/Warunker/+2 Kurzbogen
             ,(1,Schaden 1 7)  -- +2 Ork. Reiterbogen
             ,(1,Schaden 1 8)  -- +2 Kompositbogen
             ,(1,Schaden 1 9)  -- +2 Langbogen
             ,(1,Schaden 1 10) -- +2 Kriegsbogen
             ,(1,Schaden 2 2)  -- Rondrakamm/Langaxt/Felsspalter
             ,(2,Schaden 2 3)  -- Kriegshammer
             ,(2,Schaden 2 4)  -- Pailos/Bidenhänder
             ,(1,Schaden 2 6)  -- Boronsichel
             ,(1,Schaden 3 2)  -- Barbarenaxt/Andergaster
             ]

--Eine Map aller mögl. Schäden. Diese werden je nach Gewichtung und Abstand zur
--maximalen Würfelzahl vervielfacht.
--(Wenn ein 2w+2 Wurf in gewSchaden vorkommt, produziert dieser 36 Schadenseinträge,
-- ein w+2 Wurf hingegen nur 6. Letzterer muss daher 6x gewichtet/dupliziert werden,
-- um ein Gleichgewicht zu gewährleisten)
--Zudem werden Wuchtschläge von 1-6 einkalkuliert mit halber Gewichtung, weshalb
--die normale Gewichtung generell mal 2 genommen wird für andere und die Wuchtschlag-
--Gewichtung 1 ist.
schadensMap :: Map Int Int
schadensMap = fromList $ unite sorted
              where unite xs = noDup [(x,foldr ((+).snd) 0 (filter ((==x).fst) xs))
                                     |(x,_)<-xs]
                    sorted = sort [(w+m,g*eGr2 b*6^(maxW-n))
                                  |(g,Schaden n m)<-gewSchaden
                                  ,w<-wuerfle n
                                  ,b<-[0..8]] --Wuchtschlag bonus
                    maxW = foldl1 max $ map getW gewSchaden
                    getW (_,Schaden w _) = w
                    eGr2 b = if (b<=2) then 2 else 1

mapSum m = foldl f 0 $ assocs m
       where f sum (s,n) = sum+s*n

noDup [] = []
noDup (x:xs) | x `elem` xs = noDup xs
             | otherwise = x:noDup xs


repLst :: Int -> [a] -> [a]
repLst n xs = pull $ map (replicate n) xs

-- Alle Würfelergebnisse für n-W6 (jeweils addiert)
wuerfle :: Int -> [Int]
wuerfle 1 = [1..6]
wuerfle n = pull [map (+w) $ wuerfle (n-1)|w<-[1..6]]

pull :: [[a]] -> [a]
pull = foldl (++) []

fkt :: [Rational]
fkt = [0.2
      ,0.4
      ,0.7
      ,1.1
      ,1.6]
      
--Nimmt eine Entscheidungsfunktion und eine Faktorliste (für die Wundschwellen)
--entgegen und konvertiert daraus Schaden -> Verletzungen
--Sinnvoll für dct sind: decide, decideUM, decide UML
dmg2vrl dct fkt = min 3 $ foldl dct 0 fkt

--Wie dmg2vrl, aber konvertiert Schaden -> Wunden
--Sinnvoll sind nur: decide, decideUM
dmg2wnd dct fkt = max 0 $ foldl dct (-1) fkt

--decideUML = decide UnModified-LepVerl Berechnung (für mehr Verl., spielerfreundlicher)
--decideUM  = decide UnModified (Momentan verwendet für Berechnung der Verl.)
--Mit Currying alle bis auf die letzten zwei Parameter angeben, dann als f für fold
decideUML :: Int -> Int -> Int -> Rational -> Int
decideUM  :: Int -> Int -> Int -> Rational -> Int
decide    :: Int -> Int -> Int -> Int -> Rational -> Int
decideUML d ko v f =   if   fromIntegral d<=fromIntegral ko * f 
                       then v
                       else (if v==0 then v+1 else v+2)
decideUM  d ko v f =   if   fromIntegral d<=fromIntegral ko * f   then v else v+1
decide    d ko m v f = if fromIntegral d<=fromIntegral (ko+m) * f then v else v+1


verhLepVerl :: Int -> Rational
verhLepVerl ko = fromIntegral (mapSum schadensMap)
                 / (fromIntegral $ foldWithKey f 0 schadensMap)
            where f s g sum = sum + g*dmg2vrl (decideUM s ko) fkt

anzVerl :: Int -> Int -> Int
anzVerl ko lep = round $ fromIntegral lep / verhLepVerl ko

verlWundAb :: Int -> Int -> [(Int,Int,Int)]
verlWundAb ko mod = [(1+(floor $ fromIntegral (ko+mod)*fkt!!0),1,0)
                    ,(1+(floor $ fromIntegral (ko+mod)*fkt!!1),2,1)
                    ,(1+(floor $ fromIntegral (ko+mod)*fkt!!2),3,2)
                    ,(1+(floor $ fromIntegral (ko+mod)*fkt!!3),3,3)
                    ,(1+(floor $ fromIntegral (ko+mod)*fkt!!4),3,4)]

sterbeVerl ko zh = round $ fromIntegral ko * (if zh then 1.5 else 1.0) / verhLepVerl ko

verteilung :: Int -> (Int,Int,Int,Int)
verteilung kst =  (s1,s2,s3,s4)
           where s4 = max 0 (floor ((fromIntegral kst)/4)) :: Int
                 s3 = max 0 (floor ((fromIntegral kst)/3-fromIntegral s4)) :: Int
                 s2 = max 0 (floor ((fromIntegral kst)/2-fromIntegral (s3+s4))) :: Int
                 s1 = kst - s2 -s3 -s4

versickern :: (Int,Int,Int,Int) -> (Int,Int,Int,Int)
versickern (s1,s2,s3,s4) | s4/=0 = (s1-1,s2,s3,s4+1) 
                         | s3/=0 = (s1-1,s2,s3+1,s4) 
                         | s2/=0 = (s1-1,s2+1,s3,s4)
                         | otherwise = error "error: s2=s3=s4=0"

uKst = "&#9744;"

pad l n | length (show n) >= l = show n
        | otherwise = '0':pad (l-1) n

zKst n = " " ++ (pull $ replicate n (uKst++" "))

verlBogen :: Int -> Int -> Int -> Bool -> String
verlBogen ko lep mod zh =
   "digraph G {\n"
 ++"  node [shape=record]\n"
 ++"title [label = \"{Verletzungsbogen"
 ++" | {Schaden | Verletzungen | Wunden } "
 ++" | { "++pad 2 s1++" | "++show v1++" | "++show w1++" }"
 ++" | { "++pad 2 s2++" | "++show v2++" | "++show w2++" }"
 ++" | { "++pad 2 s3++" | "++show v3++" | "++show w3++" }"
 ++" | { "++pad 2 s4++" | "++show v4++" | "++show w4++" }"
 ++" | { "++pad 2 s5++" | "++show v5++" | "++show w5++" }"
 ++" }\"]\n"
 ++"1 [label = \"{Kampfbereit | { "++zKst k1++" }}\"]\n"
 ++"2 [label = \"{Angeschlagen (-1/+3) | { "++zKst k2++" }}\"]\n"
 ++"3 [label = \"{Verwundet (-2/+6)| { "++zKst k3++" }}\"]\n"
 ++"4 [label = \"{Schwer Verwundet (-3/+9) | { "++zKst k4++" }}\"]\n"
 ++"5 [label = \"{Im Sterben | { "++zKst k5++" }}\"]\n"
 ++"title -> 1 -> 2 -> 3 -> 4 -> 5\n"
 ++"}\n"
   where kst = anzVerl ko lep
         (s1,v1,w1):(s2,v2,w2):(s3,v3,w3):(s4,v4,w4):(s5,v5,w5):[] = verlWundAb ko mod
         (k1,k2,k3,k4) = versickern (verteilung kst)
         k5 = sterbeVerl ko zh

app args
  | head args == "--vbogen" = do
    let ko  = read (args!!1) :: Int
    let lep = read (args!!2) :: Int
    let mod = if length (filter (/="zh") args) > 3 then read (args!!3) :: Int else 0
    let zh = if "zh" `elem` args then True else False
    putStr $ verlBogen ko lep mod zh
  | otherwise = do
    let ko = read (args!!0) :: Int
    let lep = read (args!!1) :: Int
    let zh = if "zh" `elem` args then True else False
    let mod = if length (filter (/="zh") args) > 2 then read (args!!2) :: Int else 0
    let kst = anzVerl ko lep
    let (s1,s2,s3,s4) = versickern $ verteilung kst
    let s5 = (sterbeVerl ko zh)
    if s1+s2+s3+s4 /= kst then error "error: s1+s2+s3+s4 /= kst" else return ()
    putStrLn "hv 0.1"
    putStrLn $ "KO:  "++show ko
    putStrLn $ "LeP: "++show lep
    putStrLn ""
    putStrLn "Schadenstabelle:"
    foldl1 (>>) $ map (\(s,v,w)->putStrLn ("  Ab: "++show s
                                           ++"  \tVerletzungen: "++show v
                                           ++"\tWunden: "++show w)) $
      verlWundAb ko mod
    putStrLn ""
    putStrLn   "Aufteilung:"
    putStrLn $ "  Kampfbereit:  " ++ show s1
    putStrLn $ "  Verletzt:     " ++ show s2
    putStrLn $ "  Schwer Verl.: " ++ show s3
    putStrLn $ "  Fast Hinüber: " ++ show s4
    putStrLn $ " Im Sterben: " ++ show s5

    putStrLn ""
    putStrLn ("Verletzungen Insgesamt: "++show kst
              ++"\t(fkt: "++show (fromRational $ verhLepVerl ko :: Double)++")")

main = do args <- getArgs
          app args
