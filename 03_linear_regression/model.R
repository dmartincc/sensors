library(data.table)
library(dplyr)
library(ggplot2)
library(stargazer)
library(caret)
library(reshape)
library(viridis)
library(tidytext)
library(stringr)


df <- read.csv("time_series_flu_model.csv")

delay <- 1:10
tabla <- data.table()
for(d in delay){
  fit <- lm(I ~ lag(I,1) + DT + DS + lag(DT,d) + lag(DS,d), data=df)
  fit <- lm.beta(fit)
  ss <- summary(fit)
  cat(d,ss$adj.r.squared,"\n")
  tabla <- rbind(
    tabla,
    data.table(d=d,var=names(coefficients(fit)),value=coefficients(fit), confint(fit)))
}

colnames(tabla2) <- c("d", "var", "value", "lwr", "upper")

gt <- ggplot(tabla2[var!="(Intercept)"],aes(x=d,y=value,col=var)) + 
  geom_line(size=0.5) +
  geom_point(size=1) +
  geom_ribbon(aes(ymin = lwr - 0.01, ymax = upper + 0.01, fill=var), alpha = 0.2, show.legend = FALSE, colour = NA) +
  theme_bw()  +  theme(
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.title = element_blank(),
    legend.text = element_text(size=10),
    axis.text.x = element_text(color = "black", size = 12, face = "bold"),
    axis.text.y = element_text(color = "black", size = 12, face = "bold"),
    aspect.ratio=1.3
  ) + labs(x = "t-n", y = "Standarized Coefficients") + 
  scale_x_continuous(breaks=seq(0,10,1)) +
  scale_y_continuous(breaks=seq(-0.5,1,0.25)) +
  geom_hline(yintercept=0, linetype="dashed", color = "grey") +
  scale_color_discrete(labels = c(expression(D[S]), expression(D[T]), expression(D["S,t-n"]), expression(D["T,t-n"]), expression(I[t-1])))

gt
ggsave("result.pdf")



fit <- lm(I ~ lag(I, 1) , data=df)
fit <- step(fit , trace=0)
fit <- lm.beta(fit)
summary(fit)
vif(fit)

fit1 <- lm(I ~ lag(I, 1) + DS + lag(DS,1) + DT + lag(DT,1) , data=df)
fit1 <- step(fit1 , trace=0)
fit1 <- lm.beta(fit1)
summary(fit1)
vif(fit1)

fit2 <- lm(I ~ lag(I, 1) + DS + lag(DS,2) + DT + lag(DT,2) , data=df)
fit2 <- step(fit2 , trace=0)
fit2 <- lm.beta(fit2)
summary(fit2)
vif(fit2)

fit3 <- lm(I ~ lag(I, 1) + DS + lag(DS,3) + DT + lag(DT,3) , data=df)
fit3 <- step(fit3, trace=0)
fit3 <- lm.beta(fit3)
summary(fit3)
vif(fit3)

fit4 <- lm(I ~ lag(I, 1) + DS + lag(DS,4) + DT + lag(DT,4) , data=df)
fit4 <- step(fit4, trace=0)
fit4 <- lm.beta(fit4)
summary(fit4)
vif(fit4)

vars.order <- c("x1", "x2", "x3", "x3:x1")


stargazer(fit, fit1, fit2, fit3,  fit4,
          coef = list(fit$standardized.coefficients, 
                      fit1$standardized.coefficients,
                      fit2$standardized.coefficients,
                      fit3$standardized.coefficients,
                      fit4$standardized.coefficients),
          column.labels=c("ILI", "T+S t-1", "T+S t-2","T+S t-3", "T+S t-4"), 
          dep.var.labels = "Official ILI rate levels",
          no.space=TRUE, font.size='tiny', type="text",
          column.sep.width='1pt', order=paste0("^", vars.order , "$"))

