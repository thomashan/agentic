# Test Prompts for hardware monitoring

## Local LLMs

```
write me the longest story in english about a software engineer called Thomas Han. your train of thought should be in
english and you should write in english. 
```

It is likely the prompt will completely blow up the local LLM and will write gibberish, but it is a good test of the
hardware monitoring tools to see how they handle the load.

```
write me the longest story which you can fit in your context window and in english about a software engineer called 
Thomas Han. your train of thought should be in english and you should write in english. the story should be as long as 
possible, but not longer than your context window.
```

This should be more manageable, but still a good test of the hardware monitoring tools to see how they handle the load.
