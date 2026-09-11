# Spec driven development


## The workflow

1. Add or edit an existing spec. 
    a. This is an interactive interview between the human and the agent. The agent will predict sensible defaults for each section of the spec and the user and the agent will go back and forth until the spec is complete
    b. The user will approve the spec.
    c. The agent will spawn sub agents to review the spec and look for gaps. If gaps are found the user will be prompted again and again until the spec is complete.
2. A design is created
    a. The agent will come up with a design against the spec.
    b. The user will add notes and change the design, this is interactive.
    c. Once the user is happy with the design, the agent will spawn a subagent to review the design against the spec.
    d. If there are gaps, the agent must report them back for the spec or the design to accommodate for whatever gaps there may be.
    e. Only once the design and the spec agree with each other can the design be approved.
3. Implementation planning
    a. The agent will create an implementation plan, this can either be to swarm tasks in parallel or one after the other.
    b. A final review will occur of the plan against the design. 
4. Implementation and review. 
    a. The agents will go and implement the plan, working the waves in order and running as many steps in parallel as each wave allows. 
    b. After each wave the agent runs the automated tests. This is a build gate and not a review: if the suite passes, the next wave starts immediately. Nobody reads the diff and nobody approves anything yet.
    c. The agents run the plan through to its last step without stopping for review. The only thing that halts them is a step revealing behaviour the spec or the design does not cover, which goes back to that document as an open question.
    d. Once the whole spec is implemented, a subagent must spawn to review all changes against the plan, design and spec.
    e. The user reviews the finished feature last, and either accepts it or sends it back with changes.
