#因子名が数字となっている場合:数字の頭にXがつく
#およびマイナスが含むcsvを数字に変える
#Dataset <- read.csv(file.choose()) ダイアログからファイル開くときはこちら
Dir <- getwd()
Dataset <- read.csv("test3d.csv")
head(Dataset)
library(reshape2)
library(rgl)
library(scatterplot3d)
library(mgcv)
library(car)
d <- melt(Dataset,id="length")
d

#いちいちやる方法はこちら
d["variable"] <- lapply(d["variable"],gsub,pattern="X200",replacement="200")
d["variable"] <- lapply(d["variable"],gsub,pattern="X400",replacement="400")
d["variable"] <- lapply(d["variable"],gsub,pattern="X600",replacement="600")
d["variable"] <- lapply(d["variable"],gsub,pattern="X800",replacement="800")
d["variable"] <- lapply(d["variable"],gsub,pattern="X1000",replacement="1000")
d["variable"] <- lapply(d["variable"],gsub,pattern="X.200",replacement="-200")
d["variable"] <- lapply(d["variable"],gsub,pattern="X.400",replacement="-400")
d["variable"] <- lapply(d["variable"],gsub,pattern="X.600",replacement="-600")
d["variable"] <- lapply(d["variable"],gsub,pattern="X.800",replacement="-800")
d["variable"] <- lapply(d["variable"],gsub,pattern="X.1000",replacement="-1000")

#まとめてやるのはこちら。「.」は正規表現のため、\\.で.扱いにする。
d["variable"] <- sapply(d["variable"],gsub,pattern="X\\.",replacement="-")
d["variable"] <- sapply(d["variable"],gsub,pattern="X",replacement="")

#型が文字列characterになっているので数値numericにする
d$variable <- as.numeric(d$variable)
#データフレーム化

d2 <- data.frame(d)
d2 <-na.omit(d2)
d2
scatter3d(value~length+variable, 
          data=d2,fit="smooth", 
          residuals=TRUE, 
          bg="white", 
          axis.scales=TRUE, 
          grid=TRUE, 
          ellipsoid=FALSE,xlab="length",ylab="y",zlab="w")
#マウスで動くプロット
play3d( spin3d( axis = c(0, 1, 0), rpm = 3), duration = 10 )

#自動的に回転するプロット

movie3d(
  movie="3dAnimatedScatterplot",
  spin3d( axis = c(0, 1, 0), rpm = 3),
  duration = 10,
  dir = Dir,
  type = "gif",
  clean = TRUE
)


#列名変更したい場合。左が変えたあと、みぎがかえるまえ
#d2 <- rename(d2, y = value)