---
title: "Lightning: A introduction"
date: 2022-09-27T11:32:21+07:00
lastmod:
toc: true
draft: true
comment: true
description: Lightning is the Pytorch framework for you, researchers. You just do the research and Lightning will do everything else. This post will introduce the Lightning and its features, utilization and also general workflow with it. 
---

## 1. What is Lightning?
Lightning makes coding complex networks simple.

## 2. Features and utilization
### Run your code on any hardware

### Performance and bottleneck profiler

### Training phase
#### Model checkpointing

#### 16-bit precision

#### Run distributed training

#### Logging

#### Metrics

#### Visualization

#### Early stopping

### Deployment phase

## 3. General workflow in Lightning
Make sure that you have installed pytorch-lightning successfully on your local computer or server. Just run the pip command bellow to install ptorch-lightning.
```shell script
pip install pytorch-lightning
```

### Step 1. Add requirements into your program
```python
import os
import torch
from torch import nn
import torch.nn.functional as F
from torchvision.datasets import MNIST
from torch.utils.data import DataLoader, random_split
from torchvision import transformers
import pytorch_lightning as pl
```

### Step 2. Define a Lightning Module (nn.Module.subclass)
You need to define a class derived from pl.LightningModule. This instance of class will be a full system for training, evaluation or deployment.

```python
class LitAutoEncoder(pl.LightningModule):
    def __init__(self):
        super().__init__()
        self.encoder = nn.Sequential(nn.Linear(28 * 28, 128), nn.ReLU(), nn.Linear(128, 3))
        self.decoder = nn.Sequential(nn.Linear(3, 128), nn.ReLU(), nn.Linear(128, 28 * 28))

    def forward(self, x):
        # in lightning, forward defines the prediction/inference actions
        embedding = self.encoder(x)
        return embedding

    def training_step(self, batch, batch_idx):
        # training_step defines the train loop. It is independent of forward
        x, y = batch
        x = x.view(x.size(0), -1)
        z = self.encoder(x)
        x_hat = self.decoder(z)
        loss = F.mse_loss(x_hat, x)
        self.log("train_loss", loss)
        return loss

    def configure_optimizers(self):
        optimizer = torch.optim.Adam(self.parameters(), lr=1e-3)
        return optimizer

autoencoder = LitAutoEncoder()
```
Note that `training_step` method defines the training loop and `foward` method defines how the LightningModule behaves during inference/prediction.

### Step 3. Define a dataset
```python
dataset = MNIST(os.getcwd(), download=True, transform=transforms.ToTensor())
train, val = random_split(dataset, [55000, 5000])
```

### Step 4. Training model
```python
trainer = pl.Trainer()
trainer.fit(autoencoder, DataLoader(train), DataLoader(val))
```

### Step 5. Model inference
```python
checkpoint = "./lightning_logs/version_0/checkpoints/epoch=0-step=100.ckpt"
autoencoder = LitAutoEncoder.load_from_checkpoint(checkpoint, encoder=encoder, decoder=decoder)

encoder = autoencoder.encoder
encoder.eval()

fake_image_batch = Tensor(4, 28 * 28)
embeddings = encoder(fake_image_batch)
print("⚡" * 20, "\nPredictions (4 image embeddings):\n", embeddings, "\n", "⚡" * 20)
```

### Step 6. Visualize training
Using Tensorboard, Lightning provide us visualizing experiments, just run this on your commandline and open your browser to http://localhost:6006/
```shell script
tensorboard --logdir .
```