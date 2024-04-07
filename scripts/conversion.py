import torch
from transformers import AutoModelForDepthEstimation, AutoImageProcessor, AutoConfig
import coremltools as ct
from PIL import Image
import sys


image_path = sys.argv[1]
example_input = torch.randn(1, 3, 224, 224)
# Model to Pytorch Object Script


def model_to_torch_object():
    image = Image.open(image_path).convert("RGB")
    image_processor = AutoImageProcessor.from_pretrained("LiheYoung/depth-anything-small-hf")
    inputs = image_processor(images=image, return_tensors="pt")
    # Load the Hugging Face model
    model_name = "LiheYoung/depth-anything-small-hf"
    config = AutoConfig.from_pretrained(model_name)
    model = AutoModelForDepthEstimation.from_pretrained(model_name, config=config)
    
    traced_model = torch.jit.trace(model,example_input, strict= False)
    torch.jit.save(traced_model, "DepthModel.pt")



# Conversion of trace model to CoreML

def model_conversion():
    #Load Trace Model
    traced_model = torch.jit.load("DepthModel.pt")
    mlmodel = ct.convert(
        traced_model,
        source= "pytorch",
        inputs=[ct.ImageType(name=image_path, shape= example_input.shape)],
        convert_to= "mlprogram",
        minimum_deployment_target= ct.target.iOS15)

    # Save the Core ML model
    mlmodel.save("DepthModel.mlmodel")


model_to_torch_object()
model_conversion()
