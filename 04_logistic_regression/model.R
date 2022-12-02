library(data.table)
library(dplyr)
library(ggplot2)
library(stargazer)
library(viridis)
library(stringr)
library(caret)
library(reshape)
library(forcats)

df <- read.csv("model_sensors_behaviour_topics.csv")

smp_size <- floor(0.7 * nrow(df))

set.seed(123)
train_ind <- sample(seq_len(nrow(df)), size = smp_size)

train <- df[train_ind, ]
test <- df[-train_ind, ]

model <- glm(sensor ~  .,family=binomial(link='logit'),data=train)
model <- step(model,trace=FALSE)

model1 <- glm(sensor ~  .,family=binomial(link='logit'),data=dplyr::select(train, -gyration_radius, -out_degree, -number_posts_30days))
model1 <- step(model1,trace=FALSE)

train2 <- dplyr::select(train, sensor,  out_degree, number_posts_30days)
model2 <- glm(sensor ~  .,family=binomial(link='logit'),data=train2)
model2 <- step(model2,trace=FALSE)

train3 <- dplyr::select(train,sensor,  gyration_radius)
model3 <- glm(sensor ~  .,family=binomial(link='logit'),data=train3)
model3 <- step(model3,trace=FALSE)

stargazer(model1, model2, model3, model, 
          title="Sensors categories model",
          column.labels=c("Content","Behaviour", "Mobility", "All"),  
          dep.var.labels = "Sensor",
          no.space=TRUE, font.size='tiny',column.sep.width='1pt',
          single.row=T)


odds.context <- data.frame(cbind(OR = coef(model1), OR_CI=confint(model1)))
odds.context$model <- "Content"
odds.context$names <- rownames(odds.context)

odds.be <- data.frame(cbind(OR = coef(model2), OR_CI=confint(model2)))
odds.be$model <- "Behaviours"
odds.be$names <- rownames(odds.be)

odds.m <- data.frame(cbind(OR = coef(model3), OR_CI=confint(model3)))
odds.m$model <- "Mobility"
odds.m$names <- rownames(odds.m)

odds.all <- data.frame(cbind(OR = coef(model), OR_CI=confint(model)))
odds.all$model <- "All"
odds.all$names <- rownames(odds.all)

odds <- rbind(odds.context, odds.be, odds.m, odds.all)


colnames(odds) <- c("value", "low", "high", "model", "variable")

odds$type <- ifelse(odds$variable == "number_posts_30days", 2, 3)
odds$type <- ifelse(odds$variable == "gyration_radius", 2, odds$type)
odds$type <- ifelse(odds$variable == "out_degree", 2, odds$type)
odds$type <- ifelse(odds$variable == "(Intercept)", 1, odds$type)


odds  <- arrange(odds, value, type)

odds$variable <- as.character(odds$variable)
odds$model <- factor(odds$model)
odds$type <- factor(odds$type)


odds <- filter(odds,variable != "(Intercept)")

odds$variable <- str_to_title(odds$variable)
odds$variable <- str_replace_all(odds$variable, "_", " ")
odds$variable <- str_replace_all(odds$variable, "Gyration radius", "Radius of gyration")
odds$variable <- str_replace_all(odds$variable, "Number post 30days", "Number of posts")
odds$variable <- str_replace_all(odds$variable, "Out-degree", "Out-degree")

pale <- c("#440154","#35b779", "#fde725",   "#31688e")
t1 <- ggplot(odds, aes(x=fct_inorder(variable), y = value, ymin = low, ymax = high)) + 
  geom_hline(yintercept=0, linetype="dashed", colour="grey55", size=0.5) +
  geom_linerange(aes(colour = model, group=model), size = 1.4, alpha = 0.8, position = position_dodge(width = 0.9)) +
  geom_point(aes(colour = model), size=1.5, position = position_dodge(width = 0.9)) +
  #scale_color_manual(values=c(inferno(256)[10], inferno(256)[60], inferno(256)[120], inferno(256)[210])) +
  scale_color_manual(values=pale) +
  scale_y_continuous(limits = c(-0.5, 1.05)) +
  scale_x_reordered() +
  coord_flip() + theme_bw()  +  theme(
    plot.background = element_blank()
    ,panel.grid.major = element_blank()
    ,panel.grid.minor = element_blank()
    ,legend.title = element_blank(),
    legend.position = "none",
    axis.text.x = element_text(color = "black", size = 12, face = "bold"),
    axis.text.y = element_text(color = "black", size = 12, face = "bold"),
    axis.title.x = element_text(color = "black", size = 16),
    strip.background = element_rect(fill="white")
  ) + labs(x = "", y = bquote('Normalized coefficients'))
t1

ggsave("result.pdf")