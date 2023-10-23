# Game 3: Tower Defense

this project: https://github.com/gdquest-demos/godot-2d-tower-defense
tutorial here (paywall): https://gdquest.mavenseed.com/lessons/introduction-b16cad72d594b2eb

I like that the project starts with a "project overview" explaining the UI
and game play interactions. This is a bit like a design doc.

Implementation tip: separate concerns (UI and Gameplay) and use signals to communicate.

Adding a description that's visible in the editor can be achieved via `##` comments. ([source](https://github.com/godotengine/godot/pull/41095))

```
## Armor reduces incoming damage
@export var armor := 0
```

Breakpoints! So easy to apply in Godot editor, to freeze + inspect state. Use em.
