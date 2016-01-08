# Keyboard-Manager-Demo

Describe the difference of handling keyboard.

I try to display:

- When keyboard was showed, pressin home button make app to enter background and then activate it by tap app icon, user will see different behaviors in different iOS version (8 and 9).
- How to handle keyboard.

### Behavior

- In iOS9, the view will be shifted by the callback of notification while app enter into background.
- Before iOS9 (iOS 8), the view will be reset.

You don't see these bugs in my code because I solve it. But you can comment out some part of the code to check these bugs and how to solve them.

In main View Controller, you will see two kind of way to embed text field: **view** and **scroll view**.
