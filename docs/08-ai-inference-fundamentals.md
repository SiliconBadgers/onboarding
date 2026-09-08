# AI inference fundamentals

> [!IMPORTANT]
> If you're viewing this in VS Code, press **Ctrl+Shift+V** to display this document correctly.

[Start here](../README.md) · Document 8 of 10

*Everyone. Work through the numbers; no Python installation or coding is needed.*

> [!TIP]
> **Watch this first:** [But what is a neural network?](https://www.youtube.com/watch?v=aircAruvnKk) by 3Blue1Brown. It uses 28×28 handwritten digits to introduce neurons, layers, weights, biases, and activations—the same ideas we use below.

### Before you read

This doc is complicated. You will NOT understand everything the first time. That's ok! Use AI to dumb things down, and if you're still stuck feel free to ask one of the
more experienced club members for help. Once you understand this doc you will feel smart and happy...so try your best! -Bilal

## Start with a 3×3 image

Imagine a black-and-white image stored as grayscale values: 0 is black, 255 is white. One pixel fits in an unsigned byte. Eight bits have **2⁸ = 256 possible values**, including both endpoints 0 and 255.

```text
Vertical line         Horizontal line       Our chosen weights
  0  255    0            0    0    0          -1    2   -1
  0  255    0          255  255  255          -1    2   -1
  0  255    0            0    0    0          -1    2   -1
```

Multiply each pixel by the weight in the same position, then add the nine products.

- **Vertical:** only the three middle-column pixels contribute: `255×2 + 255×2 + 255×2 = 1530`.
- **Horizontal:** only the middle row contributes: `255×(−1) + 255×2 + 255×(−1) = 0`.

The middle column is rewarded; bright pixels at the sides are penalized. This particular detector gives a positive result for our vertical image and zero for our horizontal image.

A **neuron** takes inputs, computes a weighted sum, adds a **bias**, and may apply an **activation function**:

```text
neuron output = activation(sum of input × weight + bias)
```

The bias shifts the result even when the inputs stay the same. With bias −255, the vertical score becomes 1275 and the horizontal score becomes −255. **ReLU** replaces negative values with zero, so those outputs become 1275 and 0.

We chose these weights ourselves to make the math visible. A trained network learns weights and biases from examples; individual hidden neurons aren't guaranteed to be clean “line detectors.” This example uses one weighted sum over the whole 3×3 image, not a sliding convolution.

## Training versus inference

During **training**, software predicts answers on labeled examples, measures error, and updates weights and biases to improve the predictions. The network structure—such as how many neurons it has—is chosen by the designer.

During **inference**, a new image passes through the network using the learned weights and biases. Those parameters stay fixed while processing the image. Our accelerator is for inference; it doesn't train the network.

## Scale up to MNIST

MNIST contains 28×28 grayscale images of handwritten digits, with labels 0–9. We'll use this model as our worked example:

```text
28×28 image → 784 inputs → Linear(784, 128) → ReLU → Linear(128, 10) → prediction
```

Flattening means listing pixels row by row. Pixel at row `r`, column `c` goes at index `r×28+c`. Row 0 occupies locations 0–27, row 1 occupies 28–55, and the last pixel is location 783. We changed the arrangement, not the number of values.

The first **layer** contains 128 neurons. Each neuron sees all 784 inputs, so it needs 784 weights and one bias. That gives **128×784 = 100,352 weights** and **128 biases**.

For neuron 0:

```text
s0 = x[0]×W1[0][0] + x[1]×W1[0][1] + ... + x[783]×W1[0][783] + b1[0]
h[0] = ReLU(s0)
```

Repeat that for neurons 1–127 to get 128 hidden activations. An **activation** is a value produced or passed through the network; a **weight** is a learned coefficient. The hidden activations depend on the current image.

The second layer has 10 neurons, each consuming those 128 hidden activations. It needs **10×128 = 1,280 weights** and **10 biases**. Its outputs are **logits**, or unnormalized class scores. For example:

```text
digit:   0   1   2   3   4   5   6    7   8   9
score:  -4   2   0  -1   3  -2   1   12   5   0
```

The largest score is at index 7, so the prediction is “7.” Taking the index of the largest value is **argmax**. We don't need softmax probabilities just to choose the largest score.

PyTorch is a software framework for defining and training models. Its `Linear(784, 128)` operation performs those 128 weighted sums and biases. A trained model includes the operation structure and learned parameter values—not a precomputed answer for every image. See [PyTorch Linear](https://docs.pytorch.org/docs/2.9/generated/torch.nn.Linear.html) and [MNIST](https://docs.pytorch.org/vision/stable/generated/torchvision.datasets.MNIST.html).

## Quantization: fitting numbers into bytes

Training often uses floating-point values such as 0.25. For our teaching hardware example, activations and weights use **INT8**, signed eight-bit integers, while sums and biases use **INT32**, signed 32-bit integers.

Raw image bytes are **unsigned 0–255**. Signed INT8 is **−128–127**. They occupy the same number of bits but interpret those bits differently: putting raw 255 straight into a signed byte would read as −1.

We therefore convert the image deliberately. In this example:

```text
normalized pixel = raw_pixel / 255
input INT8 value = round(normalized pixel × 127)

raw 0   → 0
raw 128 → 64
raw 255 → 127
```

Each converted activation still occupies one byte. This simple scaling uses signed storage even though these particular inputs are nonnegative.

For weights, a **scale** says how much one integer step represents. If the weight scale is 0.125, weight 0.25 becomes integer 2, and −0.375 becomes −3:

```text
integer = round(real value / scale), clamped to the allowed integer range
approximate real value = integer × scale
```

This example uses zero-point 0. Other quantization schemes also use a zero-point offset; the compiler and hardware must agree on the convention. Quantization trades some precision for smaller storage and simpler arithmetic.

Products and sums need more bits. Even one `127×127` product is 16,129, and a neuron adds hundreds of products. Accumulate into 32 bits; don't squeeze each partial sum back into an 8-bit register. Biases must use the same units as that sum: with zero-point 0, their scale is **input scale × weight scale**.

After a hidden layer, apply ReLU and **requantize** the wide result back to the next layer's INT8 scale, including saturation to the allowed range. This isn't just taking the bottom eight bits. Our example uses one weight scale per layer, so the ten final INT32 scores share a scale and can be compared directly. With different scales per output neuron, convert the scores to common units before comparing them. [More on integer quantization](https://developers.google.com/edge/litert/conversion/tensorflow/quantization/quantization_spec).

For one tiny worked sum, pretend only the first three inputs have nonzero contributions:

```text
input integers:       0, 127, 64
weight integers:     -1,   2, -1
bias integer:         5

accumulator: 0 → 0 → 254 → 190 → 195 after bias
ReLU: 195
example output rescaling by 1/8: floor(195/8) = 24
stored hidden activation: 24
```

For this example the output scale is eight times the product scale, so a right shift by 3 implements the division. Actual layer scaling is chosen from the trained model; rounding and scaling rules must match in software and RTL. An output above 127 would clamp to 127 in this signed INT8 example.

---

[← Previous: Chip design](07-chip-design.md) · [Start here](../README.md) · [Next: Accelerator full stack →](09-accelerator-full-stack.md)
