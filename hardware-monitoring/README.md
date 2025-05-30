# List of hardware monitoring tools

The majority of the tools will be cli-based, but some may have GUI options.
The reason for this is that cli tools are more lightweight and can be used in scripts or automation.
When you are remotely accessing a machine, only cli tools are available unless video forwarding or remote desktop is
set up. For distributed training or inference, network monitoring is also important.

The focus is not to provide a comprehensive list of all tools, but rather to highlight some of the most useful ones
that I have found. I will rely on the community to provide additional tools that they find useful.

I consider many of these tools to be essential for monitoring hardware performance, for AI interfacing, training, LLMs
GenAI for images and video, and other tasks that require significant computational resources.
We are truly standing on the shoulders of giants, and these tools help us to understand and optimise our hardware
usage.

## MacOS

### General

* asitop (https://github.com/tlkh/asitop)
* pumas (https://github.com/graelo/pumas)

## Linux

### GPU

* nvidia-smi (https://developer.nvidia.com/nvidia-system-management-interface)
* nvitop (https://github.com/XuehaiPan/nvitop)
